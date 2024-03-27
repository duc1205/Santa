import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/notification/data/repositories/notification_repository.dart';
import 'package:santapocket/modules/notification/domain/models/notification.dart';

@lazySingleton
class GetNotificationsUsecase {
  final NotificationRepository _notificationRepository;

  GetNotificationsUsecase(this._notificationRepository);

  Future<List<Notification>> run(ListParams listParams) => _notificationRepository.getNotifications(listParams);
}
