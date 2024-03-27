import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/helpers/pagination_params.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/user/domain/events/user_balance_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_coin_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_cone_changed_event.dart';
import 'package:santapocket/modules/user/domain/models/balance_log.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/models/user_cone_log.dart';
import 'package:santapocket/modules/user/domain/usecases/get_balance_logs_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/get_user_cone_logs_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class TransactionHistoryPageViewModel extends AppViewModel {
  // ignore: unused_field
  StreamSubscription? _listenUserBalanceChanged;
  StreamSubscription? _listenUserCoinChanged;
  StreamSubscription? _listenUserConeChanged;

  final _user = Rx<User?>(null);
  final _balanceLogs = RxList<BalanceLog>([]);
  final _coneLogs = RxList<UserConeLog>([]);
  final _isConeTab = false.obs;
  final _filterTabIndex = 0.obs;
  final _canLoadMore = false.obs;
  final _isLoadingMore = false.obs;

  bool initIsConeTab = false;

  bool get isConeTab => _isConeTab.value;

  set setIsConeTab(bool value) {
    _isConeTab.value = value;
    onChangeTap(0);
  }

  int get filterTabIndex => _filterTabIndex.value;

  bool get canLoadMore => _canLoadMore.value;
  bool get isLoadingMore => _isLoadingMore.value;

  User? get user => _user.value;

  List<BalanceLog> get balanceLogs => _balanceLogs.toList();

  List<UserConeLog> get coneLogs => _coneLogs.toList();

  int _page = 1;
  final int limit = 10;
  final String sort = "id";
  final String dir = "desc";
  int endReachedThreshold = 40;
  final scrollController = ScrollController();

  final GetProfileUsecase _getProfileUsecase;
  final GetBalanceLogsUsecase _getBalanceLogsUsecase;
  final GetUserConeLogsUsecase _getUserConeLogsUsecase;

  TransactionHistoryPageViewModel(
    this._getProfileUsecase,
    this._getBalanceLogsUsecase,
    this._getUserConeLogsUsecase,
  );

  @override
  void initState() {
    super.initState();
    _fetchData();
    _listenUserBalanceChanged = locator<EventBus>().on<UserBalanceChangedEvent>().listen((event) async {
      await onBalanceAndCoinChanged(event.user);
    });
    _listenUserCoinChanged = locator<EventBus>().on<UserCoinChangedEvent>().listen((event) async {
      await onBalanceAndCoinChanged(event.user);
    });
    _listenUserConeChanged = locator<EventBus>().on<UserConeChangedEvent>().listen((event) async {
      await onBalanceAndCoinChanged(event.user);
    });
    scrollController.addListener(() {
      onGridViewScroll();
    });
  }

  @override
  void disposeState() {
    _listenUserBalanceChanged?.cancel();
    _listenUserCoinChanged?.cancel();
    _listenUserConeChanged?.cancel();
    super.disposeState();
  }

  void onChangeTap(int index) {
    _filterTabIndex.value = index;
    onRefresh();
  }

  Future<void> onBalanceAndCoinChanged(User user) async {
    _user.value = user;
    await onRefresh();
  }

  Future<bool> _fetchData() async {
    await showLoading();
    _isConeTab.value = initIsConeTab;
    final isGetUserSuccess = await getUserProfile();
    final isGetLogsSuccess = isConeTab ? await getCoinLogs() : await getBalanceLogs();
    await hideLoading();
    return isGetUserSuccess && isGetLogsSuccess;
  }

  Future<bool> getUserProfile() async {
    User? userLoaded;
    final isSuccess = await run(
      () async => userLoaded = await _getProfileUsecase.run(),
    );
    if (isSuccess) {
      _user.value = userLoaded;
    }
    return isSuccess;
  }

  Future<bool> getBalanceLogs() async {
    final isSuccess = await run(
      () async {
        final fetchedData = await _getBalanceLogsUsecase.run(
          ListParams(
            paginationParams: PaginationParams(page: _page, limit: limit),
            sortParams: SortParams(attribute: sort, direction: dir),
          ),
          earningFilter: _getFilterValue(filterTabIndex),
        );
        if (_page == 1) {
          _balanceLogs.assignAll(fetchedData);
        } else {
          _balanceLogs.addAll(fetchedData);
        }
        _canLoadMore.value = fetchedData.isNotEmpty;
        _page++;
      },
    );

    return isSuccess;
  }

  Future<bool> getCoinLogs() async {
    final isSuccess = await run(
      () async {
        final fetched = await _getUserConeLogsUsecase.run(
          ListParams(
            paginationParams: PaginationParams(page: _page, limit: limit),
            sortParams: SortParams(attribute: sort, direction: dir),
          ),
          earningFilter: _getFilterValue(filterTabIndex),
        );
        if (_page == 1) {
          _coneLogs.assignAll(fetched);
        } else {
          _coneLogs.addAll(fetched);
        }
        _canLoadMore.value = fetched.isNotEmpty;
        _page++;
      },
    );

    return isSuccess;
  }

  Future<Unit> onGridViewScroll() async {
    if (!scrollController.hasClients || isLoadingMore) {
      return unit;
    }
    if (!canLoadMore) {
      return unit;
    }
    if (scrollController.position.extentBefore > scrollController.position.maxScrollExtent + endReachedThreshold) {
      await _onLoadMore();
    }
    return unit;
  }

  Future<Unit> _onLoadMore() async {
    _isLoadingMore.value = true;
    if (_isConeTab.value) {
      await getCoinLogs();
    } else {
      await getBalanceLogs();
    }
    _isLoadingMore.value = false;
    return unit;
  }

  int? _getFilterValue(int filterIndex) {
    switch (filterIndex) {
      case 0:
        return null;
      case 1:
        return 1;
      case 2:
        return 0;
      default:
        return null;
    }
  }

  Future<Unit> onRefresh() async {
    _canLoadMore.value = false;
    _page = 1;
    if (isConeTab) {
      await getCoinLogs();
    } else {
      await getBalanceLogs();
    }
    return unit;
  }
}
