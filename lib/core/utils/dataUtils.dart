class DateUtilsHelper {
  DateUtilsHelper._(); // Prevent instantiation

  /// Start of today (00:00:00.000)
  static DateTime startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// End of today (23:59:59.999)
  static DateTime endOfToday() {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
      999,
    );
  }

  /// Convert DateTime to ISO (for DB)
  static String toIso(DateTime date) {
    return date.toIso8601String();
  }

  /// Parse ISO string from DB
  static DateTime fromIso(String iso) {
    return DateTime.parse(iso);
  }

  /// First day of current month (00:00)
  static DateTime startOfMonth() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  /// Last day of current month (23:59:59.999)
  static DateTime endOfMonth() {
    final now = DateTime.now();
    final lastDay = DateTime(now.year, now.month + 1, 0);
    return DateTime(
      lastDay.year,
      lastDay.month,
      lastDay.day,
      23,
      59,
      59,
      999,
    );
  }

  /// Start of a custom day
  static DateTime startOf(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// End of a custom day
  static DateTime endOf(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      23,
      59,
      59,
      999,
    );
  }

  /// Date before X days (range start)
  static DateTime daysAgo(int days) {
    return DateTime.now().subtract(Duration(days: days));
  }

  /// Last X days as range
  static DateTime startOfLastDays(int days) {
    final date = DateTime.now().subtract(Duration(days: days));
    return startOf(date);
  }

  /// Generate list of last X days (oldest → newest)
  static List<DateTime> lastDays(int count) {
    return List.generate(
      count,
      (index) => DateTime.now()
          .subtract(Duration(days: count - 1 - index)),
    );
  }

  /// Format dd/MM/yyyy
  static String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  /// Format MM/yyyy
  static String formatMonthYear(DateTime date) {
    return "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  /// Check if two dates are same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}