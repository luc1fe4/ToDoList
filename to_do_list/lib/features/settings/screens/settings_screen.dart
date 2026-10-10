import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/web/browser_notification_client.dart';
import '../../../core/state/settings_store.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_borders.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/floating_bottom_navigation.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onMoreTap;
  final ValueChanged<NavigationTab>? onNavTabChanged;
  final VoidCallback? onPreviewEmptyState;

  const SettingsScreen({
    super.key,
    this.onMoreTap,
    this.onNavTabChanged,
    this.onPreviewEmptyState,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    SettingsStore.instance.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    SettingsStore.instance.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  void _showMascotGreeting(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        backgroundColor: const Color(0xFFFFF5DC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          side: BorderSide(color: AppColors.outline, width: 2.0),
        ),
        content: Row(
          children: [
            const MascotAvatar(size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '“Take your time today. Small wins add up to big calm!” ✨',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSelectionModal({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<String> options,
    required String currentValue,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.s24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.outline,
              width: AppBorders.cardWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.sageShadow,
                offset: const Offset(0, -4),
                blurRadius: 0,
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                ...options.map((option) {
                  final isSelected = option == currentValue;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFF5DC) : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.outline,
                        width: isSelected ? 2.0 : 1.0,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          onSelected(option);
                          Navigator.of(ctx).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontFamily: AppTypography.fontFamily,
                                    fontSize: 15,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF72BF5A),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPermissionDialog(BuildContext context) {
    final store = SettingsStore.instance;
    NotificationPermissionStatus? permStatus;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            if (kIsWeb && permStatus == null) {
              NotificationService.instance.getPermissionStatus().then((status) {
                if (modalCtx.mounted) {
                  setModalState(() {
                    permStatus = status;
                  });
                }
              });
            }

            return Container(
              padding: const EdgeInsets.all(AppSpacing.s24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(
                  color: AppColors.outline,
                  width: AppBorders.cardWidth,
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.outline.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 24, color: AppColors.outline),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            kIsWeb ? 'Web Reminders & Notifications' : 'Local Reminders Permission',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      kIsWeb
                          ? 'This notebook notifies you 10 minutes before timed deadlines while the page is open. No backend or cloud account is required.'
                          : 'This app uses device-local reminder alerts to notify you for timed tasks. No cloud syncing or external notification server is needed.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    if (kIsWeb) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: permStatus == NotificationPermissionStatus.granted
                              ? const Color(0xFFE8F5E9)
                              : permStatus == NotificationPermissionStatus.denied
                                  ? const Color(0xFFFFEBEE)
                                  : const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: permStatus == NotificationPermissionStatus.granted
                                ? const Color(0xFF81C784)
                                : permStatus == NotificationPermissionStatus.denied
                                    ? const Color(0xFFE57373)
                                    : const Color(0xFFFFD54F),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              permStatus == NotificationPermissionStatus.granted
                                  ? Icons.check_circle_outline
                                  : permStatus == NotificationPermissionStatus.denied
                                      ? Icons.warning_amber_rounded
                                      : Icons.info_outline,
                              size: 18,
                              color: permStatus == NotificationPermissionStatus.granted
                                  ? const Color(0xFF2E7D32)
                                  : permStatus == NotificationPermissionStatus.denied
                                      ? const Color(0xFFC62828)
                                      : const Color(0xFFF57F17),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                permStatus == NotificationPermissionStatus.granted
                                    ? 'Browser notifications enabled'
                                    : permStatus == NotificationPermissionStatus.denied
                                        ? 'Browser notifications blocked in browser settings. In-app alerts will be used.'
                                        : permStatus == NotificationPermissionStatus.unsupported
                                            ? 'Browser notification API not supported. In-app alerts will be used.'
                                            : 'Browser notification permission not yet granted.',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: permStatus == NotificationPermissionStatus.granted
                                      ? const Color(0xFF1B5E20)
                                      : permStatus == NotificationPermissionStatus.denied
                                          ? const Color(0xFFB71C1C)
                                          : const Color(0xFFE65100),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          kIsWeb ? 'Allow browser notifications' : 'Allow notifications',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Switch(
                          value: store.notificationPermissionAllowed,
                          activeThumbColor: const Color(0xFF72BF5A),
                          onChanged: (val) async {
                            store.toggleNotificationPermission();
                            if (store.notificationPermissionAllowed) {
                              await NotificationService.instance.requestPermissions();
                              if (kIsWeb) {
                                final newStatus = await NotificationService.instance.getPermissionStatus();
                                setModalState(() {
                                  permStatus = newStatus;
                                });
                              }
                            }
                            setModalState(() {});
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    if (store.notificationPermissionAllowed) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.notifications_active_outlined, size: 18),
                          label: const Text('Send test notification'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: BorderSide(color: AppColors.outline, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            NotificationService.instance.showTestNotification();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  kIsWeb && permStatus != NotificationPermissionStatus.granted
                                      ? 'In-app reminder alert triggered! (Browser notification blocked or pending)'
                                      : 'Test notification sent! Check notification center.',
                                ),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.textPrimary,
                          foregroundColor: AppColors.surface,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text(
                          'Done',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEmptyStateModalPreview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(AppSpacing.s24),
          decoration: BoxDecoration(
            color: AppColors.canvas,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.outline,
              width: AppBorders.cardWidth,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Empty Task State Preview',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              Divider(color: AppColors.outline),
              Expanded(
                child: Center(
                  child: EmptyState(
                    title: 'Start with one small thing.',
                    description:
                        'A calm notebook is ready for whatever matters most to you right now.',
                    buttonLabel: 'Create your first task',
                    onButtonPressed: () {
                      Navigator.of(ctx).pop();
                      widget.onNavTabChanged?.call(NavigationTab.tasks);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outline,
          width: AppBorders.cardWidth,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16,
              vertical: AppSpacing.s12,
            ),
            child: Row(
              children: [
                // Light green icon container
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCF5D6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.outline,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),

                // Title
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Current preference value
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),

                // Chevron icon
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = SettingsStore.instance;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageInset,
                  vertical: AppSpacing.s16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kicker label: MAKE IT YOURS
                    Text(
                      'MAKE IT YOURS',
                      style: AppTypography.uppercaseLabel.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Header: Settings title (matching Figma frame)
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s20),

                    // Mascot Greeting Card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF5DC),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppColors.outline,
                          width: AppBorders.cardWidth,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.peachShadow,
                            offset: const Offset(3, 3),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showMascotGreeting(context),
                            child: const MascotAvatar(size: 58),
                          ),
                          const SizedBox(width: AppSpacing.s16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, task maker.',
                                  style: TextStyle(
                                    fontFamily: AppTypography.fontFamily,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'A few calm controls for your notebook.',
                                  style: TextStyle(
                                    fontFamily: AppTypography.fontFamily,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s16),

                    // Tile 1: Reminders
                    _buildSettingTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Reminders',
                      value: store.reminderPreference,
                      onTap: () {
                        _showSelectionModal(
                          context: context,
                          title: 'Default reminder',
                          subtitle: 'Select default notification time before due date.',
                          options: [
                            'At time of task',
                            '5 minutes before',
                            '10 minutes before',
                            '15 minutes before',
                            '30 minutes before',
                            '1 hour before',
                            'Off',
                          ],
                          currentValue: store.reminderPreference,
                          onSelected: (val) => store.setReminderPreference(val),
                        );
                      },
                    ),

                    // Tile 2: Appearance
                    _buildSettingTile(
                      icon: Icons.wb_sunny_outlined,
                      title: 'Appearance',
                      value: store.appearance,
                      onTap: () {
                        _showSelectionModal(
                          context: context,
                          title: 'Appearance theme',
                          subtitle: 'Choose notebook styling and paper accent.',
                          options: [
                            'Light & bright',
                            'Warm Paper',
                            'Soft Mint',
                            'Dark Ink',
                          ],
                          currentValue: store.appearance,
                          onSelected: (val) => store.setAppearance(val),
                        );
                      },
                    ),

                    // Tile 3: Week starts on
                    _buildSettingTile(
                      icon: Icons.calendar_today_outlined,
                      title: 'Week starts on',
                      value: store.weekStartsOn,
                      onTap: () {
                        _showSelectionModal(
                          context: context,
                          title: 'Week starts on',
                          subtitle: 'First day of the week in calendars and schedules.',
                          options: [
                            'Sunday',
                            'Monday',
                            'Saturday',
                          ],
                          currentValue: store.weekStartsOn,
                          onSelected: (val) => store.setWeekStartsOn(val),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.s16),

                    // Information Note Banner
                    GestureDetector(
                      onTap: () => _showPermissionDialog(context),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.s12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5DC),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: AppColors.outline,
                            width: AppBorders.cardWidth,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 20,
                              color: AppColors.outline,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Notifications will use your device’s local reminder permissions.',
                                style: TextStyle(
                                  fontFamily: AppTypography.fontFamily,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Action Button: Preview empty task state
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.outline,
                          width: AppBorders.cardWidth,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            if (widget.onPreviewEmptyState != null) {
                              widget.onPreviewEmptyState!();
                            } else {
                              _showEmptyStateModalPreview(context);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                'Preview empty task state',
                                style: TextStyle(
                                  fontFamily: AppTypography.fontFamily,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),

            // Fixed Floating Bottom Navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: FloatingBottomNavigation(
                currentTab: NavigationTab.settings,
                onTabChanged: (tab) => widget.onNavTabChanged?.call(tab),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mascot Face Avatar matching the Figma Settings frame
class MascotAvatar extends StatelessWidget {
  final double size;

  const MascotAvatar({super.key, this.size = 58});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFF7B670), // Warm peach skin
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.outline,
          width: 2.0,
        ),
      ),
      child: CustomPaint(
        painter: _MascotFacePainter(),
      ),
    );
  }
}

class _MascotFacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final eyePaint = Paint()
      ..color = AppColors.outline
      ..style = PaintingStyle.fill;

    // Two eye dots
    final eyeRadius = size.width * 0.045;
    final leftEye = Offset(size.width * 0.38, size.height * 0.46);
    final rightEye = Offset(size.width * 0.62, size.height * 0.46);

    canvas.drawCircle(leftEye, eyeRadius, eyePaint);
    canvas.drawCircle(rightEye, eyeRadius, eyePaint);

    // Cute curved smile arc
    final smilePaint = Paint()
      ..color = AppColors.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final smilePath = Path();
    smilePath.moveTo(size.width * 0.43, size.height * 0.58);
    smilePath.quadraticBezierTo(
      size.width * 0.50,
      size.height * 0.65,
      size.width * 0.57,
      size.height * 0.58,
    );

    canvas.drawPath(smilePath, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
