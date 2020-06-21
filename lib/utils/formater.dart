import 'package:intl/intl.dart';

String formatDate(
  DateTime date, {
  String format = 'EEEE, d MMMM y hh:mm',
  String locale = 'id',
}) {
  if (date == null || (date?.toString()?.isEmpty ?? true)) return "";
  DateFormat dateFormat = DateFormat(format, locale);
  String result = dateFormat.format(date.toLocal());
  return result;
}
