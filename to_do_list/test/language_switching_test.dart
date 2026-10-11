import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/core/localization/app_localizations.dart';
import 'package:to_do_list/core/models/task_category.dart';
import 'package:to_do_list/core/models/task_model.dart';
import 'package:to_do_list/core/state/settings_store.dart';
import 'package:to_do_list/core/state/task_store.dart';
import 'package:to_do_list/features/completed/screens/completed_screen.dart';
import 'package:to_do_list/features/search/screens/search_screen.dart';
import 'package:to_do_list/features/settings/screens/settings_screen.dart';
import 'package:to_do_list/features/tasks/screens/home_screen.dart';
import 'package:to_do_list/features/tasks/screens/task_form_screen.dart';
import 'package:to_do_list/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TaskStore.instance.reset();
    SettingsStore.instance.reset();
  });

  tearDown(() {
    TaskStore.instance.reset();
    SettingsStore.instance.reset();
  });

  group('Language Switching & Localization Tests', () {
    test('1. Default language is English', () {
      final settings = SettingsStore.instance;
      expect(settings.language, equals('English'));
      expect(settings.locale, equals(const Locale('en')));
      expect(settings.isVietnamese, isFalse);
    });

    test('2. Switching to Vietnamese updates language and locale', () async {
      final settings = SettingsStore.instance;
      bool notified = false;
      settings.addListener(() => notified = true);

      await settings.setLanguage('Tiếng Việt');

      expect(settings.language, equals('Tiếng Việt'));
      expect(settings.locale, equals(const Locale('vi')));
      expect(settings.isVietnamese, isTrue);
      expect(notified, isTrue);
    });

    test('3. Switching back to English restores English locale', () async {
      final settings = SettingsStore.instance;
      await settings.setLanguage('Tiếng Việt');
      expect(settings.isVietnamese, isTrue);

      await settings.setLanguage('English');
      expect(settings.language, equals('English'));
      expect(settings.locale, equals(const Locale('en')));
      expect(settings.isVietnamese, isFalse);
    });

    test('4. Language preference persists to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final settings = SettingsStore.instance;
      await settings.init();

      await settings.setLanguage('Tiếng Việt');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('app_language'), equals('Tiếng Việt'));

      await settings.setLanguage('English');
      expect(prefs.getString('app_language'), equals('English'));
    });

    test('5. Restores saved language upon initialization', () async {
      SharedPreferences.setMockInitialValues({'app_language': 'Tiếng Việt'});
      final settings = SettingsStore.instance;
      await settings.init();

      expect(settings.language, equals('Tiếng Việt'));
      expect(settings.locale, equals(const Locale('vi')));
      expect(settings.isVietnamese, isTrue);
    });

    testWidgets('6. Main screen and navigation update immediately when language switches',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      await SettingsStore.instance.init();

      await tester.pumpWidget(const TodoApp());
      await tester.pumpAndSettle();

      // In English default
      expect(find.text('Tasks'), findsWidgets);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('Completed'), findsWidgets);
      expect(find.text('Settings'), findsOneWidget);

      // Switch to Vietnamese
      await SettingsStore.instance.setLanguage('Tiếng Việt');
      await tester.pumpAndSettle();

      // UI text immediately updates to Vietnamese
      expect(find.text('Nhiệm vụ'), findsWidgets);
      expect(find.text('Tất cả'), findsOneWidget);
      expect(find.text('Hôm nay'), findsOneWidget);
      expect(find.text('Sắp tới'), findsOneWidget);
      expect(find.text('Đã xong'), findsWidgets);
      expect(find.text('Cài đặt'), findsOneWidget);

      // Switch back to English
      await SettingsStore.instance.setLanguage('English');
      await tester.pumpAndSettle();

      expect(find.text('Tasks'), findsWidgets);
      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('7. Settings screen displays Language option and updates UI',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      await SettingsStore.instance.init();

      await tester.pumpWidget(const TodoApp());
      await tester.pumpAndSettle();

      // Navigate to Settings
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      // Check English Settings labels
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Reminders'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Week starts on'), findsOneWidget);

      // Open Language modal
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // Select Vietnamese
      expect(find.text('Tiếng Việt'), findsWidgets);
      await tester.tap(find.text('Tiếng Việt').last);
      await tester.pumpAndSettle();

      // Verify settings screen labels are now in Vietnamese
      expect(find.text('Ngôn ngữ'), findsOneWidget);
      expect(find.text('Nhắc nhở'), findsOneWidget);
      expect(find.text('Giao diện'), findsOneWidget);
      expect(find.text('Bắt đầu tuần'), findsOneWidget);
    });

    testWidgets('8. User task content remains unchanged during language switching',
        (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      await SettingsStore.instance.init();

      const userTitle = 'Học bài kiểm tra cuối kỳ';
      TaskStore.instance.createTask(
        TaskModel(
          id: 'custom_user_task_1',
          title: userTitle,
          category: TaskCategory.study,
          dueDate: DateTime.now(),
          dueTime: '3:00 PM',
          reminderEnabled: true,
        ),
      );

      await tester.pumpWidget(const TodoApp());
      await tester.pumpAndSettle();

      // Custom task title is present in English UI
      expect(find.text(userTitle), findsOneWidget);

      // Switch to Vietnamese
      await SettingsStore.instance.setLanguage('Tiếng Việt');
      await tester.pumpAndSettle();

      // Custom task title remains exactly identical in Vietnamese UI
      expect(find.text(userTitle), findsOneWidget);

      // Task attributes in TaskStore remain intact
      final task = TaskStore.instance.getTask('custom_user_task_1');
      expect(task, isNotNull);
      expect(task!.title, equals(userTitle));
      expect(task.category, equals(TaskCategory.study));
      expect(task.dueTime, equals('3:00 PM'));
      expect(task.reminderEnabled, isTrue);
    });

    testWidgets('9. Screens render cleanly in Vietnamese on compact screen (375x812) without overflow',
        (WidgetTester tester) async {
      await SettingsStore.instance.setLanguage('Tiếng Việt');
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const delegates = [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];

      // 1. Home Screen
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: delegates,
          home: HomeScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 2. Settings Screen
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: delegates,
          home: SettingsScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 3. Completed Screen
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: delegates,
          home: CompletedScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 4. Search Screen
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: delegates,
          home: SearchScreen(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // 5. Task Form Screen
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('vi'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: delegates,
          home: TaskFormScreen(mode: FormMode.create),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
