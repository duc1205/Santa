import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_pocket_sizes_usecase.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/self_rent/self_rent_pocket_state_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/cabinet_empty_pocket_dialog.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/offline_dialog.dart';
import 'package:santapocket/modules/delivery/domain/enums/package_category.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/usecases/self_rent_pocket_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/retrofit/rest_error.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class SelfRentPocketInfoPageViewModel extends AppViewModel {
  final GetProfileUsecase _getProfileUsecase;
  final GetPocketSizesUsecase _getPocketSizesUsecase;
  final SelfRentPocketUsecase _selfRentPocketUsecase;

  SelfRentPocketInfoPageViewModel(
    this._getProfileUsecase,
    this._getPocketSizesUsecase,
    this._selfRentPocketUsecase,
  );

  late CabinetInfo cabinetInfo;

  bool? _isCabinetOffline;

  final _note = Rx<String>('');
  final _user = Rx<User?>(null);
  final _pocketSizes = Rx<List<PocketSize>>([]);
  final _selectedCategory = Rx<PackageCategory?>(null);
  final _selectedIndex = Rx<int>(-1);

  int get selectedIndex => _selectedIndex.value;

  String get notes => _note.value;

  List<PocketSize> get pocketSizes => _pocketSizes.value;

  PackageCategory? get selectedCategory => _selectedCategory.value;

  User? get user => _user.value;

  bool get isCouldSubmit => selectedIndex != -1 && selectedCategory != null;

  void setNotes(String note) => _note(note);

  void setSelectedIndex(int index) {
    if ((pocketSizes[index].availablePocketsCount ?? 0) > 0) {
      _selectedIndex.value = index;
    }
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Future<Unit> handleRestError(RestError restError, String? errorCode) async {
    switch (errorCode) {
      case Constants.errorCodeCabinetDisconnected:
        _isCabinetOffline = true;
        break;
      default:
        await super.handleRestError(restError, errorCode);
    }
    return unit;
  }

  Future<bool> _fetchData() async {
    late User userLoaded;
    late List<PocketSize> pocketSizesLoaded;
    await showLoading();
    final success = await run(
      () async {
        userLoaded = await _getProfileUsecase.run();
        pocketSizesLoaded = await _getPocketSizesUsecase.run(cabinetInfo.id);
      },
    );
    await hideLoading();
    if (success) {
      _user(userLoaded);
      _pocketSizes(pocketSizesLoaded);
      if (!isAvailablePocket) {
        _showDialogEmptyPocket();
      }
    }
    return success;
  }

  void _showDialogEmptyPocket() {
    Get.dialog(
      CabinetEmptyPocketDialog(
        cabinetName: cabinetInfo.name,
      ),
      barrierDismissible: false,
    );
  }

  bool get isAvailablePocket {
    bool isCheck = false;
    for (final item in pocketSizes) {
      if ((item.availablePocketsCount ?? 0) > 0) {
        isCheck = true;
        break;
      }
    }
    return isCheck;
  }

  void onSelectCategory(PackageCategory itemSelect) => _selectedCategory(itemSelect);

  void _showOfflineDialog() {
    Get.dialog(
      OfflineDialog(
        cabinetInfo: cabinetInfo,
        onConfirm: handleSelfRent,
      ),
    );
  }

  Future<Unit> handleSelfRent() async {
    await showLoading();
    if (selectedIndex < 0) {
      showToast(LocaleKeys.delivery_must_select_pocket_sentence.trans());
    } else if (selectedCategory == null) {
      showToast(LocaleKeys.delivery_please_choose_category.trans());
    } else {
      late Delivery delivery;
      final success = await run(
        () async {
          delivery = await _selfRentPocketUsecase.run(
            cabinetId: cabinetInfo.id,
            sizeId: pocketSizes[selectedIndex].id,
            packageCategory: selectedCategory,
            note: notes,
          );
        },
      );
      await hideLoading();
      if (success) {
        await Get.off(
          () => SelfRentPocketStatePage(
            deliveryId: delivery.id,
            cabinetInfo: cabinetInfo,
          ),
        );
      } else {
        if (_isCabinetOffline == true) {
          _showOfflineDialog();
          _isCabinetOffline = null;
        }
      }
    }
    await hideLoading();
    return unit;
  }
}
