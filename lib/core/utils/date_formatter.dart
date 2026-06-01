/// Hafif tarih formatlayıcı - `intl` paketi olmadan TR formatlama
class DateFormatter {
  DateFormatter._();

  static const List<String> _months = [
    'Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz',
    'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara',
  ];

  static const List<String> _weekdays = [
    'Pazartesi', 'Salı', 'Çarşamba', 'Perşembe',
    'Cuma', 'Cumartesi', 'Pazar',
  ];

  static String _two(int n) => n.toString().padLeft(2, '0');

  /// "HH:mm"
  static String hm(DateTime dt) => '${_two(dt.hour)}:${_two(dt.minute)}';

  /// "01.06.2026"
  static String date(DateTime dt) =>
      '${_two(dt.day)}.${_two(dt.month)}.${dt.year}';

  /// "1 Haz Pazartesi"
  static String dayLabel(DateTime dt) =>
      '${dt.day} ${_months[dt.month - 1]} ${_weekdays[dt.weekday - 1]}';

  /// "1 Haz 2026"
  static String shortDate(DateTime dt) =>
      '${dt.day} ${_months[dt.month - 1]} ${dt.year}';

  /// "2026-06-01" (LocalDate API formatı)
  static String iso(DateTime dt) =>
      '${dt.year}-${_two(dt.month)}-${_two(dt.day)}';
}

