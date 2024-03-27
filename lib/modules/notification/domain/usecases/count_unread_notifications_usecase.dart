import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/notification/data/repositories/notification_repository.dart';

@lazySingleton
class CountUnreadNotificationsUsecase {
  final NotificationRepository _notificationRepository;

  CountUnreadNotificationsUsecase(this._notificationRepository);

  Future<int> run() => _notificationRepository.countUnread();
}
