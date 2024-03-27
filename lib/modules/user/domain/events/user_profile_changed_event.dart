import 'package:santapocket/modules/user/domain/models/user.dart';

class UserProfileChangedEvent {
  final User user;

  const UserProfileChangedEvent(this.user);
}
