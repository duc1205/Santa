import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/helpers/date_time_range.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/helpers/pagination_params.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/modules/charity/domain/usecases/get_charity_deliveries_usecase.dart';
import 'package:santapocket/modules/delivery/app/ui/history/enums/delivery_filter_tabs.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_cancel_event.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_receiver_changed_event.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_sent_event.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_status_changed_event.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CharityDeliveryHistoryPageViewModel extends AppViewModel {
  final GetProfileUsecase _getProfileUsecase;
  final GetCharityDeliveriesUsecase _getCharityDeliveriesUsecase;

  CharityDeliveryHistoryPageViewModel(this._getProfileUsecase, this._getCharityDeliveriesUsecase);

  StreamSubscription? _listenDeliveryCancel;
  StreamSubscription? _listenDeliverySent;
  StreamSubscription? _listenDeliveryReceiverChanged;
  StreamSubscription? _listenDeliveryStatusChanged;

  final ScrollController scrollController = ScrollController();

  final _allDeliveries = Rx<List<Delivery>>([]);
  final _processingDeliveries = Rx<List<Delivery>>([]);
  final _finishedDeliveries = Rx<List<Delivery>>([]);
  final _canLoadMoreAllDeliveries = Rx<bool>(false);
  final _canLoadMoreProcessingDeliveries = Rx<bool>(false);
  final _canLoadMoreFinishedDeliveries = Rx<bool>(false);
  final _user = Rx<User?>(null);
  final _tabIndex = 0.obs;
  final _filterPeriod = Rx<DatePeriod?>(null);
  final _filterCabinet = Rx<Cabinet?>(null);
  final _filterAppliedCount = 0.obs;
  final _isCanClearSearch = false.obs;

  List<Delivery> get allDeliveries => _allDeliveries.value;

  List<Delivery> get processingDeliveries => _processingDeliveries.value;

  List<Delivery> get finishedDeliveries => _finishedDeliveries.value;

  bool get canLoadMoreAllDeliveries => _canLoadMoreAllDeliveries.value;

  bool get canLoadMoreProcessingDeliveries => _canLoadMoreProcessingDeliveries.value;

  bool get canLoadMoreFinishedDeliveries => _canLoadMoreFinishedDeliveries.value;

  User? get user => _user.value;

  int get tabIndex => _tabIndex.value;

  DatePeriod? get filterPeriod => _filterPeriod.value;

  Cabinet? get filterCabinet => _filterCabinet.value;

  int get filterAppliedCount => _filterAppliedCount.value;

  bool get isCanClearSearch => _isCanClearSearch.value;

  List<Delivery> get deliveries {
    switch (tabIndex) {
      case 0:
        return allDeliveries;
      case 1:
        return processingDeliveries;
      case 2:
        return finishedDeliveries;
      default:
        return allDeliveries;
    }
  }

  bool get canLoadMore {
    switch (tabIndex) {
      case 0:
        return canLoadMoreAllDeliveries;
      case 1:
        return canLoadMoreProcessingDeliveries;
      case 2:
        return canLoadMoreFinishedDeliveries;
      default:
        return canLoadMoreAllDeliveries;
    }
  }

  int get _page {
    switch (tabIndex) {
      case 0:
        return _allDeliveriesPage;
      case 1:
        return _finishedDeliveriesPage;
      case 2:
        return _finishedDeliveriespage;
      default:
        return _allDeliveriesPage;
    }
  }

  int _allDeliveriesPage = 1;
  int _finishedDeliveriesPage = 1;
  int _finishedDeliveriespage = 1;
  final int limit = 10;
  final String sort = "id";
  final String dir = "desc";
  final searchTextController = TextEditingController();
  bool isFirstLoadedAllDelivery = true;
  bool isFirstLoadedProcessingDelivery = true;
  bool isFirstLoadedFinishedDelivery = true;

  int get getUserId => user?.id ?? -1;

  void _initListener() {
    _listenDeliveryCancel = locator<EventBus>().on<DeliveryCancelEvent>().listen((event) {
      onRefresh();
    });
    _listenDeliverySent = locator<EventBus>().on<DeliverySentEvent>().listen((event) {
      onRefresh();
    });
    _listenDeliveryReceiverChanged = locator<EventBus>().on<DeliveryReceiverChangedEvent>().listen((event) {
      onRefresh();
    });
    _listenDeliveryStatusChanged = locator<EventBus>().on<DeliveryStatusChangedEvent>().listen((event) {
      onRefresh();
    });
  }

  @override
  void initState() {
    searchTextController.addListener(() => _isCanClearSearch.value = searchTextController.text.trim().isNotEmpty);
    _initListener();
    super.initState();
    initData();
  }

  @override
  void disposeState() {
    _listenDeliveryCancel?.cancel();
    _listenDeliverySent?.cancel();
    _listenDeliveryReceiverChanged?.cancel();
    _listenDeliveryStatusChanged?.cancel();
    scrollController.dispose();
    super.disposeState();
  }

  Future<Unit> initData() async {
    await getUser();
    await fetchDataDeliveries(isShouldShowLoading: true);
    return unit;
  }

  DeliveryFilterTabs getDeliveryFilterTab() {
    switch (tabIndex) {
      case 0:
        return DeliveryFilterTabs.all;
      case 1:
        return DeliveryFilterTabs.processing;
      case 2:
        return DeliveryFilterTabs.finished;
      default:
        return DeliveryFilterTabs.all;
    }
  }

  Future<Unit> getUser() async {
    await run(() async {
      _user.value = await _getProfileUsecase.run();
    });
    return unit;
  }

  Future<bool> fetchDataDeliveries({required bool isShouldShowLoading}) async {
    late List<Delivery> deliveriesLoaded;

    final query = searchTextController.text.isNotEmpty ? searchTextController.text : null;
    if (isShouldShowLoading) await showLoading();
    final ListParams listParams = ListParams(
      paginationParams: PaginationParams(page: _page, limit: limit),
      sortParams: SortParams(attribute: sort, direction: dir),
    );
    final dateTimeRange = DateTimeRange(from: _getFromDate(), to: _getToDate());
    final cabinetId = filterCabinet?.id;
    final DeliveryFilterTabs deliveryFilterTabs = getDeliveryFilterTab();
    final success = await run(
      () async {
        deliveriesLoaded = await _getCharityDeliveriesUsecase.run(
          listParams,
          cabinetId: cabinetId,
          filterTab: deliveryFilterTabs,
          dateTimeRange: dateTimeRange,
          query: query,
        );
      },
    );
    if (success) {
      assignDeliveries(deliveriesLoaded, deliveryFilterTabs);
    }
    if (isShouldShowLoading) await hideLoading();
    return success;
  }

  Future<Unit> onChangeTap(int index) async {
    if (deliveries.isNotEmpty) {
      _scrollUp();
    }
    await Future.delayed(const Duration(milliseconds: 200));
    _tabIndex.value = index;
    bool shouldRefresh = false;
    switch (index) {
      case 0:
        shouldRefresh = isFirstLoadedAllDelivery;
        break;
      case 1:
        shouldRefresh = isFirstLoadedProcessingDelivery;
        break;
      case 2:
        shouldRefresh = isFirstLoadedFinishedDelivery;
        break;
      default:
        shouldRefresh = isFirstLoadedAllDelivery;
        break;
    }
    if (shouldRefresh) {
      await onRefresh();
    }
    return unit;
  }

  void assignDeliveries(List<Delivery> currentDeliveries, DeliveryFilterTabs deliveryFilterTabs) {
    switch (deliveryFilterTabs) {
      case DeliveryFilterTabs.all:
        if (_page == 1) {
          _allDeliveries.value = [];
        }
        _allDeliveries.value += currentDeliveries;
        _canLoadMoreAllDeliveries.value = currentDeliveries.length == 10;
        isFirstLoadedAllDelivery = false;
        _allDeliveriesPage++;
        break;
      case DeliveryFilterTabs.processing:
        if (_page == 1) {
          _processingDeliveries.value = [];
        }
        _processingDeliveries.value += currentDeliveries;
        _canLoadMoreProcessingDeliveries.value = currentDeliveries.length == 10;
        isFirstLoadedProcessingDelivery = false;
        _finishedDeliveriesPage++;
        break;
      case DeliveryFilterTabs.finished:
        if (_page == 1) {
          _finishedDeliveries.value = [];
        }
        _finishedDeliveries.value += currentDeliveries;
        _canLoadMoreFinishedDeliveries.value = currentDeliveries.length == 10;
        isFirstLoadedFinishedDelivery = false;
        _finishedDeliveriespage++;
        break;
    }
  }

  Future<Unit> onRefresh() async {
    final deliveryFilterTabs = getDeliveryFilterTab();
    switch (deliveryFilterTabs) {
      case DeliveryFilterTabs.all:
        _canLoadMoreAllDeliveries.value = false;
        _allDeliveriesPage = 1;
        break;
      case DeliveryFilterTabs.processing:
        _canLoadMoreProcessingDeliveries.value = false;
        _finishedDeliveriesPage = 1;
        break;
      case DeliveryFilterTabs.finished:
        _canLoadMoreFinishedDeliveries.value = false;
        _finishedDeliveriespage = 1;
        break;
      default:
    }
    unawaited(fetchDataDeliveries(isShouldShowLoading: true));
    return unit;
  }

  Future<Unit> onSearch() async {
    final deliveryFilterTabs = getDeliveryFilterTab();
    switch (deliveryFilterTabs) {
      case DeliveryFilterTabs.all:
        _canLoadMoreAllDeliveries.value = false;
        _allDeliveriesPage = 1;
        break;
      case DeliveryFilterTabs.processing:
        _canLoadMoreProcessingDeliveries.value = false;
        _finishedDeliveriesPage = 1;
        break;
      case DeliveryFilterTabs.finished:
        _canLoadMoreFinishedDeliveries.value = false;
        _finishedDeliveriespage = 1;
        break;
      default:
    }
    unawaited(fetchDataDeliveries(isShouldShowLoading: false));
    return unit;
  }

  Future<Unit> onClearSearch() async {
    searchTextController.clear();
    await onRefresh();
    return unit;
  }

  void onApplyFilter(DatePeriod? datePeriod, Cabinet? cabinet) {
    int count = 0;
    _filterPeriod.value = datePeriod;
    if (datePeriod != null) {
      count++;
    }
    _filterCabinet.value = cabinet;
    if (cabinet != null) {
      count++;
    }
    _filterAppliedCount.value = count;
    onRefresh();
  }

  DateTime? _getFromDate() {
    if (filterPeriod?.start == null) return null;
    return DateTime(filterPeriod!.start.year, filterPeriod!.start.month, filterPeriod!.start.day);
  }

  DateTime? _getToDate() {
    if (filterPeriod?.end == null) return null;
    return DateTime(filterPeriod!.end.year, filterPeriod!.end.month, filterPeriod!.end.day, 23, 59, 59);
  }

  void _scrollUp() {
    scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.fastOutSlowIn,
    );
  }
}
