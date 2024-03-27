import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/notification/data/repositories/notification_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class MarkAllNotificationsAsReadUsecase {
  final NotificationRepository _notificationRepository;

  MarkAllNotificationsAsReadUsecase(this._notificationRepository);

  Future<Unit> run() => _notificationRepository.markAllAsRead();
}
