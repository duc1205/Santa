import 'package:suga_core/suga_core.dart';

class FCMInitialMessageNavigationEvent extends Event {
  final Function() navigationCall;
  const FCMInitialMessageNavigationEvent({required this.navigationCall});
}
