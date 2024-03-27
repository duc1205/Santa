import 'dart:async';

import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/helpers/pagination_params.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/delivery/domain/models/person.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_people_usecase.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_recent_receivers_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:suga_core/suga_core.dart' hide BaseViewModel;

@injectable
class PhoneNumberPickerPageViewModel extends AppViewModel {
  final GetPeopleUsecase _getPeopleUsecase;
  final GetRecentReceiversUsecase _getRecentReceiversUsecase;

  PhoneNumberPickerPageViewModel(
    this._getPeopleUsecase,
    this._getRecentReceiversUsecase,
  );

  int page = 1;
  int limit = 10;
  final String sort = "id";
  final String dir = "desc";

  final _canLoadMore = Rx<bool>(false);
  final _listPersons = Rx<List<Person>>([]);
  final _selectedReceiver = Rx<User?>(null);
  final _recentReceivers = Rx<List<User>>([]);

  bool get canLoadMore => _canLoadMore.value;

  User? get selectedReceiver => _selectedReceiver.value;

  List<Person> get listPersons => _listPersons.value;

  List<User> get recentReceivers => _recentReceivers.value;

  void onItemClickUser(User user) => _selectedReceiver(user);

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  // get status contact permission
  Future<PermissionStatus> _getContactPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      final PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<Unit> _fetchData() async {
    await _getContactPermission();
    final ListParams listParams = ListParams(
      paginationParams: PaginationParams(
        limit: limit,
        page: page,
      ),
      sortParams: SortParams(
        attribute: sort,
        direction: dir,
      ),
    );
    late List<Person> listPersonsLoaded;
    late List<User> dataRecent;
    await showLoading();
    final success = await run(
      () async {
        dataRecent = await _getRecentReceiversUsecase.run(listParams);
        listPersonsLoaded = await _getPeopleUsecase.run();
      },
    );
    if (success) {
      assignRecentReceivers(dataRecent);
      _listPersons(listPersonsLoaded);
    }
    await hideLoading();
    return unit;
  }

  Future<Unit> onLoadMore() async {
    late List<User> dataRecent;
    final ListParams listParams = ListParams(
      paginationParams: PaginationParams(
        limit: limit,
        page: page,
      ),
      sortParams: SortParams(
        attribute: sort,
        direction: dir,
      ),
    );
    final success = await run(
      () async => dataRecent = await _getRecentReceiversUsecase.run(listParams),
    );
    if (success) {
      assignRecentReceivers(dataRecent);
    }
    return unit;
  }

  void assignRecentReceivers(List<User> users) {
    if (page == 1) {
      _recentReceivers.value = [];
    }
    _recentReceivers.value += users;
    _canLoadMore.value = users.isNotEmpty;
    page++;
  }
}
