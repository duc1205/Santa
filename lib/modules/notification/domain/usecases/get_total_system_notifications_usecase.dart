import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/notification/data/repositories/notification_repository.dart';

@lazySingleton
class GetTotalSystemNotificationsUsecase {
  final NotificationRepository _notificationRepository;

  GetTotalSystemNotificationsUsecase(this._notificationRepository);

  Future<int> run() => _notificationRepository.getTotalSystemNotification();
}
