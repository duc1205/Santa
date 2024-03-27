import 'package:santapocket/modules/user/domain/models/user.dart';

class UserConeChangedEvent {
  final User user;

  const UserConeChangedEvent({required this.user});
}
