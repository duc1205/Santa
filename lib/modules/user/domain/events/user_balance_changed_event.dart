import 'package:santapocket/modules/user/domain/models/user.dart';

class UserBalanceChangedEvent {
  final User user;

  const UserBalanceChangedEvent({required this.user});
}
