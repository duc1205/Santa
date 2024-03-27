import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/notification/data/datasources/notification_remote_datasource.dart';
import 'package:santapocket/modules/notification/domain/models/notification.dart';
import 'package:santapocket/modules/notification/domain/models/system_notification.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class NotificationRepository {
  final NotificationRemoteDatasource _notificationRemoteDatasource;

  NotificationRepository(this._notificationRemoteDatasource);

  Future<int> countUnread() => _notificationRemoteDatasource.countUnread();

  Future<int> getTotalSystemNotification() => _notificationRemoteDatasource.getTotalSystemNotification();

  Future<List<Notification>> getNotifications(ListParams listParams) => _notificationRemoteDatasource.getNotifications(listParams);

  Future<List<SystemNotification>> getSystemNotifications(ListParams listParams) => _notificationRemoteDatasource.getSystemNotifications(
        listParams,
      );

  Future<Unit> markAllAsRead() => _notificationRemoteDatasource.markAllAsRead();

  Future<Unit> readNotification(String notificationId) => _notificationRemoteDatasource.readNotification(notificationId);
}
