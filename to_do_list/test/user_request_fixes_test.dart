import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/core/state/settings_store.dart';
import 'package:to_do_list/core/state/task_store.dart';
import 'package:to_do_list/core/theme/app_colors.dart';
import 'package:to_do_list/core/widgets/time_selector.dart';
import 'package:to_do_list/features/tasks/screens/home_screen.dart';
import 'package:to_do_list/features/tasks/screens/task_form_screen.dart';
import 'package:to_do_list/main.dart';

void main() {
  setUp(() {
    TaskStore.instance.reset();
    SettingsStore.instance.setAppearance('Light & bright');
  });

  tearDown(() {
    TaskStore.instance.reset();
    SettingsStore.instance.setAppearance('Light & bright');
  });

  group('Fix 1: Task creation displays on Home Screen', () {
    testWidgets('Submitting new task adds it to TaskStore and appears on HomeScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TaskFormScreen(
            mode: FormMode.create,
            onSubmit: (task) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter task title
      await tester.enterText(find.byType(TextField), 'Test My Newly Created Task');
      await tester.pumpAndSettle();

      // Scroll to and tap Create Task button
      await tester.ensureVisible(find.text('Create Task'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Create Task'));
      await tester.pumpAndSettle();

      // Verify task was saved into TaskStore
      expect(
        TaskStore.instance.activeTasks.any((t) => t.title == 'Test My Newly Created Task'),
        isTrue,
      );

      // Now verify HomeScreen displays the task
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Test My Newly Created Task'), findsOneWidget);
    });
  });

  group('Fix 2: Appearance theme switching dynamically updates colors', () {
    test('SettingsStore changes AppColors across all 4 theme palettes', () {
      // 1. Light & bright
      SettingsStore.instance.setAppearance('Light & bright');
      expect(AppColors.canvas, const Color(0xFFFAFAF8));
      expect(AppColors.textPrimary, const Color(0xFF0E0E0E));

      // 2. Warm Paper
      SettingsStore.instance.setAppearance('Warm Paper');
      expect(AppColors.canvas, const Color(0xFFF5EEDB));
      expect(AppColors.textPrimary, const Color(0xFF2C2416));

      // 3. Soft Mint
      SettingsStore.instance.setAppearance('Soft Mint');
      expect(AppColors.canvas, const Color(0xFFEEF7F2));
      expect(AppColors.textPrimary, const Color(0xFF143023));

      // 4. Dark Ink
      SettingsStore.instance.setAppearance('Dark Ink');
      expect(AppColors.canvas, const Color(0xFF16171B));
      expect(AppColors.textPrimary, const Color(0xFFF2F4F8));
    });

    testWidgets('TodoApp rebuilds with new background color when appearance changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(const TodoApp());
      await tester.pumpAndSettle();

      // Initially Light
      expect(AppColors.canvas, const Color(0xFFFAFAF8));

      // Switch to Dark Ink
      SettingsStore.instance.setAppearance('Dark Ink');
      await tester.pumpAndSettle();

      expect(AppColors.canvas, const Color(0xFF16171B));
    });
  });

  group('Fix 3: TimeSelector minute stepper steps by +- 1 min', () {
    testWidgets('Minute up and down buttons increment and decrement by 1 minute',
        (WidgetTester tester) async {
      int recordedMinute = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeSelector(
              initialHour: 6,
              initialMinute: 0,
              initialIsPm: true,
              onTimeChanged: (h, m, pm) {
                recordedMinute = m;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find the up and down arrow buttons for the minute column
      // Minute column is the second Column with uppercase label 'MINUTE'
      expect(find.text('00'), findsOneWidget);

      final upArrowButtons = find.byIcon(Icons.keyboard_arrow_up);
      // First is hour, second is minute
      final minuteUpArrow = upArrowButtons.at(1);

      // Tap +1 minute
      await tester.tap(minuteUpArrow);
      await tester.pumpAndSettle();

      expect(find.text('01'), findsOneWidget);
      expect(recordedMinute, 1);

      // Tap +1 minute again
      await tester.tap(minuteUpArrow);
      await tester.pumpAndSettle();

      expect(find.text('02'), findsOneWidget);
      expect(recordedMinute, 2);

      // Find down arrow for minute
      final downArrowButtons = find.byIcon(Icons.keyboard_arrow_down);
      final minuteDownArrow = downArrowButtons.at(1);

      // Tap -1 minute
      await tester.tap(minuteDownArrow);
      await tester.pumpAndSettle();

      expect(find.text('01'), findsOneWidget);
      expect(recordedMinute, 1);

      // Tap -1 minute back to 00
      await tester.tap(minuteDownArrow);
      await tester.pumpAndSettle();

      expect(find.text('00'), findsOneWidget);
      expect(recordedMinute, 0);

      // Tap -1 minute wraps to 59
      await tester.tap(minuteDownArrow);
      await tester.pumpAndSettle();

      expect(find.text('59'), findsOneWidget);
      expect(recordedMinute, 59);
    });
  });
}
