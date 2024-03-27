import 'package:santapocket/modules/user/domain/models/user.dart';

class UserFreeUsageChangedEvent {
  final User user;

  const UserFreeUsageChangedEvent({required this.user});
}
