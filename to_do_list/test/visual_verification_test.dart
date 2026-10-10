import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_list/core/mock/mock_tasks.dart';
import 'package:to_do_list/core/theme/app_theme.dart';
import 'package:to_do_list/core/widgets/filter_tabs.dart';
import 'package:to_do_list/features/completed/screens/completed_screen.dart';
import 'package:to_do_list/features/schedule/screens/date_selection_screen.dart';
import 'package:to_do_list/features/schedule/screens/time_selection_screen.dart';
import 'package:to_do_list/features/search/screens/search_screen.dart';
import 'package:to_do_list/features/settings/screens/settings_screen.dart';
import 'package:to_do_list/features/tasks/screens/home_screen.dart';
import 'package:to_do_list/features/tasks/screens/task_detail_screen.dart';
import 'package:to_do_list/features/tasks/screens/task_form_screen.dart';

void main() {
  const viewports = [
    Size(390, 844), // iPhone 12/13/14 standard reference
    Size(375, 812), // iPhone X / XS / Mini compact reference
  ];

  for (final size in viewports) {
    group('Visual verification at ${size.width}x${size.height}', () {
      Widget createTestHarness(Widget child) {
        return MaterialApp(
          theme: AppTheme.lightTheme,
          home: MediaQuery(
            data: MediaQueryData(
              size: size,
              padding: const EdgeInsets.only(top: 44, bottom: 34),
            ),
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: child,
            ),
          ),
        );
      }

      testWidgets('01 Home - All Tasks renders cleanly', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestHarness(const HomeScreen(initialFilter: TaskFilterTab.all)));
        await tester.pumpAndSettle();

        expect(find.text('Tasks'), findsWidgets);
        expect(find.text('A little more done.'), findsOneWidget);
        expect(find.text('Finish Flutter assignment'), findsOneWidget);
      });

      testWidgets('02 Home - Today renders grouped by time of day', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestHarness(const HomeScreen(initialFilter: TaskFilterTab.today)));
        await tester.pumpAndSettle();

        expect(find.text('Make today yours.'), findsOneWidget);
        expect(find.text('MORNING'), findsOneWidget);
        expect(find.text('AFTERNOON'), findsOneWidget);
        expect(find.text('EVENING'), findsOneWidget);
      });

      testWidgets('03 Home - Upcoming renders with callout', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestHarness(const HomeScreen(initialFilter: TaskFilterTab.upcoming)));
        await tester.pumpAndSettle();

        expect(find.text('On the horizon.'), findsOneWidget);
        expect(find.text('FRIDAY, OCTOBER 9'), findsOneWidget);
        expect(find.textContaining('Only tasks with a future date live here'), findsOneWidget);
      });

      testWidgets('04 Search - Results renders matches', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestHarness(const SearchScreen(initialVariant: SearchStateVariant.results)));
        await tester.pumpAndSettle();

        expect(find.text('Search'), findsOneWidget);
        expect(find.text('Within category'), findsOneWidget);
        expect(find.text('Study'), findsWidgets);
      });

      testWidgets('05 Create Task and 18 Ready states render cleanly', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestHarness(const TaskFormScreen(mode: FormMode.create, isReadyState: true)));
        await tester.pumpAndSettle();

        expect(find.text('New Task'), findsOneWidget);
        expect(find.text('Create Task'), findsOneWidget);
      });

      testWidgets('06 Date Selection renders calendar and quick chips', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestHarness(DateSelectionScreen(initialDate: DateTime(2026, 10, 8))));
        await tester.pumpAndSettle();

        expect(find.text('Choose date'), findsOneWidget);
        expect(find.text('Today · Oct 8'), findsOneWidget);
        expect(find.text('Tomorrow · Oct 9'), findsOneWidget);
      });

      testWidgets('07 Time Selection renders hour/minute steppers and AM/PM', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestHarness(const TimeSelectionScreen(initialHour: 6, initialMinute: 0, initialIsPm: true)));
        await tester.pumpAndSettle();

        expect(find.text('Choose time'), findsOneWidget);
        expect(find.text('HOUR'), findsOneWidget);
        expect(find.text('MINUTE'), findsOneWidget);
        expect(find.text('PM'), findsOneWidget);
      });

      testWidgets('08 Task Detail renders details, complete and edit buttons', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestHarness(TaskDetailScreen(task: MockTasks.taskFinishFlutter)));
        await tester.pumpAndSettle();

        expect(find.text('Task details'), findsOneWidget);
        expect(find.text('Complete Task'), findsOneWidget);
        expect(find.text('Edit Task'), findsOneWidget);
        expect(find.text('Delete Task'), findsOneWidget);
      });

      testWidgets('10 Completed renders metric cards and completed tasks', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestHarness(const CompletedScreen(isEmpty: false)));
        await tester.pumpAndSettle();

        expect(find.text('Completed'), findsWidgets);
        expect(find.text('YOUR LITTLE WINS'), findsOneWidget);
        expect(find.text('done today'), findsOneWidget);
        expect(find.text('Today’s wins'), findsOneWidget);
        expect(find.text('Completed this week'), findsOneWidget);
        expect(find.text('Finish Flutter assignment'), findsOneWidget);
        expect(find.text('Reply to Maya'), findsOneWidget);
        expect(find.text('Refill water bottle'), findsOneWidget);
      });

      testWidgets('15 Settings renders notifications and categories', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestHarness(const SettingsScreen()));
        await tester.pumpAndSettle();

        expect(find.text('Settings'), findsWidgets);
        expect(find.text('MAKE IT YOURS'), findsOneWidget);
        expect(find.text('Hello, task maker.'), findsOneWidget);
        expect(find.text('Reminders'), findsOneWidget);
        expect(find.text('Appearance'), findsOneWidget);
        expect(find.text('Week starts on'), findsOneWidget);
        expect(find.text('Preview empty task state'), findsOneWidget);
      });

      testWidgets('Empty states render without layout overflow', (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(createTestHarness(const HomeScreen(emptyVariant: HomeEmptyVariant.allEmpty)));
        await tester.pumpAndSettle();

        expect(find.text('Start with one small thing.'), findsOneWidget);
        expect(find.text('Create your first task'), findsOneWidget);
      });
    });
  }
}
