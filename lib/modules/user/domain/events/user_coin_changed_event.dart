import 'package:santapocket/modules/user/domain/models/user.dart';

class UserCoinChangedEvent {
  final User user;

  const UserCoinChangedEvent({required this.user});
}
