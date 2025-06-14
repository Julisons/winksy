import 'package:intl/intl.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
extension NumberFormatting on String {
  String get f {
    final formatter = NumberFormat.currency(locale: "en_US", symbol: "KES ");
    return formatter.format(this);
  }
}

extension on String {
  String kes() {
    return NumberFormat.currency(
      locale: 'en_KE',
      symbol: 'KES ',
      decimalDigits: 0, // Set to 0 decimal places
    ).format(int.parse(this));
  }
}

extension StringExtensions on String {
  /// Capitalizes the first letter of the string.
  String cap() {
    if (this.isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

extension AgeCalculator on String {

  String age() {

    DateTime? birthDate;

    if (this is DateTime) {
      birthDate = this as DateTime;
    } else {
      try {
        birthDate = DateTime.parse(this);
      } catch (_) {
        return ''; // invalid date string
      }
    }


    final today = DateTime.now();
    var age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return '$age';
  }

}


