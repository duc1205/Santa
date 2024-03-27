import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class CharityPageViewModel extends AppViewModel {
  final GetSettingUsecase _getSettingUsecase;
  final GetProfileUsecase _getProfileUsecase;

  CharityPageViewModel(
    this._getSettingUsecase,
    this._getProfileUsecase,
  );

  final _helpCenterUrl = Rx<String>("");
  final _user = Rx<User?>(null);

  String get helpCenterUrl => _helpCenterUrl.value;
  User? get user => _user.value;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<Unit> _initData() async {
    await _getUserProfile();
    await _getSetting();
    return unit;
  }

  Future<Unit> _getSetting() async {
    late String helpCenterUrlFetch;
    final success = await run(() async {
      if (user != null) {
        final locale = user?.locale ?? FormatHelper.getPlatformLocaleName();
        helpCenterUrlFetch =
            (await _getSettingUsecase.run(locale == Language.vi.getValue() ? Constants.charityInstructionUrlVi : Constants.charityInstructionUrlEn))
                    .value ??
                "";
      }
    });
    if (success) {
      _helpCenterUrl.value = helpCenterUrlFetch;
    }
    return unit;
  }

  Future<Unit> _getUserProfile() async {
    User? userFetch;

    final success = await run(
      () async {
        userFetch = await _getProfileUsecase.run();
      },
    );

    if (success) {
      _user.value = userFetch;
    }
    return unit;
  }
}
