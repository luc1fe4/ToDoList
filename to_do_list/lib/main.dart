import 'package:flutter/material.dart';
import 'core/services/notification_service.dart';
import 'core/state/settings_store.dart';
import 'core/state/task_store.dart';
import 'core/theme/app_theme.dart';
import 'preview/screen_preview_catalog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  await TaskStore.instance.init();
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
        return MaterialApp(
          key: ValueKey(SettingsStore.instance.appearance),
          scaffoldMessengerKey: NotificationService.messengerKey,
          title: 'TODO App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          home: const ScreenPreviewCatalog(),
        );
      },
    );
  }
}
