import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/notification/data/datasources/services/notification_service.dart';
import 'package:santapocket/modules/notification/domain/models/notification.dart';
import 'package:santapocket/modules/notification/domain/models/system_notification.dart';
import 'package:suga_core/suga_core.dart';

abstract class NotificationRemoteDatasource {
  Future<List<Notification>> getNotifications(ListParams listParams);

  Future<List<SystemNotification>> getSystemNotifications(ListParams listParams);

  Future<int> getTotalSystemNotification();

  Future<Unit> readNotification(String notificationId);

  Future<Unit> markAllAsRead();

  Future<int> countUnread();
}

@LazySingleton(as: NotificationRemoteDatasource)
class NotificationRemoteDatasourceImpl extends NotificationRemoteDatasource {
  final NotificationService _notificationService;

  NotificationRemoteDatasourceImpl(this._notificationService);

  @override
  Future<int> countUnread() => _notificationService.countUnread();

  @override
  Future<List<Notification>> getNotifications(ListParams listParams) => _notificationService.getNotifications(
        listParams.paginationParams?.limit,
        listParams.paginationParams?.page,
        listParams.sortParams?.attribute,
        listParams.sortParams?.direction,
      );

  @override
  Future<List<SystemNotification>> getSystemNotifications(ListParams listParams) async {
    final res = await _notificationService.getSystemNotifications(
      listParams.paginationParams?.limit,
      listParams.paginationParams?.page,
      listParams.sortParams?.attribute,
      listParams.sortParams?.direction,
      0,
    );
    return res.data;
  }

  @override
  Future<Unit> markAllAsRead() async {
    await _notificationService.markAllAsRead();
    return unit;
  }

  @override
  Future<Unit> readNotification(String notificationId) async {
    await _notificationService.read(notificationId);
    return unit;
  }

  @override
  Future<int> getTotalSystemNotification() async {
    final res = await _notificationService.getSystemNotifications(null, null, null, null, 1);
    return int.tryParse(res.response.headers.value("X-Total-Count") ?? '') ?? 0;
  }
}
