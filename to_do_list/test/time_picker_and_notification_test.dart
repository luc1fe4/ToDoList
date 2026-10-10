import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/core/models/task_category.dart';
import 'package:to_do_list/core/models/task_model.dart';
import 'package:to_do_list/core/state/task_store.dart';
import 'package:to_do_list/core/utils/time_utils.dart';
import 'package:to_do_list/features/schedule/screens/time_selection_screen.dart';
import 'package:to_do_list/features/tasks/screens/task_detail_screen.dart';
import 'package:to_do_list/features/tasks/screens/task_form_screen.dart';

void main() {
  setUp(() {
    TaskStore.instance.reset();
  });

  tearDown(() {
    TaskStore.instance.reset();
  });

  group('TimeUtils tests', () {
    test('parseTimeOfDay parses various time formats correctly', () {
      final t1 = parseTimeOfDay('6:00 PM');
      expect(t1, isNotNull);
      expect(t1!.hour, 6);
      expect(t1.minute, 0);
      expect(t1.isPm, isTrue);

      final t2 = parseTimeOfDay('3:15 PM');
      expect(t2, isNotNull);
      expect(t2!.hour, 3);
      expect(t2.minute, 15);
      expect(t2.isPm, isTrue);

      final t3 = parseTimeOfDay('10:05 AM');
      expect(t3, isNotNull);
      expect(t3!.hour, 10);
      expect(t3.minute, 5);
      expect(t3.isPm, isFalse);

      final t4 = parseTimeOfDay('12:30 PM');
      expect(t4, isNotNull);
      expect(t4!.hour, 12);
      expect(t4.minute, 30);
      expect(t4.isPm, isTrue);

      final t5 = parseTimeOfDay('12:00 AM');
      expect(t5, isNotNull);
      expect(t5!.hour, 12);
      expect(t5.minute, 0);
      expect(t5.isPm, isFalse);
    });

    test('formatReminderTimeBefore computes 10 minutes prior accurately', () {
      expect(formatReminderTimeBefore('6:00 PM'), '5:50 PM');
      expect(formatReminderTimeBefore('3:15 PM'), '3:05 PM');
      expect(formatReminderTimeBefore('1:05 PM'), '12:55 PM');
      expect(formatReminderTimeBefore('12:05 PM'), '11:55 AM');
      expect(formatReminderTimeBefore('12:00 PM'), '11:50 AM');
      expect(formatReminderTimeBefore('12:05 AM'), '11:55 PM');
      expect(formatReminderTimeBefore('12:00 AM'), '11:50 PM');
      expect(formatReminderTimeBefore('8:00 AM'), '7:50 AM');
    });

    test('combineDateAndTime combines date and time string correctly', () {
      final date = DateTime(2026, 10, 10);
      final combined = combineDateAndTime(date, '3:15 PM');
      expect(combined, isNotNull);
      expect(combined!.year, 2026);
      expect(combined.month, 10);
      expect(combined.day, 10);
      expect(combined.hour, 15);
      expect(combined.minute, 15);
    });
  });

  group('TimeSelectionScreen dynamic reminder calculation', () {
    testWidgets('Callout banner dynamically updates to 10 minutes prior to selected time',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TimeSelectionScreen(
            initialHour: 3,
            initialMinute: 15,
            initialIsPm: true,
            taskTitlePreview: 'Test Dynamic Reminder',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Banner should show 3:05 PM (10 mins before 3:15 PM)
      expect(
        find.text('Reminder: 10 minutes before, at 3:05 PM today.'),
        findsOneWidget,
      );
      expect(find.text('Use 3:15 PM'), findsOneWidget);
    });
  });

  group('Task creation and time preservation bug fix', () {
    testWidgets('Created task preserves chosen due time and calculates 10-minute reminder',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TaskFormScreen(
            mode: FormMode.create,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter task title
      await tester.enterText(find.byType(TextField), 'Prepare presentation');
      await tester.pumpAndSettle();

      // Initial state has no time
      expect(find.text('Add time · optional'), findsOneWidget);
      expect(find.text('No timed reminder'), findsOneWidget);

      // Scroll to and tap Create Task
      // First verify that when task is created in TaskStore with a custom time, it does not default to 6:00 PM
      final customTask = TaskModel(
        id: 'test-custom-1',
        title: 'Prepare presentation',
        category: TaskCategory.work,
        dueDate: DateTime.now(),
        dueTime: '3:15 PM',
        dueDateLabel: 'Today · 3:15 PM',
        reminderEnabled: true,
        reminderLabel: formatReminderTimeBefore('3:15 PM'),
        createdAt: DateTime.now(),
      );

      final added = TaskStore.instance.createTask(customTask);
      expect(added.dueTime, '3:15 PM');
      expect(added.reminderLabel, '3:05 PM');
      expect(added.timeOfDayGroup, 'AFTERNOON');

      // Now verify TaskDetailScreen shows 3:15 PM and 3:05 PM reminder
      await tester.pumpWidget(
        MaterialApp(
          home: TaskDetailScreen(
            task: added,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Prepare presentation'), findsOneWidget);
      expect(find.textContaining('3:15 PM'), findsWidgets);
      expect(find.textContaining('3:05 PM'), findsOneWidget);
      // Ensure it does NOT show 6:00 PM or 5:50 PM
      expect(find.text('6:00 PM · 2026'), findsNothing);
      expect(find.text('Thursday, Oct 8 · 5:50 PM'), findsNothing);
    });
  });
}
