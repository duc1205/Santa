import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/notification/domain/models/notification.dart';
import 'package:santapocket/modules/notification/domain/models/system_notification.dart';

part 'notification_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v${Config.apiVersion}/notifications")
abstract class NotificationService {
  @factoryMethod
  factory NotificationService(Dio dio) => _NotificationService(dio);

  @GET("/messages")
  Future<List<Notification>> getNotifications(
    @Query("limit") int? limit,
    @Query("page") int? page,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
  );

  @GET("/topics/messages")
  Future<HttpResponse<List<SystemNotification>>> getSystemNotifications(
    @Query("limit") int? limit,
    @Query("page") int? page,
    @Query("sort") String? sort,
    @Query("dir") String? dir,
    @Query("without_data") int? withoutData,
  );

  @POST("/messages/{notificationId}/read")
  Future<bool> read(@Path("notificationId") String notificationId);

  @POST("/messages/read/all")
  Future<bool> markAllAsRead();

  @GET("/messages/unread/count")
  Future<int> countUnread();
}
