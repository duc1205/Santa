import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/helpers/pagination_params.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_delivery_usecase.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/get_delivery_authorization_usecase.dart';
import 'package:santapocket/modules/notification/domain/events/notification_received_event.dart';
import 'package:santapocket/modules/notification/domain/models/notification.dart';
import 'package:santapocket/modules/notification/domain/models/system_notification.dart';
import 'package:santapocket/modules/notification/domain/usecases/get_total_system_notifications_usecase.dart';
import 'package:santapocket/modules/notification/domain/usecases/count_unread_notifications_usecase.dart';
import 'package:santapocket/modules/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:santapocket/modules/notification/domain/usecases/get_system_notifications_usecase.dart';
import 'package:santapocket/modules/notification/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:santapocket/modules/notification/domain/usecases/read_notification_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/storage/spref.dart';
import 'package:suga_core/suga_core.dart' hide BaseViewModel;

@injectable
class NotificationPageViewModel extends AppViewModel {
  final CountUnreadNotificationsUsecase _countUnreadNotificationsUsecase;
  final GetTotalSystemNotificationsUsecase _getTotalSystemNotificationsUsecase;
  final GetNotificationsUsecase _getNotificationsUsecase;
  final MarkAllNotificationsAsReadUsecase _markAllNotificationsAsReadUsecase;
  final GetSystemNotificationsUsecase _getSystemNotificationsUsecase;
  final ReadNotificationUsecase _readNotificationUsecase;
  final GetProfileUsecase _getProfileUsecase;
  final GetDeliveryUsecase _getDeliveryUsecase;
  final GetDeliveryAuthorizationUsecase _getDeliveryAuthorizationUsecase;

  NotificationPageViewModel(
    this._countUnreadNotificationsUsecase,
    this._getTotalSystemNotificationsUsecase,
    this._getNotificationsUsecase,
    this._getSystemNotificationsUsecase,
    this._markAllNotificationsAsReadUsecase,
    this._readNotificationUsecase,
    this._getProfileUsecase,
    this._getDeliveryUsecase,
    this._getDeliveryAuthorizationUsecase,
  );

  int _personalPage = 1;
  int _systemPage = 1;
  int defaultLimit = 10;
  final String sort = "created_at";
  final String dir = "desc";
  int tabLength = 2;

  final _notifications = RxList<Notification>([]);
  final _systemNotifications = RxList<SystemNotification>([]);
  final _countUnread = Rx<int>(0);
  final _countSystemUnRead = 0.obs;
  final _canLoadPersonalMore = Rx<bool>(false);
  final _canLoadSystemMore = Rx<bool>(false);
  final _user = Rx<User?>(null);
  final _currentPage = 0.obs;

  List<Notification> get notifications => _notifications.toList();

  List<SystemNotification> get systemNotifications => _systemNotifications.toList();

  int get countUnread => _countUnread.value;

  int get countSystemUnread => _countSystemUnRead.value;

  void setCountSystemUnread(int count) => _countSystemUnRead.value = count;

  bool get canLoadPersonalMore => _canLoadPersonalMore.value;

  bool get canLoadSystemMore => _canLoadSystemMore.value;

  bool get isHaveUnread => countUnread != 0 || countSystemUnread != 0;

  User? get user => _user.value;

  int get currentPage => _currentPage.value;

  late TabController tabController;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  void disposeState() {
    _saveMostUnreadSystemNotificationCount();
    super.disposeState();
  }

  void initTabController(TickerProviderStateMixin providerStateMixin) {
    tabController = TabController(vsync: providerStateMixin, length: tabLength);
    tabController.addListener(() {
      _currentPage.value = tabController.index;
    });
  }

  void onChangeTab(int index) {
    _currentPage.value = index;
  }

  Future<Unit> onPersonalRefresh() async {
    _canLoadPersonalMore.value = false;
    _personalPage = 1;
    await getNotifications();
    await countUnReadNotification();
    return unit;
  }

  Future<Unit> onSystemRefresh() async {
    _canLoadSystemMore.value = false;
    _systemPage = 1;
    await getSystemNotifications();
    await countSystemUnReadNotification();
    return unit;
  }

  Future<Unit> _fetchData() async {
    await showLoading();
    await getNotifications();
    await countUnReadNotification();
    await getSystemNotifications();
    await countSystemUnReadNotification();
    await hideLoading();
    return unit;
  }

  Future<Unit> countUnReadNotification() async {
    await run(() async {
      final fetched = await _countUnreadNotificationsUsecase.run();
      _countUnread.value = fetched;
    });
    return unit;
  }

  Future<Unit> countSystemUnReadNotification() async {
    await run(() async {
      final res = await _getTotalSystemNotificationsUsecase.run();
      final countMostReadNotification = await SPref.instance.getCountMostReadSystemNotification();
      if (countMostReadNotification == null) {
        await SPref.instance.setCountMostReadSystemNotification(res);
      }
      _countSystemUnRead.value = countMostReadNotification == null ? 0 : res - countMostReadNotification;
    });
    return unit;
  }

  Future<Unit> getUserProfile() async {
    await run(() async {
      final fetched = await _getProfileUsecase.run();
      _user.value = fetched;
    });
    return unit;
  }

  Future<Delivery?> getDelivery(int deliveryId) async {
    Delivery? delivery;
    await run(() async {
      final fetched = await _getDeliveryUsecase.run(deliveryId);
      delivery = fetched;
    });
    return delivery;
  }

  Future<DeliveryAuthorization?> getAuthorizationDelivery(int deliveryAuthorizationId) async {
    DeliveryAuthorization? deliveryAuthorization;
    await run(() async {
      final fetched = await _getDeliveryAuthorizationUsecase.run(deliveryAuthorizationId);
      deliveryAuthorization = fetched;
    });
    return deliveryAuthorization;
  }

  Future<Unit> readAllNotifications() async {
    await showLoading();
    await run(
      () async {
        await _markAllNotificationsAsReadUsecase.run();
        await getNotifications();
        markAllNotificationListItemAsRead();
        await countUnReadNotification();
        await _saveMostUnreadSystemNotificationCount();
        await countSystemUnReadNotification();
      },
    );

    await hideLoading();
    locator<EventBus>().fire(NotificationReceivedEvent());
    return unit;
  }

  void markAllNotificationListItemAsRead() {
    final now = DateTime.now();
    _notifications.value = notifications.map((element) {
      if (!element.isRead) {
        element = element.copyWith.readAt(now);
      }
      return element;
    }).toList();
  }

  Future<Unit> getNotifications({bool isShowLoading = true}) async {
    late List<Notification> loadedNotifications;
    if (isShowLoading) {
      await showLoading();
    }
    final success = await run(
      () async {
        final ListParams listParams = ListParams(
          paginationParams: PaginationParams(page: _personalPage, limit: defaultLimit),
          sortParams: SortParams(attribute: sort, direction: dir),
        );
        loadedNotifications = await _getNotificationsUsecase.run(listParams);
      },
    );
    await hideLoading();
    if (success) {
      if (_personalPage == 1) {
        _notifications.assignAll(loadedNotifications);
      } else {
        _notifications.addAll(loadedNotifications);
      }
      _canLoadPersonalMore.value = loadedNotifications.isNotEmpty;
      if (loadedNotifications.length < defaultLimit) {
        _canLoadPersonalMore.value = false;
      }
      _personalPage++;
    }
    return unit;
  }

  Future<Unit> _saveMostUnreadSystemNotificationCount() async {
    await run(() async {
      final count = await _getTotalSystemNotificationsUsecase.run();
      await SPref.instance.setCountMostReadSystemNotification(count);
    });
    return unit;
  }

  Future<Unit> getSystemNotifications({bool isShowLoading = true}) async {
    late List<SystemNotification> loadedNotifications;
    if (isShowLoading) {
      await showLoading();
    }
    final success = await run(
      () async {
        final ListParams listParams = ListParams(
          paginationParams: PaginationParams(page: _systemPage, limit: defaultLimit),
          sortParams: SortParams(attribute: sort, direction: dir),
        );
        loadedNotifications = await _getSystemNotificationsUsecase.run(listParams);
      },
    );
    await hideLoading();
    if (success) {
      if (_systemPage == 1) {
        _systemNotifications.assignAll(loadedNotifications);
      } else {
        _systemNotifications.addAll(loadedNotifications);
      }
      _canLoadSystemMore.value = loadedNotifications.isNotEmpty;
      if (loadedNotifications.length < defaultLimit) {
        _canLoadSystemMore.value = false;
      }
      _systemPage++;
    }
    return unit;
  }

  Future<Unit> markAsReadNotification(String notificationId) async {
    late int countUnread;
    await showLoading();
    final success = await run(
      () async {
        await _readNotificationUsecase.run(notificationId);
        countUnread = await _countUnreadNotificationsUsecase.run();
      },
    );
    await hideLoading();
    if (success) {
      _countUnread.value = countUnread;
      _notifications.value = notifications.map((e) {
        if (e.id == notificationId) {
          return e.copyWith(readAt: DateTime.now());
        }
        return e;
      }).toList();
    }
    locator<EventBus>().fire(NotificationReceivedEvent());
    return unit;
  }

  void onLoadMore() {
    if (currentPage == 0) {
      getNotifications(isShowLoading: false);
    } else {
      getSystemNotifications(isShowLoading: false);
    }
  }
}
