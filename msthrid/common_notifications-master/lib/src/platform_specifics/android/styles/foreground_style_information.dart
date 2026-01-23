import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final class ForegroundStyleInformation extends DefaultStyleInformation {
  final String value;

  const ForegroundStyleInformation({required this.value}) : super(false, false);
}
