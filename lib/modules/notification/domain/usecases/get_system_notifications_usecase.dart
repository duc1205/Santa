import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/notification/data/repositories/notification_repository.dart';
import 'package:santapocket/modules/notification/domain/models/system_notification.dart';

@lazySingleton
class GetSystemNotificationsUsecase {
  final NotificationRepository _notificationRepository;

  GetSystemNotificationsUsecase(this._notificationRepository);

  Future<List<SystemNotification>> run(ListParams listParams, {bool withOutData = false}) => _notificationRepository.getSystemNotifications(
        listParams,
      );
}
