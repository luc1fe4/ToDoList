/// Time and date formatting utilities for task scheduling and reminders.
class TimeUtils {
  TimeUtils._();
}

/// Parses a 12-hour or 24-hour time string (e.g. '6:00 PM', '10:30 AM', '18:00')
/// into hour (1-12), minute (0-59), and isPm (bool).
({int hour, int minute, bool isPm})? parseTimeOfDay(String timeStr) {
  try {
    final trimmed = timeStr.trim();
    final parts = trimmed.split(RegExp(r'\s+'));
    final timePart = parts[0];
    final colonParts = timePart.split(':');
    if (colonParts.length < 2) return null;

    int hour = int.parse(colonParts[0]);
    final minute = int.parse(colonParts[1]);

    if (parts.length > 1) {
      final period = parts[1].toUpperCase();
      final isPm = period.contains('PM');
      if (hour == 0) hour = 12;
      if (hour > 12) hour = hour % 12;
      return (hour: hour, minute: minute, isPm: isPm);
    } else {
      // 24-hour format
      final isPm = hour >= 12;
      int hour12 = hour % 12;
      if (hour12 == 0) hour12 = 12;
      return (hour: hour12, minute: minute, isPm: isPm);
    }
  } catch (_) {
    return null;
  }
}

/// Computes the reminder time by subtracting [minutesBefore] (default 10)
/// from [timeStr] and returns formatted string (e.g. '6:00 PM' -> '5:50 PM').
String formatReminderTimeBefore(String timeStr, {int minutesBefore = 10}) {
  final parsed = parseTimeOfDay(timeStr);
  if (parsed == null) return '10 min before';

  return calculateReminderFromComponents(
    parsed.hour,
    parsed.minute,
    parsed.isPm,
    minutesBefore: minutesBefore,
  );
}

/// Computes the reminder time by subtracting [minutesBefore] from
/// 12-hour components [hour], [minute], [isPm].
String calculateReminderFromComponents(
  int hour,
  int minute,
  bool isPm, {
  int minutesBefore = 10,
}) {
  int hour24 = hour % 12;
  if (isPm) hour24 += 12;

  int totalMinutes = hour24 * 60 + minute - minutesBefore;
  if (totalMinutes < 0) totalMinutes += 24 * 60;

  int resHour24 = (totalMinutes ~/ 60) % 24;
  int resMinute = totalMinutes % 60;

  bool resIsPm = resHour24 >= 12;
  int resHour12 = resHour24 % 12;
  if (resHour12 == 0) resHour12 = 12;

  final minStr = resMinute.toString().padLeft(2, '0');
  final periodStr = resIsPm ? 'PM' : 'AM';
  return '$resHour12:$minStr $periodStr';
}

/// Combines a [date] and [timeStr] into a local [DateTime].
DateTime? combineDateAndTime(DateTime date, String timeStr) {
  final parsed = parseTimeOfDay(timeStr);
  if (parsed == null) return null;

  int hour24 = parsed.hour % 12;
  if (parsed.isPm) hour24 += 12;

  return DateTime(date.year, date.month, date.day, hour24, parsed.minute);
}

const _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

const _weekdayNames = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
];

/// Formats a date label for selector rows (e.g. 'Today, Oct 10', 'Tomorrow, Oct 11').
String formatDateLabel(DateTime date) {
  final now = DateTime.now();
  final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
  final tomorrow = now.add(const Duration(days: 1));
  final isTomorrow = date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;

  final monthStr = _monthNames[date.month - 1];
  if (isToday) {
    return 'Today, $monthStr ${date.day}';
  } else if (isTomorrow) {
    return 'Tomorrow, $monthStr ${date.day}';
  } else {
    final weekdayStr = _weekdayNames[date.weekday - 1];
    return '$weekdayStr, $monthStr ${date.day}';
  }
}

/// Formats a combined dueDateLabel for tasks (e.g. 'Today · 3:15 PM').
String formatDueDateLabel(DateTime? date, String? timeStr) {
  if (date == null) {
    return timeStr != null ? 'Today · $timeStr' : 'No due date';
  }

  final now = DateTime.now();
  final isToday = date.year == now.year && date.month == now.month && date.day == now.day;
  final tomorrow = now.add(const Duration(days: 1));
  final isTomorrow = date.year == tomorrow.year && date.month == tomorrow.month && date.day == tomorrow.day;

  final timePart = timeStr ?? 'All day';

  if (isToday) {
    return 'Today · $timePart';
  } else if (isTomorrow) {
    return 'Tomorrow · $timePart';
  } else {
    final monthStr = _monthNames[date.month - 1];
    return '$monthStr ${date.day} · $timePart';
  }
}
