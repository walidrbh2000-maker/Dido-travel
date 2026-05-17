extension DateExtensions on DateTime {
  String get toFormattedDate =>
      '$day/${month.toString().padLeft(2, '0')}/$year';

  String get toFormattedDateTime =>
      '$day/${month.toString().padLeft(2, '0')}/$year ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  String get toShortDate => '$day $_monthName';

  String get toFullDate => '$day $_monthFullName $year';

  String get _monthName {
    const months = [
      '', 'Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun',
      'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'
    ];
    return months[month];
  }

  String get _monthFullName {
    const months = [
      '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month];
  }
}

extension IntDigitExtension on int {
  String get twoDigits => toString().padLeft(2, '0');
}
