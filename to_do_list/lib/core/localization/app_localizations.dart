import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/task_category.dart';
import '../models/task_model.dart';
import '../state/settings_store.dart';
import '../widgets/filter_tabs.dart';
import '../widgets/floating_bottom_navigation.dart';

/// Centralized localization service providing complete English and Vietnamese translations.
///
/// Follows Flutter's standard localization architecture with fallback to [SettingsStore.instance.language]
/// so it can be accessed in test fixtures or without an inherited Localizations scope.
class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const supportedLocales = [
    Locale('en'),
    Locale('vi'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Retrieves the current [AppLocalizations] instance.
  /// Falls back to [SettingsStore.instance.locale] if not found in context.
  static AppLocalizations of(BuildContext? context) {
    if (context != null) {
      final loc = Localizations.of<AppLocalizations>(context, AppLocalizations);
      if (loc != null) return loc;
    }
    return AppLocalizations(SettingsStore.instance.locale);
  }

  /// Direct accessor based on current [SettingsStore] setting.
  static AppLocalizations get current =>
      AppLocalizations(SettingsStore.instance.locale);

  bool get isVietnamese => locale.languageCode == 'vi';

  // ---------------------------------------------------------------------------
  // General & Navigation
  // ---------------------------------------------------------------------------
  String get appTitle => isVietnamese ? 'Ứng dụng TODO' : 'TODO App';
  String get navTasks => isVietnamese ? 'Nhiệm vụ' : 'Tasks';
  String get navCompleted => isVietnamese ? 'Đã xong' : 'Completed';
  String get navSettings => isVietnamese ? 'Cài đặt' : 'Settings';

  String navTabTitle(NavigationTab tab) {
    switch (tab) {
      case NavigationTab.tasks:
        return navTasks;
      case NavigationTab.completed:
        return navCompleted;
      case NavigationTab.settings:
        return navSettings;
    }
  }

  String get dismiss => isVietnamese ? 'Bỏ qua' : 'Dismiss';
  String get undo => isVietnamese ? 'Hoàn tác' : 'Undo';
  String get cancel => isVietnamese ? 'Hủy' : 'Cancel';
  String get delete => isVietnamese ? 'Xóa' : 'Delete';
  String get close => isVietnamese ? 'Đóng' : 'Close';
  String get change => isVietnamese ? 'Thay đổi' : 'Change';

  // ---------------------------------------------------------------------------
  // Filter Tabs
  // ---------------------------------------------------------------------------
  String get filterAll => isVietnamese ? 'Tất cả' : 'All';
  String get filterToday => isVietnamese ? 'Hôm nay' : 'Today';
  String get filterUpcoming => isVietnamese ? 'Sắp tới' : 'Upcoming';

  String filterTabTitle(TaskFilterTab tab) {
    switch (tab) {
      case TaskFilterTab.all:
        return filterAll;
      case TaskFilterTab.today:
        return filterToday;
      case TaskFilterTab.upcoming:
        return filterUpcoming;
    }
  }

  // ---------------------------------------------------------------------------
  // Home Screen
  // ---------------------------------------------------------------------------
  String get tasksTitle => isVietnamese ? 'Nhiệm vụ' : 'Tasks';
  String tasksCount(int count) =>
      isVietnamese ? '$count nhiệm vụ' : '$count tasks';

  String get subheadAll =>
      isVietnamese ? 'Hoàn thành thêm một chút.' : 'A little more done.';
  String get subheadToday =>
      isVietnamese ? 'Làm chủ ngày hôm nay.' : 'Make today yours.';
  String get subheadUpcoming =>
      isVietnamese ? 'Sắp tới.' : 'On the horizon.';

  String afterToday(String date) =>
      isVietnamese ? 'Sau hôm nay · $date' : 'After today · $date';

  String get sectionMorning => isVietnamese ? 'BUỔI SÁNG' : 'MORNING';
  String get sectionAfternoon => isVietnamese ? 'BUỔI CHIỀU' : 'AFTERNOON';
  String get sectionEvening => isVietnamese ? 'BUỔI TỐI' : 'EVENING';

  String get upcomingCallout => isVietnamese
      ? 'Chỉ những việc có ngày trong tương lai mới ở đây. Các ý tưởng chưa đặt ngày sẽ ở mục Tất cả.'
      : 'Only tasks with a future date live here. Your undated ideas stay in All.';

  String get emptyAllTitle =>
      isVietnamese ? 'Bắt đầu từ một việc nhỏ.' : 'Start with one small thing.';
  String get emptyAllDesc => isVietnamese
      ? 'Một trang giấy trắng, một tâm trí thảnh thơi. Thêm nhiệm vụ khi bạn sẵn sàng.'
      : 'A blank page, a clear head. Add a task whenever you\'re ready.';
  String get emptyAllButton =>
      isVietnamese ? 'Tạo nhiệm vụ đầu tiên' : 'Create your first task';

  String get emptyTodayTitle =>
      isVietnamese ? 'Hôm nay thật thảnh thơi.' : 'Today has room to breathe.';
  String get emptyTodayDesc => isVietnamese
      ? 'Không có việc nào đến hạn hôm nay. Hãy tận hưởng hoặc thêm một việc nhỏ.'
      : 'Nothing is due today. Enjoy the space, or add a little something.';
  String get emptyTodayButton =>
      isVietnamese ? 'Thêm việc cho hôm nay' : 'Add a task for today';

  String get emptyTodayDoneDesc => isVietnamese
      ? 'Mọi việc hôm nay đã hoàn thành. Hãy tận hưởng sự thảnh thơi!'
      : 'All tasks for today are done. Enjoy the space!';

  String get emptyUpcomingTitle =>
      isVietnamese ? 'Chưa có việc nào sắp tới.' : 'Nothing on the horizon.';
  String get emptyUpcomingDesc => isVietnamese
      ? 'Chưa có việc tương lai nào. Hãy đặt ngày sau hôm nay để việc xuất hiện ở đây.'
      : 'No future tasks yet. Give a task a date after today and it\'ll show up here.';
  String get emptyUpcomingButton =>
      isVietnamese ? 'Lên kế hoạch việc tương lai' : 'Plan a future task';

  String get emptyAllDoneTitle =>
      isVietnamese ? 'Đã xong tất cả!' : 'All done!';
  String get emptyAllDoneDesc => isVietnamese
      ? 'Mọi nhiệm vụ đã hoàn thành. Sẵn sàng thêm việc mới chưa?'
      : 'Every task has been completed. Ready to add more?';
  String get emptyAllDoneButton =>
      isVietnamese ? 'Thêm nhiệm vụ' : 'Add a task';

  String get taskCreatedSnackbar => isVietnamese
      ? 'Đã tạo nhiệm vụ · cũng được thêm vào Hôm nay'
      : 'Task created · also added to Today';

  String taskCompleteSnackbar(int count) => isVietnamese
      ? 'Hoàn thành nhiệm vụ · $count việc đã xong hôm nay'
      : 'Task complete · $count completed today';

  String taskCompleteSnackbarDetailed(int today, int week) => isVietnamese
      ? 'Hoàn thành nhiệm vụ · $today hôm nay / $week tuần này'
      : 'Task complete · $today today / $week this week';

  // ---------------------------------------------------------------------------
  // Task Form (Create & Edit)
  // ---------------------------------------------------------------------------
  String get newTask => isVietnamese ? 'Nhiệm vụ mới' : 'New Task';
  String get editTask => isVietnamese ? 'Chỉnh sửa nhiệm vụ' : 'Edit Task';
  String get formSubhead =>
      isVietnamese ? 'Bạn đang nghĩ gì?' : "What's on your mind?";
  String get formSubheadDesc => isVietnamese
      ? 'Một việc nhỏ là khởi đầu tốt.'
      : 'One small thing is a good start.';

  String get titleRequired =>
      isVietnamese ? 'TIÊU ĐỀ · BẮT BUỘC' : 'TITLE · REQUIRED';
  String get titleHint =>
      isVietnamese ? 'Ví dụ: Ôn tập ghi chú Dart' : 'e.g. Review Dart notes';

  String get dateLabel => isVietnamese ? 'Ngày' : 'Date';
  String get addDateOptional =>
      isVietnamese ? 'Thêm ngày · tùy chọn' : 'Add date · optional';

  String get timeLabel => isVietnamese ? 'Giờ' : 'Time';
  String get addTimeOptional =>
      isVietnamese ? 'Thêm giờ · tùy chọn' : 'Add time · optional';

  String get dateTimeHelper => isVietnamese
      ? 'Ngày và giờ là tùy chọn. Nhiệm vụ chỉ có ngày sẽ không có thông báo hẹn giờ.'
      : 'Date and time are optional. A date-only task has no timed reminder.';

  String get categoryOptional =>
      isVietnamese ? 'DANH MỤC · TÙY CHỌN' : 'CATEGORY · OPTIONAL';

  String get tenMinutesBefore =>
      isVietnamese ? 'Trước 10 phút' : '10 minutes before';
  String get noTimedReminder =>
      isVietnamese ? 'Không có nhắc nhở hẹn giờ' : 'No timed reminder';

  String notificationAt(String time) =>
      isVietnamese ? 'Thông báo lúc $time' : 'Notification at $time';

  String get addDateTimeToEnable => isVietnamese
      ? 'Thêm ngày và giờ để bật.'
      : 'Add a date and time to enable.';

  String get createTaskButton =>
      isVietnamese ? 'Tạo nhiệm vụ' : 'Create Task';
  String get saveChangesButton =>
      isVietnamese ? 'Lưu thay đổi' : 'Save Changes';

  String get formFooterNote => isVietnamese
      ? 'Chỉ cần tiêu đề để tạo một nhiệm vụ.'
      : 'Only a title is needed to create a task.';

  // ---------------------------------------------------------------------------
  // Categories
  // ---------------------------------------------------------------------------
  String get categoryStudy => isVietnamese ? 'Học tập' : 'Study';
  String get categoryWork => isVietnamese ? 'Công việc' : 'Work';
  String get categoryPersonal => isVietnamese ? 'Cá nhân' : 'Personal';
  String get categoryHealth => isVietnamese ? 'Sức khỏe' : 'Health';
  String get categoryNone => isVietnamese ? 'Không có' : 'None';

  String categoryLabel(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.study:
        return categoryStudy;
      case TaskCategory.work:
        return categoryWork;
      case TaskCategory.personal:
        return categoryPersonal;
      case TaskCategory.health:
        return categoryHealth;
      case TaskCategory.none:
        return categoryNone;
    }
  }

  // ---------------------------------------------------------------------------
  // Date & Time Selection Screens
  // ---------------------------------------------------------------------------
  String get chooseDate => isVietnamese ? 'Chọn ngày' : 'Choose date';
  String get chooseTime => isVietnamese ? 'Chọn giờ' : 'Choose time';

  String get kickerNewTaskSchedule =>
      isVietnamese ? 'NHIỆM VỤ MỚI / LỊCH TRÌNH' : 'NEW TASK / SCHEDULE';
  String get dateSubhead => isVietnamese ? 'Chọn một ngày.' : 'Give it a day.';
  String get timeSubhead =>
      isVietnamese ? 'Dành một chút thời gian.' : 'A little time for it.';

  String dateSelectedHelper(String date) => isVietnamese
      ? 'Đã chọn: $date. Bạn có thể để trống phần giờ.'
      : 'Selected: $date. You can leave the time blank.';

  String useDate(String date) =>
      isVietnamese ? 'Dùng $date' : 'Use $date';
  String useDateButton(DateTime date) {
    if (isVietnamese) {
      return 'Dùng ngày ${date.day} thg ${date.month}';
    }
    return 'Use ${_monthNamesEn[date.month - 1]} ${date.day}';
  }
  String get clearDate => isVietnamese ? 'Xóa ngày' : 'Clear date';

  String useTime(String time) =>
      isVietnamese ? 'Dùng $time' : 'Use $time';
  String get clearTime => isVietnamese ? 'Xóa giờ' : 'Clear time';

  String get dueTimeLocal =>
      isVietnamese ? 'HẠN CHÓT · GIỜ ĐỊA PHƯƠNG' : 'DUE TIME · LOCAL TIME';
  String get hourLabel => isVietnamese ? 'GIỜ' : 'HOUR';
  String get minuteLabel => isVietnamese ? 'PHÚT' : 'MINUTE';

  String timeReminderHelper(String time) => isVietnamese
      ? 'Nhắc nhở: Trước 10 phút, lúc $time hôm nay.'
      : 'Reminder: 10 minutes before, at $time today.';

  String quickChipToday(String dateStr) =>
      isVietnamese ? 'Hôm nay · $dateStr' : 'Today · $dateStr';
  String quickChipTomorrow(String dateStr) =>
      isVietnamese ? 'Ngày mai · $dateStr' : 'Tomorrow · $dateStr';

  // ---------------------------------------------------------------------------
  // Task Detail Screen
  // ---------------------------------------------------------------------------
  String get taskDetailsTitle =>
      isVietnamese ? 'Chi tiết nhiệm vụ' : 'Task details';
  String get completeTaskButton =>
      isVietnamese ? 'Hoàn thành nhiệm vụ' : 'Complete Task';
  String get editTaskButton =>
      isVietnamese ? 'Chỉnh sửa nhiệm vụ' : 'Edit Task';
  String get deleteTaskButton =>
      isVietnamese ? 'Xóa nhiệm vụ' : 'Delete Task';
  String get taskDetailQuote => isVietnamese
      ? 'Việc nhỏ xong. Nhẹ nhõm một phần.'
      : 'Small task. Big sigh of relief.';
  String get noReminder => isVietnamese ? 'Không nhắc nhở' : 'No reminder';
  String get allDay => isVietnamese ? 'Cả ngày' : 'All day';

  String createdOn(String date) =>
      isVietnamese ? 'Đã tạo $date' : 'Created $date';

  String get deleteConfirmTitle =>
      isVietnamese ? 'Xóa nhiệm vụ?' : 'Delete task?';
  String get deleteConfirmDesc => isVietnamese
      ? 'Bạn có chắc chắn muốn xóa nhiệm vụ này không? Thao tác này không thể hoàn tác.'
      : 'Are you sure you want to delete this task? This action cannot be undone.';

  // ---------------------------------------------------------------------------
  // Search Screen
  // ---------------------------------------------------------------------------
  String get searchTitle => isVietnamese ? 'Tìm kiếm' : 'Search';
  String get searchHint =>
      isVietnamese ? 'Tìm kiếm nhiệm vụ của bạn' : 'Search your tasks';
  String get withinCategory =>
      isVietnamese ? 'Trong danh mục' : 'Within category';

  String oneMatchUpcoming(String cat) => isVietnamese
      ? '1 kết quả · Sắp tới · $cat'
      : '1 match · Upcoming · $cat';

  String matchesCount(int count, String scope, String cat) => isVietnamese
      ? '$count kết quả · $scope · $cat'
      : '$count matches · $scope · $cat';

  String searchMatchesHeader(int count, String scope, String cat) {
    if (isVietnamese) {
      return '$count kết quả · $scope · $cat';
    }
    return '$count ${count == 1 ? 'match' : 'matches'} · $scope · $cat';
  }

  String get searchEmptyTitle =>
      isVietnamese ? 'Không tìm thấy việc nào.' : 'No little things found.';

  String searchEmptyDesc(String cat, String scope, String query) => isVietnamese
      ? 'Không có nhiệm vụ $cat nào trong mục $scope khớp với "$query". Hãy thử từ khóa khác hoặc thay đổi phạm vi.'
      : 'No $cat task in $scope matches "$query". Try another word or change your scope.';

  String get clearSearch => isVietnamese ? 'Xóa tìm kiếm' : 'Clear search';

  // ---------------------------------------------------------------------------
  // Completed Screen
  // ---------------------------------------------------------------------------
  String get kickerLittleWins =>
      isVietnamese ? 'CHIẾN THẮNG NHỎ CỦA BẠN' : 'YOUR LITTLE WINS';
  String get completedTitle => isVietnamese ? 'Đã xong' : 'Completed';
  String get doneToday => isVietnamese ? 'xong hôm nay' : 'done today';
  String get completedThisWeek =>
      isVietnamese ? 'Đã hoàn thành tuần này' : 'Completed this week';
  String get todaysWins =>
      isVietnamese ? 'Chiến thắng hôm nay' : 'Today’s wins';

  String shownCount(int count) =>
      isVietnamese ? 'Hiển thị $count' : '$count shown';

  String get emptyCompletedTitle =>
      isVietnamese ? 'Một trang mới tinh.' : 'A fresh page.';
  String get emptyCompletedDesc => isVietnamese
      ? 'Hoàn thành nhiệm vụ đầu tiên và tự thưởng cho mình một chút ghi nhận.'
      : 'Complete your first task and give yourself a little credit.';
  String get goToTasks => isVietnamese ? 'Đi đến Nhiệm vụ' : 'Go to Tasks';

  String movedBackToActive(String title) => isVietnamese
      ? '“$title” đã chuyển lại sang đang làm'
      : '“$title” moved back to active';

  String get markIncomplete =>
      isVietnamese ? 'Đánh dấu chưa xong' : 'Mark Incomplete';

  String get celebrationTitle => isVietnamese
      ? 'Ăn mừng chiến thắng nhỏ! ✨'
      : 'Little Wins Celebration! ✨';

  String celebrationSubtitle(int count) => isVietnamese
      ? 'Hôm nay đã hoàn thành $count nhiệm vụ!\nBạn đang tạo đà rất tốt.'
      : '$count tasks accomplished today!\nYou’re building wonderful momentum.';

  String get todayStat => isVietnamese ? 'Hôm nay' : 'Today';
  String get thisWeekStat => isVietnamese ? 'Tuần này' : 'This Week';
  String get paceStat => isVietnamese ? 'Tiến độ' : 'Pace';
  String get keepUpMomentum =>
      isVietnamese ? 'Tiếp tục giữ vững phong độ' : 'Keep up the momentum';

  String get rateNearlyThere => isVietnamese
      ? 'Khí thế tuyệt vời! Bạn sắp về đích rồi.'
      : 'Outstanding momentum! You’re nearly there.';
  String get rateLovelyRhythm => isVietnamese
      ? 'Bạn đang tạo nên một nhịp điệu tuyệt vời.'
      : 'You’re building a lovely rhythm.';
  String get rateSmallVictory => isVietnamese
      ? 'Mỗi chiến thắng nhỏ đều đáng quý.'
      : 'Every small victory counts.';
  String get rateBuildRhythm => isVietnamese
      ? 'Sẵn sàng xây dựng nhịp điệu mỗi ngày.'
      : 'Ready to build your daily rhythm.';

  String motivationalMessage(double rate) {
    if (rate >= 0.8) return rateNearlyThere;
    if (rate >= 0.5) return rateLovelyRhythm;
    if (rate > 0) return rateSmallVictory;
    return rateBuildRhythm;
  }

  String translateMotivationalMessage(String msg) {
    if (!isVietnamese) return msg;
    if (msg.contains('Outstanding') || msg.contains('momentum')) {
      return rateNearlyThere;
    }
    if (msg.contains('lovely rhythm')) {
      return rateLovelyRhythm;
    }
    if (msg.contains('small victory')) {
      return rateSmallVictory;
    }
    if (msg.contains('Ready to build') || msg.contains('daily rhythm')) {
      return rateBuildRhythm;
    }
    return msg;
  }

  // ---------------------------------------------------------------------------
  // Settings Screen
  // ---------------------------------------------------------------------------
  String get kickerMakeItYours =>
      isVietnamese ? 'TÙY BIẾN CHO BẠN' : 'MAKE IT YOURS';
  String get settingsTitle => isVietnamese ? 'Cài đặt' : 'Settings';
  String get greetingHeader =>
      isVietnamese ? 'Xin chào bạn.' : 'Hello, task maker.';
  String get greetingSubhead => isVietnamese
      ? 'Vài tùy chỉnh nhẹ nhàng cho cuốn sổ của bạn.'
      : 'A few calm controls for your notebook.';
  String get mascotGreeting => isVietnamese
      ? '“Cứ thong thả hôm nay. Từng việc nhỏ tích lại sẽ thành sự an yên lớn!” ✨'
      : '“Take your time today. Small wins add up to big calm!” ✨';

  String get remindersSetting => isVietnamese ? 'Nhắc nhở' : 'Reminders';
  String get appearanceSetting => isVietnamese ? 'Giao diện' : 'Appearance';
  String get weekStartsOnSetting =>
      isVietnamese ? 'Bắt đầu tuần' : 'Week starts on';
  String get languageSetting => isVietnamese ? 'Ngôn ngữ' : 'Language';

  String get previewEmptyTaskState => isVietnamese
      ? 'Xem trước trạng thái trống'
      : 'Preview empty task state';
  String get infoBannerNote => isVietnamese
      ? 'Thông báo sẽ sử dụng quyền nhắc nhở cục bộ của thiết bị.'
      : 'Notifications will use your device’s local reminder permissions.';

  // Setting Modal Dialogs
  String get defaultReminderTitle =>
      isVietnamese ? 'Nhắc nhở mặc định' : 'Default reminder';
  String get defaultReminderSubtitle => isVietnamese
      ? 'Chọn thời gian thông báo mặc định trước hạn chót.'
      : 'Select default notification time before due date.';

  String get appearanceTitle =>
      isVietnamese ? 'Chủ đề giao diện' : 'Appearance theme';
  String get appearanceSubtitle => isVietnamese
      ? 'Chọn phong cách sổ tay và điểm nhấn giấy.'
      : 'Choose notebook styling and paper accent.';

  String get weekStartsOnTitle =>
      isVietnamese ? 'Bắt đầu tuần' : 'Week starts on';
  String get weekStartsOnSubtitle => isVietnamese
      ? 'Ngày đầu tuần trong lịch và lịch biểu.'
      : 'First day of the week in calendars and schedules.';

  String get languageTitle => isVietnamese ? 'Ngôn ngữ' : 'Language';
  String get languageSubtitle => isVietnamese
      ? 'Chọn ngôn ngữ hiển thị của ứng dụng.'
      : 'Select application display language.';

  String get webRemindersTitle => isVietnamese
      ? 'Nhắc nhở & Thông báo Web'
      : 'Web Reminders & Notifications';
  String get localRemindersTitle => isVietnamese
      ? 'Quyền nhắc nhở cục bộ'
      : 'Local Reminders Permission';

  String get webRemindersDesc => isVietnamese
      ? 'Sổ tay này sẽ nhắc bạn trước 10 phút khi trang web đang mở. Không cần tài khoản đám mây hay máy chủ backend.'
      : 'This notebook notifies you 10 minutes before timed deadlines while the page is open. No backend or cloud account is required.';
  String get localRemindersDesc => isVietnamese
      ? 'Ứng dụng dùng cảnh báo cục bộ trên thiết bị cho các việc có giờ. Không cần đồng bộ đám mây hay máy chủ thông báo bên ngoài.'
      : 'This app uses device-local reminder alerts to notify you for timed tasks. No cloud syncing or external notification server is needed.';

  String get browserPermGranted => isVietnamese
      ? 'Đã bật thông báo trình duyệt'
      : 'Browser notifications enabled';
  String get browserPermDenied => isVietnamese
      ? 'Thông báo trình duyệt bị chặn trong cài đặt trình duyệt. Sẽ dùng cảnh báo trong ứng dụng.'
      : 'Browser notifications blocked in browser settings. In-app alerts will be used.';
  String get browserPermUnsupported => isVietnamese
      ? 'Trình duyệt không hỗ trợ API thông báo. Sẽ dùng cảnh báo trong ứng dụng.'
      : 'Browser notification API not supported. In-app alerts will be used.';
  String get browserPermNotGranted => isVietnamese
      ? 'Chưa cấp quyền thông báo trình duyệt.'
      : 'Browser notification permission not yet granted.';

  String get allowInBrowser =>
      isVietnamese ? 'Cho phép trong trình duyệt' : 'Allow in browser';
  String get allowReminders =>
      isVietnamese ? 'Cho phép nhắc nhở' : 'Allow reminders';
  String get testReminder =>
      isVietnamese ? 'Thử nhắc nhở' : 'Test reminder';
  String get testReminderScheduled => isVietnamese
      ? 'Đã lên lịch nhắc nhở sau 10 giây. Bạn có thể chuyển tab thử.'
      : 'Reminder scheduled for 10 seconds from now. Feel free to switch tabs.';

  String get emptyPreviewTitle =>
      isVietnamese ? 'Xem trước trạng thái trống' : 'Empty state preview';
  String get emptyPreviewSubtitle => isVietnamese
      ? 'Chọn một trạng thái để xem thử.'
      : 'Choose an empty view variant to preview.';

  // ---------------------------------------------------------------------------
  // Setting option label translators
  // ---------------------------------------------------------------------------
  String reminderOptionLabel(String value) {
    if (!isVietnamese) return value;
    switch (value) {
      case 'At time of task':
        return 'Đúng giờ nhiệm vụ';
      case '5 minutes before':
        return 'Trước 5 phút';
      case '10 minutes before':
        return 'Trước 10 phút';
      case '15 minutes before':
        return 'Trước 15 phút';
      case '30 minutes before':
        return 'Trước 30 phút';
      case '1 hour before':
        return 'Trước 1 giờ';
      case 'Off':
        return 'Tắt';
      default:
        return value;
    }
  }

  String appearanceOptionLabel(String value) {
    if (!isVietnamese) return value;
    switch (value) {
      case 'Light & bright':
        return 'Sáng & rực rỡ';
      case 'Warm Paper':
        return 'Giấy ấm áp';
      case 'Soft Mint':
        return 'Bạc hà dịu nhẹ';
      case 'Dark Ink':
        return 'Mực đen';
      default:
        return value;
    }
  }

  String weekStartsOnOptionLabel(String value) {
    if (!isVietnamese) return value;
    switch (value) {
      case 'Sunday':
        return 'Chủ nhật';
      case 'Monday':
        return 'Thứ hai';
      case 'Saturday':
        return 'Thứ bảy';
      default:
        return value;
    }
  }

  // ---------------------------------------------------------------------------
  // Date & Time formatting helpers
  // ---------------------------------------------------------------------------
  static const _monthNamesEn = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  static const _monthShortEn = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  static const _weekdayNamesEn = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  ];

  static const _weekdayNamesVi = [
    'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chủ Nhật'
  ];

  String get today => isVietnamese ? 'Hôm nay' : 'Today';
  String get tomorrow => isVietnamese ? 'Ngày mai' : 'Tomorrow';
  String get noDueDate => isVietnamese ? 'Không có hạn chót' : 'No due date';

  /// Formats date for month selector header: "October 2026" / "Tháng 10, 2026"
  String formatMonthYear(DateTime date) {
    if (isVietnamese) {
      return 'Tháng ${date.month}, ${date.year}';
    }
    return '${_monthNamesEn[date.month - 1]} ${date.year}';
  }

  /// Day headers for calendar: ['M', 'T', 'W', 'T', 'F', 'S', 'S'] vs ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
  List<String> get calendarWeekdayHeaders {
    if (isVietnamese) {
      return const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    }
    return const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  }

  /// Formats date label for quick chips and forms:
  /// English: "Today, Oct 11", "Tomorrow, Oct 12", "Oct 11, 2026"
  /// Vietnamese: "Hôm nay, 11 thg 10", "Ngày mai, 12 thg 10", "11 thg 10, 2026"
  String formatDateChip(DateTime date, {bool includeYear = false}) {
    if (isVietnamese) {
      return includeYear
          ? '${date.day} thg ${date.month}, ${date.year}'
          : '${date.day} thg ${date.month}';
    }
    final mStr = _monthShortEn[date.month - 1];
    return includeYear ? '$mStr ${date.day}, ${date.year}' : '$mStr ${date.day}';
  }

  /// Full date for headers e.g. "Thursday, October 8, 2026" / "Thứ Năm, 8 tháng 10, 2026"
  String formatSubheadDate(DateTime date, {bool includeWeekday = true, bool includeYear = false}) {
    if (isVietnamese) {
      final weekday = _weekdayNamesVi[date.weekday - 1];
      final base = '${date.day} tháng ${date.month}${includeYear ? ', ${date.year}' : ''}';
      return includeWeekday ? '$weekday, $base' : base;
    }
    final weekday = _weekdayNamesEn[date.weekday - 1];
    final month = _monthNamesEn[date.month - 1];
    final base = '$month ${date.day}${includeYear ? ', ${date.year}' : ''}';
    return includeWeekday ? '$weekday, $base' : base;
  }

  /// Locale-aware task card date label
  String formatTaskDueDateLabel(TaskModel task) {
    if (task.dueDate == null) {
      return task.dueTime != null
          ? '$today · ${task.dueTime}'
          : noDueDate;
    }

    final now = DateTime.now();
    final date = task.dueDate!;
    final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
    final tomorrowDate = now.add(const Duration(days: 1));
    final isTomorrow = date.year == tomorrowDate.year &&
        date.month == tomorrowDate.month &&
        date.day == tomorrowDate.day;

    final timePart = task.dueTime ?? allDay;

    if (isToday) {
      return '$today · $timePart';
    } else if (isTomorrow) {
      return '$tomorrow · $timePart';
    } else {
      if (isVietnamese) {
        return '${date.day} thg ${date.month} · $timePart';
      } else {
        return '${_monthShortEn[date.month - 1]} ${date.day} · $timePart';
      }
    }
  }

  /// Locale-aware task card completed label
  String formatCompletedLabel(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    if (isVietnamese) {
      return 'Xong hôm nay · $hour:$minute $period';
    }
    return 'Done today · $hour:$minute $period';
  }

  /// Translates an existing completedLabel if provided as a string
  String translateCompletedLabel(String? originalLabel) {
    if (originalLabel == null) return isVietnamese ? 'Xong hôm nay' : 'Done today';
    if (!isVietnamese) return originalLabel;
    return originalLabel
        .replaceAll('Done today', 'Xong hôm nay')
        .replaceAll('just now', 'vừa xong');
  }

  /// Translates an existing dueDateLabel if provided as a string
  String translateDueDateLabel(String? originalLabel) {
    if (originalLabel == null) return noDueDate;
    if (!isVietnamese) return originalLabel;
    return originalLabel
        .replaceAll('Today', 'Hôm nay')
        .replaceAll('Tomorrow', 'Ngày mai')
        .replaceAll('All day', 'Cả ngày')
        .replaceAll('No due date', 'Không có hạn chót');
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
