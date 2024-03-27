import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/deeplink/qr_code_manager.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/firebase/domain/usecases/register_fcm_token_usecase.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/helpers/pagination_params.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_maintenance/cabinet_maintenance_page.dart';
import 'package:santapocket/modules/cabinet/domain/enums/cabinet_status.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_cabinet_info_usecase.dart';
import 'package:santapocket/modules/connection/domain/enums/connection_status.dart';
import 'package:santapocket/modules/connection/domain/events/connection_status_changed_event.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/send/send_package_info_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/receive_packages_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/self_rent/self_rent_pocket_info_page.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_status.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_created_event.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_receiver_changed_event.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_sent_event.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_status_changed_event.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_deliveries_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_receivable_deliveries_usecase.dart';
import 'package:santapocket/modules/delivery_authorization/domain/events/authorize_delivery_successful_event.dart';
import 'package:santapocket/modules/delivery_authorization/domain/events/delivery_authorization_canceled_event.dart';
import 'package:santapocket/modules/delivery_authorization/domain/events/delivery_authorization_created_event.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/get_receivable_delivery_authorizations_usecase.dart';
import 'package:santapocket/modules/main/app/events/home_on_initial_notification_clicked.dart';
import 'package:santapocket/modules/main/app/events/home_on_refresh_event.dart';
import 'package:santapocket/modules/main/app/events/user_accept_tos_event.dart';
import 'package:santapocket/modules/main/app/ui/home/enums/action_scan.dart';
import 'package:santapocket/modules/main/app/ui/home/widgets/coming_soon_service_page.dart';
import 'package:santapocket/modules/main/app/ui/main_page.dart';
import 'package:santapocket/modules/notification/domain/events/notification_received_event.dart';
import 'package:santapocket/modules/notification/domain/events/notification_status_changed_event.dart';
import 'package:santapocket/modules/notification/domain/usecases/count_unread_notifications_usecase.dart';
import 'package:santapocket/modules/notification/domain/usecases/get_total_system_notifications_usecase.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/modules/user/domain/events/user_balance_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_coin_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_free_usage_changed_event.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/clear_user_cache_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/update_device_info_usecase.dart';
import 'package:santapocket/modules/version/domain/enums/version_status.dart';
import 'package:santapocket/modules/version/domain/usecases/get_version_status_usecase.dart';
import 'package:santapocket/storage/spref.dart';
import 'package:suga_core/suga_core.dart' hide BaseViewModel;

@injectable
class HomePageViewModel extends AppViewModel {
  final GetProfileUsecase _getProfileUsecase;
  final GetDeliveriesUsecase _getDeliveriesUsecase;
  final GetReceivableDeliveriesUsecase _getReceivableDeliveriesUsecase;
  final CountUnreadNotificationsUsecase _countUnreadNotificationsUsecase;
  final GetTotalSystemNotificationsUsecase _getTotalSystemNotificationsUsecase;
  final GetCabinetInfoUsecase _getCabinetInfoUsecase;
  final GetVersionStatusUsecase _getVersionStatusUsecase;
  final ClearUserCacheUsecase _clearUserCacheUsecase;
  final GetReceivableDeliveryAuthorizationsUsecase _getReceivableDeliveryAuthorizationsUsecase;
  final UpdateDeviceInfoUsecase _updateDeviceInfoUsecase;
  final RegisterFcmTokenUsecase _registerFcmTokenUsecase;
  final GetSettingUsecase _getSettingUsecase;

  HomePageViewModel(
    this._getProfileUsecase,
    this._getDeliveriesUsecase,
    this._getReceivableDeliveriesUsecase,
    this._countUnreadNotificationsUsecase,
    this._getTotalSystemNotificationsUsecase,
    this._getCabinetInfoUsecase,
    this._getVersionStatusUsecase,
    this._clearUserCacheUsecase,
    this._getReceivableDeliveryAuthorizationsUsecase,
    this._updateDeviceInfoUsecase,
    this._registerFcmTokenUsecase,
    this._getSettingUsecase,
  );

  final _user = Rx<User?>(null);
  final _deliveries = Rx<List<Delivery>>([]);
  final _receivableDeliveries = Rx<List<Delivery>>([]);
  final _deliveryAuthorizations = Rx<List<DeliveryAuthorization>>([]);
  final _quantityRentDeliveries = Rx<int>(0);
  final _countUnread = Rx<int>(0);
  final _countSystemUnRead = 0.obs;
  final _versionStatus = Rx<VersionStatus>(VersionStatus.upToDate);
  final _bankTransferInfo = Rx<Map<String, dynamic>>({});

  final _surpriseServiceUrl = "".obs;
  final _marketServiceUrl = "".obs;
  final _parkingServiceUrl = "".obs;

  final _current = 0.obs;

  int get current => _current.value;

  void setPageReminder(int index) {
    _current.value = index;
  }

  User? get user => _user.value;

  List<Delivery> get deliveries => _deliveries.value;

  List<Delivery> get receivableDeliveries => _receivableDeliveries.value;

  List<DeliveryAuthorization> get deliveryAuthorizations => _deliveryAuthorizations.value;

  int get quantityRentDeliveries => _quantityRentDeliveries.value;

  int get countUnread => _countUnread.value;

  int get countSystemUnread => _countSystemUnRead.value;

  VersionStatus get versionStatus => _versionStatus.value;

  Map<String, dynamic> get bankTransferInfo => _bankTransferInfo.value;

  String get surpriseServiceUrl => _surpriseServiceUrl.value;

  String get marketServiceUrl => _marketServiceUrl.value;

  String get parkingServiceUrl => _parkingServiceUrl.value;

  List<Cabinet>? cabinets;
  List<Delivery> rentDeliveries = [];

  StreamSubscription? _listenDeliveryStatusChanged;
  StreamSubscription? _listenDeliveryCreated;
  StreamSubscription? _listenUserBalanceChanged;
  StreamSubscription? _listenNotificationStatusChanged;
  StreamSubscription? _listenUserFreeUsageChanged;
  StreamSubscription? _listenDeliveryAuthorizationCreated;
  StreamSubscription? _listenAuthorizeDeliverySuccessful;
  StreamSubscription? _listenUserCoinChanged;
  StreamSubscription? _listenDeliveryReceiverChanged;
  StreamSubscription? _listenDeliverySent;
  StreamSubscription? _listenInitialNotificationClicked;
  StreamSubscription? _listenDeliveryAuthorizationCanceled;
  StreamSubscription? _listenInternetConnection;
  StreamSubscription? _listenUserAcceptTOS;
  StreamSubscription? _listenReceiveNotification;

  double radius = 5;
  String errorMessage = "";
  String locale = "";

  String? hotline;

  int quantityPackage = 0;
  final int page = 1;
  final int limit = 3;
  final String sort = "id";
  final String dir = "desc";

  bool _loadedMainData = false;

  bool get loadedMainData => _loadedMainData;

  int getFreeUsage() => user?.freeUsage ?? 0;

  int getGem() => user?.gem ?? 0;

  int getCone() => user?.cone ?? 0;

  bool get hasUnreadNotification => countUnread != 0 || countSystemUnread != 0;

  bool isReceiver(int index) => deliveries[index].receiverId == user?.id;

  bool hasReminder() => receivableDeliveries.isNotEmpty;

  int get quantityPackageReceive => receivableDeliveries.length + deliveryAuthorizations.length;

  @override
  void initState() {
    super.initState();
    _registerFCMToken();
    _initListener();
    refreshData();
  }

  void _initListener() {
    _listenDeliveryStatusChanged = locator<EventBus>().on<DeliveryStatusChangedEvent>().listen((event) {
      onDeliveryChanged();
      // ignore: missing_enum_constant_in_switch
      switch (event.delivery.status) {
        case DeliveryStatus.sent:
        case DeliveryStatus.received:
        case DeliveryStatus.failed:
        case DeliveryStatus.completed:
        case DeliveryStatus.canceled:
          onDeliveryStatusChange();
          break;
      }
    });
    _listenDeliveryCreated = locator<EventBus>().on<DeliveryCreatedEvent>().listen((event) {
      onDeliveryChanged();
    });
    _listenUserBalanceChanged = locator<EventBus>().on<UserBalanceChangedEvent>().listen((_) {
      _fetchUserData();
    });
    _listenUserFreeUsageChanged = locator<EventBus>().on<UserFreeUsageChangedEvent>().listen((_) {
      _fetchUserData();
    });
    _listenUserCoinChanged = locator<EventBus>().on<UserCoinChangedEvent>().listen((_) {
      _fetchUserData();
    });
    _listenNotificationStatusChanged = locator<EventBus>().on<NotificationStatusChangedEvent>().listen((_) {
      onNotificationStatusChanged();
    });
    _listenDeliveryAuthorizationCreated = locator<EventBus>().on<DeliveryAuthorizationCreatedEvent>().listen((event) {
      onDeliveryAuthorizationChange();
    });
    _listenAuthorizeDeliverySuccessful = locator<EventBus>().on<AuthorizeDeliverySuccessfulEvent>().listen((event) {
      onReceivableDeliveryChange();
    });
    _listenDeliveryReceiverChanged = locator<EventBus>().on<DeliveryReceiverChangedEvent>().listen((event) {
      onRefresh();
    });
    _listenDeliverySent = locator<EventBus>().on<DeliverySentEvent>().listen((event) {
      onRefresh();
    });
    _listenInitialNotificationClicked = locator<EventBus>().on<HomeOnInitialNotificationClicked>().listen((event) {
      onRefresh();
    });
    _listenDeliveryAuthorizationCanceled = locator<EventBus>().on<DeliveryAuthorizationCanceledEvent>().listen((event) {
      onReceivableDeliveryChange();
      onDeliveryAuthorizationChange();
    });
    _listenInternetConnection = locator<EventBus>().on<ConnectionStatusChangedEvent>().listen((event) {
      if (event.status == ConnectionStatus.connected) {
        refreshData();
      }
    });
    _listenUserAcceptTOS = locator<EventBus>().on<UserAcceptTOSEvent>().listen((event) {
      onRefresh();
    });
    _listenReceiveNotification = locator<EventBus>().on<NotificationReceivedEvent>().listen((event) {
      _countAllUnread();
    });
  }

  @override
  void disposeState() {
    _listenDeliveryStatusChanged?.cancel();
    _listenDeliveryCreated?.cancel();
    _listenUserBalanceChanged?.cancel();
    _listenNotificationStatusChanged?.cancel();
    _listenUserFreeUsageChanged?.cancel();
    _listenDeliveryAuthorizationCreated?.cancel();
    _listenAuthorizeDeliverySuccessful?.cancel();
    _listenUserCoinChanged?.cancel();
    _listenDeliveryReceiverChanged?.cancel();
    _listenDeliverySent?.cancel();
    _listenInitialNotificationClicked?.cancel();
    _listenDeliveryAuthorizationCanceled?.cancel();
    _listenInternetConnection?.cancel();
    _listenUserAcceptTOS?.cancel();
    _listenReceiveNotification?.cancel();
  }

  Future<Unit> _registerFCMToken() async {
    await run(() => _registerFcmTokenUsecase.run());
    return unit;
  }

  Future<Unit> refreshData() async {
    _loadedMainData = false;
    await _fetchUserData();
    await _getReceivableDeliveries();
    await _getAuthorizationDeliveries();
    await _getServicesUrl();
    await _getDeliveries();
    _loadedMainData = true;
    await _countSystemUnReadNotification();
    await _getCountUnReadNotification();
    await _getVersionStatus();
    await _getBankTransferInfo();
    return unit;
  }

  Future<Unit> _countAllUnread() async {
    await _countSystemUnReadNotification();
    await _getCountUnReadNotification();
    return unit;
  }

  Future<Unit> _countSystemUnReadNotification() async {
    await run(() async {
      final res = await _getTotalSystemNotificationsUsecase.run();
      final countMostReadNotification = await SPref.instance.getCountMostReadSystemNotification();
      _countSystemUnRead.value = countMostReadNotification == null ? 0 : res - countMostReadNotification;
    });
    return unit;
  }

  Future<Unit> _getDeliveries() async {
    await run(() async {
      final fetched = await _getDeliveriesUsecase.run(
        ListParams(
          paginationParams: PaginationParams(page: page, limit: limit),
          sortParams: SortParams(attribute: sort, direction: dir),
        ),
      );
      _deliveries.value = fetched;
    });
    return unit;
  }

  Future<Unit> _getCountUnReadNotification() async {
    await run(() async {
      final fetched = await _countUnreadNotificationsUsecase.run();
      _countUnread.value = fetched;
    });
    return unit;
  }

  Future<Unit> _getVersionStatus() async {
    await run(() async {
      final fetched = await _getVersionStatusUsecase.run();
      _versionStatus.value = fetched;
    });
    return unit;
  }

  Future<Unit> _getReceivableDeliveries() async {
    await run(() async {
      final fetched = await _getReceivableDeliveriesUsecase.run();
      _receivableDeliveries.value = fetched;
    });
    return unit;
  }

  Future<Unit> _getAuthorizationDeliveries() async {
    await run(() async {
      final fetched = await _getReceivableDeliveryAuthorizationsUsecase.run();
      _deliveryAuthorizations.value = fetched;
    });
    return unit;
  }

  Future<Unit> _getBankTransferInfo() async {
    await run(() async {
      final fetched = await _getSettingUsecase.run(Constants.appBankTransferInfo);
      if (fetched.value is Map<String, dynamic>) {
        _bankTransferInfo.value = fetched.value;
      }
    });
    return unit;
  }

  Future<Unit> _getServicesUrl() async {
    await run(
      () async {
        final surpriseServiceUrlTemp = (await _getSettingUsecase.run(Constants.surpriseServiceUrlSetting)).value as String;
        _surpriseServiceUrl.value = surpriseServiceUrlTemp;
      },
      shouldHandleError: false,
    );
    await run(
      () async {
        final marketServiceUrlTemp = (await _getSettingUsecase.run(Constants.marketServiceUrlSetting)).value as String;
        _marketServiceUrl.value = marketServiceUrlTemp;
      },
      shouldHandleError: false,
    );
    await run(
      () async {
        final parkingServiceUrlTemp = (await _getSettingUsecase.run(Constants.parkingServiceUrlSetting)).value as String;
        _parkingServiceUrl.value = parkingServiceUrlTemp;
      },
      shouldHandleError: false,
    );
    return unit;
  }

  Future<Unit> onExternalCLickServiceCLick(String url) async {
    if (url.isNotEmpty) {
      final accessToken = await SPref.instance.getAccessToken();
      url += "${url.contains("?") ? "&" : "?"}access_token=$accessToken";
      await Get.to(() => WebViewPage(url: url));
    } else {
      await Get.to(() => const ComingSoonServicePage());
    }
    return unit;
  }

  Future<Unit> _fetchUserData() async {
    if (Get.currentRoute == MainPage.routeName) {
      await showLoading();
    }
    await run(() async {
      await _clearUserCacheUsecase.run();
      final userFetch = await _getProfileUsecase.run();
      _user.value = userFetch;
    });
    await hideLoading();
    return unit;
  }

  Future<Unit> onRefresh() async {
    locator<EventBus>().fire(const HomeOnRefreshEvent());
    _current.value = 0;

    unawaited(refreshData());
    return unit;
  }

  Future<Unit> onDeliveryStatusChange() async {
    List<Delivery> tempDeliveries = [];
    List<Delivery> receivableDeliveriesTemp = [];
    List<DeliveryAuthorization> deliveryAuthorizationsTemp = [];
    int quantityRentDeliveriesTemp = 0;
    final success = await run(
      () async {
        tempDeliveries = await _getDeliveriesUsecase.run(
          ListParams(
            paginationParams: PaginationParams(page: page, limit: limit),
            sortParams: SortParams(attribute: sort, direction: dir),
          ),
        );
        _countUnread.value = await _countUnreadNotificationsUsecase.run();
        receivableDeliveriesTemp = await _getReceivableDeliveriesUsecase.run();
        deliveryAuthorizationsTemp = await _getReceivableDeliveryAuthorizationsUsecase.run();
      },
    );
    if (success) {
      _deliveries.value = tempDeliveries;
      _receivableDeliveries.value = receivableDeliveriesTemp;
      _deliveryAuthorizations.value = deliveryAuthorizationsTemp;
      _quantityRentDeliveries.value = quantityRentDeliveriesTemp;
    }
    return unit;
  }

  Future<Unit> onDeliveryChanged() async {
    List<Delivery> tempDeliveries = [];
    final bool isSuccess = await run(
      () async {
        tempDeliveries = await _getDeliveriesUsecase.run(
          ListParams(
            paginationParams: PaginationParams(page: page, limit: limit),
            sortParams: SortParams(attribute: sort, direction: dir),
          ),
        );
      },
    );
    if (isSuccess) {
      _deliveries.value = tempDeliveries;
    }
    return unit;
  }

  Future<Unit> onDeliveryAuthorizationChange() async {
    List<DeliveryAuthorization> deliveryAuthorizationsTemp = [];
    final bool isSuccess = await run(
      () async {
        deliveryAuthorizationsTemp = await _getReceivableDeliveryAuthorizationsUsecase.run();
      },
    );
    if (isSuccess) {
      _deliveryAuthorizations.value = deliveryAuthorizationsTemp;
    }
    return unit;
  }

  Future<Unit> onReceivableDeliveryChange() async {
    List<Delivery> receivableDeliveriesTemp = [];
    final bool isSuccess = await run(
      () async {
        receivableDeliveriesTemp = await _getReceivableDeliveriesUsecase.run();
      },
    );
    if (isSuccess) {
      _receivableDeliveries.value = receivableDeliveriesTemp;
    }
    return unit;
  }

  Future<Unit> onNotificationStatusChanged() async {
    await run(
      () async {
        _countUnread.value = await _countUnreadNotificationsUsecase.run();
      },
    );
    return unit;
  }

  void onClickBanner() {
    Get.to(() => const WebViewPage(url: Constants.urlGameShow2504));
  }

  Future<Unit> handleQrCodeData({required String barcode, required ActionScan scan}) async {
    final status = await QrCodeManager.instance.parseQrData(barcode);
    if (status is ValidQrStatus) {
      final CabinetInfo? cabinetInfo = await getCabinetInfo(status.uuid!, status.otp);
      if (cabinetInfo != null) {
        if (cabinetInfo.isOnline) {
          switch (cabinetInfo.status) {
            case CabinetStatus.unknown:
            case CabinetStatus.inStock:
              showToast(LocaleKeys.main_cabinet_can_not_use.trans());
              break;
            case CabinetStatus.production:
              await _handleActionScan(cabinetInfo: cabinetInfo, actionScan: scan);
              break;
            case CabinetStatus.maintenance:
              await Get.to(
                () => CabinetMaintenancePage(
                  cabinetName: cabinetInfo.name,
                ),
              );
              break;
          }
        } else {
          await Get.to(
            () => CabinetMaintenancePage(
              cabinetName: cabinetInfo.name,
            ),
          );
        }
      }
    } else if (status is InValidQrStatus) {
      showToast(LocaleKeys.main_wrong_qr_code.trans());
    } else if (status is SurpriseQrStatus) {
      showToast(LocaleKeys.main_wrong_qr_code.trans());
    }
    return unit;
  }

  Future<Unit> _handleActionScan({required CabinetInfo cabinetInfo, required ActionScan actionScan}) async {
    switch (actionScan) {
      case ActionScan.send:
        await Get.to(
          () => SendPackageInfoPage(
            cabinetInfo: cabinetInfo,
          ),
        );
        break;
      case ActionScan.receive:
        await Get.to(
          () => ReceivePackagesPage(
            cabinetInfo: cabinetInfo,
          ),
        );
        break;
      case ActionScan.scan:
        break;
      case ActionScan.selfRent:
        await Get.to(() => SelfRentPocketInfoPage(
              cabinetInfo: cabinetInfo,
            ));
        break;
    }
    return unit;
  }

  Future<CabinetInfo?> getCabinetInfo(String uuid, String? otp) async {
    late CabinetInfo? cabinetInfo;
    if (Get.currentRoute == MainPage.routeName) {
      await showLoading();
    }
    final bool isSuccess = await run(
      () async => cabinetInfo = await _getCabinetInfoUsecase.run(uuid: uuid, otp: otp),
    );
    await Future.delayed(const Duration(milliseconds: 500));
    await hideLoading();
    if (isSuccess) {
      return cabinetInfo;
    }
    return null;
  }

  Future<Unit> updateDeviceInfo() async {
    await run(() async {
      await _updateDeviceInfoUsecase.run();
    });
    return unit;
  }
}
