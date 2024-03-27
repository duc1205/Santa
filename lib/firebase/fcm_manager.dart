import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/firebase/domain/events/fcm_initial_message_navigation_event.dart';
import 'package:santapocket/firebase/notification_type.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/events/delivery_pocket_size_changed_event.dart';
import 'package:santapocket/modules/cabinet/domain/events/pocket_status_changed_event.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/delivery_detail_page.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_cancel_event.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_created_event.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_receiver_changed_event.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_reopen_request_event.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_sent_event.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_status_changed_event.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/models/reopen_request.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/delivery_authorization_detail/delivery_authorization_detail_page.dart';
import 'package:santapocket/modules/delivery_authorization/domain/events/delivery_authorization_canceled_event.dart';
import 'package:santapocket/modules/delivery_authorization/domain/events/delivery_authorization_created_event.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/get_delivery_authorization_usecase.dart';
import 'package:santapocket/modules/main/app/events/home_on_initial_notification_clicked.dart';
import 'package:santapocket/modules/marketing_campaign/domain/models/marketing_campaign.dart';
import 'package:santapocket/modules/notification/app/ui/notification_page.dart';
import 'package:santapocket/modules/notification/domain/events/notification_received_event.dart';
import 'package:santapocket/modules/notification/domain/events/notification_status_changed_event.dart';
import 'package:santapocket/modules/payment/app/ui/payment_page.dart';
import 'package:santapocket/modules/referral_campaign/domain/events/marketing_referral_campaign_finished_event.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/system_maintenance/app/ui/system_maintenance_page.dart';
import 'package:santapocket/modules/system_maintenance/domain/enums/system_maintenance_status.dart';
import 'package:santapocket/modules/system_maintenance/domain/models/system_maintenance.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/modules/user/app/ui/transaction_history/transaction_history_page.dart';
import 'package:santapocket/modules/user/app/ui/transaction_history/widget/user_cone_reward_widget.dart';
import 'package:santapocket/modules/user/domain/enums/user_cone_changing_type.dart';
import 'package:santapocket/modules/user/domain/models/user_cone_log.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/handle_fcm_user_events_usecase.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:santapocket/storage/spref.dart';

class FCMManager {
  static const String fcmBackgroundMessagePortName = "FCM_BACKGROUND_MESSAGE_PORT_NAME";

  final FirebaseMessaging _fbMessaging = FirebaseMessaging.instance;
  var _flutterNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isConfig = false;

  @pragma('vm:entry-point')
  static Future<void> backgroundMessageHandler(RemoteMessage? message) {
    if (message != null) {
      final SendPort? sendPort = IsolateNameServer.lookupPortByName(fcmBackgroundMessagePortName);
      sendPort?.send(json.encode(message.data));
    }
    return Future.value();
  }

  FCMManager() {
    _initNotification();
    _setupReceiveFCMBackgroundMessage();
  }

  void _initNotification() {
    const initializationSettingsAndroid = AndroidInitializationSettings('ic_notification_border');
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      requestCriticalPermission: false,
    );
    const initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    _flutterNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _flutterNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: _onSelectedNotification);
  }

  Future<void> _onClickLocalNotificationLaunchApp() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails = await _flutterNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final notificationResponse = notificationAppLaunchDetails?.notificationResponse;
      if (notificationResponse != null) {
        await _onSelectedNotification(notificationResponse);
      }
    }
  }

  void _pushNotification(RemoteMessage message) {
    locator<EventBus>().fire(NotificationReceivedEvent());
    final Map<String, dynamic> notifications = _getNotification(message.data);

    final RemoteNotification? notification = message.notification;
    final AndroidNotification? android = message.notification?.android;
    String? body;
    if (notification != null) {
      body = notification.body;
    }
    BigTextStyleInformation? bigTextStyleInformation;
    if (body != null) {
      bigTextStyleInformation = BigTextStyleInformation(body);
    }
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'global_channel',
      'Global notifications',
      channelDescription: 'All of notifications',
      importance: Importance.max,
      priority: Priority.high,
      color: AppTheme.orange,
      ticker: 'ticker',
      vibrationPattern: Int64List.fromList([0, 500]),
      styleInformation: bigTextStyleInformation,
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    if (notification != null && android != null) {
      _flutterNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: notifications["data"].toString(),
      );
    }
  }

  Future _onSelectedNotification(NotificationResponse data) async {
    if (data.payload != null) {
      await _handleNotificationClicked(data.payload.toString());
    }
  }

  void config(BuildContext context) {
    if (_isConfig) return;
    _isConfig = true;
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClicked(json.encode(message.data), isInitial: true);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) async {
      if (message != null) {
        final notifications = _getNotification(message.data);
        await _handleReceiveFCMData(notifications["data"].toString());
        _pushNotification(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? event) {
      if (event != null) {
        _handleNotificationClicked(json.encode(event.data));
      }
    });
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
    _fbMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _onClickLocalNotificationLaunchApp();
  }

  Future<void> _handleNotificationClicked(String data, {bool isInitial = false}) async {
    final user = await locator<GetProfileUsecase>().run();
    final mapData = json.decode(data) as Map<String, dynamic>;
    final type = mapData["type"];
    late final Function()? navigator;
    if (user.shouldWizardName && user.shouldWizardType) return;
    switch (type) {
      case NotificationType.deliverySent:
      case NotificationType.deliveryCanceled:
      case NotificationType.deliveryFailed:
      case NotificationType.deliveryReceived:
      case NotificationType.deliveryCompleted:
        final dataMap = json.decode(mapData["data"].toString()) as Map<String, dynamic>;
        final Map<String, dynamic> deliveryMap = dataMap["delivery"] as Map<String, dynamic>;
        final Delivery delivery = Delivery.fromJson(deliveryMap);
        navigator = () => Get.to(() => DeliveryDetailPage(
              deliveryId: delivery.id,
              isCharity: delivery.type == DeliveryType.charity,
            ));
        break;
      case NotificationType.deliveryAuthorizationRemind:
      case NotificationType.deliveryAuthorizationCreated:
        final dataMap = json.decode(mapData["data"].toString()) as Map<String, dynamic>;
        final Map<String, dynamic> deliveryMap = dataMap["delivery_authorization"] as Map<String, dynamic>;
        final DeliveryAuthorization deliveryAuthorization = DeliveryAuthorization.fromJson(deliveryMap);
        try {
          final deliveryAuthorizationDetail = await locator<GetDeliveryAuthorizationUsecase>().run(deliveryAuthorization.id);
          navigator = () => Get.to(() => DeliveryAuthorizationDetailPage(
                deliveryAuthorizationId: deliveryAuthorization.id,
                isCharity: deliveryAuthorizationDetail.delivery?.type == DeliveryType.charity,
              ));
        } catch (_) {}
        break;
      case NotificationType.deliveryAuthorizationReceiverNotEnoughBalance:
        final dataMap = json.decode(mapData["data"].toString()) as Map<String, dynamic>;
        final Map<String, dynamic> deliveryMap = dataMap["delivery_authorization"] as Map<String, dynamic>;
        final DeliveryAuthorization deliveryAuthorization = DeliveryAuthorization.fromJson(deliveryMap);
        navigator = () => Get.to(() => DeliveryDetailPage(
              deliveryId: deliveryAuthorization.deliveryId,
              isCharity: deliveryAuthorization.delivery?.type == DeliveryType.charity,
            ));
        break;
      case NotificationType.deliveryCharged:
      case NotificationType.deliveryRefunded:
      case NotificationType.userBalanceChanged:
      case NotificationType.userBalanceTransferred:
        navigator = () => Get.to(() => const TransactionHistoryPage());
        break;
      case NotificationType.userConeChangedNotification:
        navigator = () => Get.to(() => const TransactionHistoryPage(isConeTab: true));
        break;
      case NotificationType.userFreeUsageChanged:
        navigator = () => Get.to(() => const NotificationPage());
        break;
      case NotificationType.marketingCampaignNotification:
        final dataMap = json.decode(mapData["data"].toString()) as Map<String, dynamic>;
        final Map<String, dynamic> marketingCampaignMap = dataMap["marketing_campaign"] as Map<String, dynamic>;
        final MarketingCampaign marketingCampaign = MarketingCampaign.fromJson(marketingCampaignMap);
        if (marketingCampaign.postUrl == null) {
          break;
        }
        if (marketingCampaign.postUrl!.contains("/topup")) {
          navigator = () => Get.to(() => const PaymentPage());
        } else {
          String url = marketingCampaign.postUrl!;
          if (marketingCampaign.needAccessToken == true) {
            final accessToken = await SPref.instance.getAccessToken();
            url += "${url.contains("?") ? "&" : "?"}access_token=$accessToken";
          }
          navigator = () => Get.to(
                () => WebViewPage(url: url),
              );
        }
        break;
      case NotificationType.systemMaintenanceStatusChanged:
        final systemMaintenance = SystemMaintenance.fromJson(mapData["system_maintenance"]);
        navigator = systemMaintenance.status == SystemMaintenanceStatus.maintaining
            ? () => Get.offAll(() => SystemMaintenancePage(runningSystemMaintenance: systemMaintenance))
            : null;
        break;
      case NotificationType.surpriseSampleRecalling:
        final accessToken = await SPref.instance.getAccessToken();
        final dataMap = json.decode(mapData["data"].toString()) as Map<String, dynamic>;
        final Map<String, dynamic> sample = dataMap["sample"] as Map<String, dynamic>;
        final qrUrl = sample['qr_url'] as String;
        navigator = () => Get.to(() => WebViewPage(url: "$qrUrl?src=app&access_token=${(accessToken ?? "")}"));
        break;
      case NotificationType.surpriseCampaignNotification:
        final accessToken = await SPref.instance.getAccessToken();
        final dataMap = json.decode(mapData["data"].toString()) as Map<String, dynamic>;
        final Map<String, dynamic> campaignData = dataMap["campaign"] as Map<String, dynamic>;
        final campaignId = campaignData['id'] as String;
        navigator =
            () => Get.to(() => WebViewPage(url: "${Config.baseSurpriseUrl}/campaign/$campaignId?src=app&access_token=${(accessToken ?? "")}"));
        break;
      case NotificationType.marketNotification:
        try {
          final marketServiceUrlTemp = (await locator<GetSettingUsecase>().run(Constants.marketServiceUrlSetting)).value as String;
          final accessToken = await SPref.instance.getAccessToken();
          navigator = () => Get.to(() => WebViewPage(url: "$marketServiceUrlTemp?src=app&access_token=${(accessToken ?? "")}"));
        } catch (_) {}
        break;
      case NotificationType.referralReferReward:
      case NotificationType.referralReferredReward:
      default:
        navigator = null;
        break;
    }
    if (isInitial) {
      locator<EventBus>().fire(const HomeOnInitialNotificationClicked());
      if (navigator != null) {
        locator<EventBus>().fire(FCMInitialMessageNavigationEvent(navigationCall: navigator));
      }
    } else {
      navigator?.call();
    }
  }

  Future _handleReceiveFCMData(String data) async {
    final mapData = json.decode(data) as Map<String, dynamic>;
    final String type = mapData["type"].toString();
    final String fcmData = mapData["data"].toString();

    switch (type) {
      case NotificationType.deliveryStatusChanged:
        final deliveryMap = json.decode(fcmData) as Map<String, dynamic>;
        final Map<String, dynamic> deliveryData = deliveryMap["delivery"] as Map<String, dynamic>;
        final Delivery delivery = Delivery.fromJson(deliveryData);
        locator<EventBus>().fire(DeliveryStatusChangedEvent(delivery: delivery));
        break;
      case NotificationType.pocketStatusChanged:
        final deliveryMap = json.decode(fcmData) as Map<String, dynamic>;
        final Map<String, dynamic> pocketData = deliveryMap["pocket"] as Map<String, dynamic>;
        final Pocket pocket = Pocket.fromJson(pocketData);
        locator<EventBus>().fire(PocketStatusChangedEvent(pocket: pocket));
        break;
      case NotificationType.deliveryCreated:
        final deliveryMap = json.decode(fcmData) as Map<String, dynamic>;
        final Map<String, dynamic> deliveryData = deliveryMap["delivery"] as Map<String, dynamic>;
        final Delivery delivery = Delivery.fromJson(deliveryData);
        locator<EventBus>().fire(DeliveryCreatedEvent(delivery: delivery));
        break;
      case NotificationType.notificationStatusChanged:
        locator<EventBus>().fire(NotificationStatusChangedEvent());
        break;
      case NotificationType.deliveryAuthorizationRemind:
      case NotificationType.deliveryAuthorizationCreated:
        final deliveryAuthorizationMap = json.decode(fcmData) as Map<String, dynamic>;
        final Map<String, dynamic> deliveryMap = deliveryAuthorizationMap["delivery_authorization"] as Map<String, dynamic>;
        final DeliveryAuthorization deliveryAuthorization = DeliveryAuthorization.fromJson(deliveryMap);
        locator<EventBus>().fire(DeliveryAuthorizationCreatedEvent(deliveryAuthorization));
        break;
      case NotificationType.userBalanceChanged:
      case NotificationType.userFreeUsageChanged:
        await locator<HandleFcmUserEventsUsecase>().run(type, fcmData);
        break;
      case NotificationType.systemMaintenanceStatusChanged:
        final data = jsonDecode(fcmData) as Map<String, dynamic>;
        final systemMaintenance = SystemMaintenance.fromJson(data["system_maintenance"]);
        if (systemMaintenance.status == SystemMaintenanceStatus.maintaining) {
          await Get.offAll(() => SystemMaintenancePage(runningSystemMaintenance: systemMaintenance));
        }
        break;
      case NotificationType.deliveryPocketSizeChanged:
        locator<EventBus>().fire(const DeliveryPocketSizeChangedEvent());
        break;
      case NotificationType.referralReferReward:
      case NotificationType.referralReferredReward:
      case NotificationType.userConeChangedEvent:
        final dataMap = json.decode(fcmData) as Map<String, dynamic>;
        final Map<String, dynamic> userConeLogMap = dataMap["user_cone_log"] as Map<String, dynamic>;
        final UserConeLog log = UserConeLog.fromJson(userConeLogMap);
        if (log.type == UserConeChangingType.deliveryReceivingReward || log.type == UserConeChangingType.referReward) {
          await Future.delayed(const Duration(seconds: 2));
          await Get.dialog(
            UserConeRewardWidget(userConeLog: log),
            barrierDismissible: false,
          );
        }
        await locator<HandleFcmUserEventsUsecase>().run(type, fcmData);
        break;
      case NotificationType.deliveryReceiverChanged:
        locator<EventBus>().fire(const DeliveryReceiverChangedEvent());
        break;
      case NotificationType.deliverySent:
        locator<EventBus>().fire(const DeliverySentEvent());
        break;
      case NotificationType.deliveryAuthorizationCanceled:
        locator<EventBus>().fire(const DeliveryAuthorizationCanceledEvent());
        break;
      case NotificationType.deliveryCanceled:
        final deliveryMap = json.decode(fcmData) as Map<String, dynamic>;
        final Map<String, dynamic> deliveryData = deliveryMap["delivery"] as Map<String, dynamic>;
        final Delivery delivery = Delivery.fromJson(deliveryData);
        locator<EventBus>().fire(DeliveryCancelEvent(delivery: delivery));
        break;
      case NotificationType.deliveryReopenRequestFailed:
      case NotificationType.deliveryReopenRequestCompleted:
        final reopenRequestMap = json.decode(fcmData) as Map<String, dynamic>;
        final Map<String, dynamic> reopenRequestData = reopenRequestMap["delivery_reopen_request"] as Map<String, dynamic>;
        final ReopenRequest reopenRequest = ReopenRequest.fromJson(reopenRequestData);
        locator<EventBus>().fire(DeliveryReopenRequestEvent(reopenRequest: reopenRequest));
        break;
      case NotificationType.marketingReferralCampaignFinishedEvent:
        locator<EventBus>().fire(const MarketingReferralCampaignFinishedEvent());
        break;
      default:
        break;
    }
  }

  void _setupReceiveFCMBackgroundMessage() {
    final ReceivePort receivePort = ReceivePort();
    final SendPort sendPort = receivePort.sendPort;
    IsolateNameServer.registerPortWithName(sendPort, fcmBackgroundMessagePortName);
    receivePort.listen((data) async {
      await _handleReceiveFCMData(data.toString());
    });
  }

  Map<String, dynamic> _getNotification(Map<String, dynamic>? message) {
    if (Platform.isIOS) {
      Map<String, dynamic> notification = <String, dynamic>{};
      if (message != null) {
        if (message.containsKey("aps")) {
          final aps = Map<String, dynamic>.from(message["aps"] as Map<String, dynamic>);
          final alert = Map<String, dynamic>.from(aps["alert"] as Map<String, dynamic>);
          notification = Map<String, dynamic>.from(alert);
        }
        notification["data"] = json.encode(message);
      }
      return notification;
    } else {
      final Map<String, dynamic> notification = <String, dynamic>{};
      if (message != null) {
        notification["data"] = json.encode(message);
      }
      return notification;
    }
  }
}
