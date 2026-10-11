import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/localization/app_localizations.dart';
import 'core/services/notification_service.dart';
import 'core/state/settings_store.dart';
import 'core/state/task_store.dart';
import 'core/theme/app_theme.dart';
import 'preview/screen_preview_catalog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  await TaskStore.instance.init();
  await SettingsStore.instance.init();
  await NotificationService.instance.reconcileTasks(TaskStore.instance.activeTasks);
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsStore.instance,
      builder: (context, _) {
        final store = SettingsStore.instance;
        return MaterialApp(
          scaffoldMessengerKey: NotificationService.messengerKey,
          title: store.isVietnamese ? 'Ứng dụng TODO' : 'TODO App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          locale: store.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const ScreenPreviewCatalog(),
        );
      },
    );
  }
}
