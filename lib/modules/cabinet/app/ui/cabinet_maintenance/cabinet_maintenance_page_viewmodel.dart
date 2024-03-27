import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';

@injectable
class CabinetMaintenancePageViewModel extends AppViewModel {
  final GetSettingUsecase _getSettingUsecase;

  CabinetMaintenancePageViewModel(this._getSettingUsecase);

  final _bankTransferInfo = Rx<Map<String, dynamic>>({});

  Map<String, dynamic> get bankTransferInfo => _bankTransferInfo.value;

  @override
  void initState() {
    _getBankTransferInfo();
    super.initState();
  }

  Future<bool> _getBankTransferInfo() async {
    late Map<String, dynamic> bankTransferInfoLoaded;
    await showLoading();
    final success = await run(
      () async {
        final bankTransferInfoFetched = (await _getSettingUsecase.run(Constants.appBankTransferInfo)).value;
        if (bankTransferInfoFetched is Map<String, dynamic>) {
          bankTransferInfoLoaded = bankTransferInfoFetched;
        }
      },
    );
    if (success) {
      _bankTransferInfo.value = bankTransferInfoLoaded;
    }
    await hideLoading();
    return success;
  }
}
