import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/notification/data/repositories/notification_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class ReadNotificationUsecase {
  final NotificationRepository _notificationRepository;

  ReadNotificationUsecase(this._notificationRepository);

  Future<Unit> run(String notificationId) => _notificationRepository.readNotification(notificationId);
}
