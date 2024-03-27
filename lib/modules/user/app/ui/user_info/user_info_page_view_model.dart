// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/user/app/ui/user_info/widgets/edit_user_type_dialog.dart';
import 'package:santapocket/modules/user/domain/enums/user_type.dart';
import 'package:santapocket/modules/user/domain/events/user_balance_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_coin_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_profile_changed_event.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/update_profile_usecase.dart';
import 'package:santapocket/shared/dialog/sg_alert_dialog.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart' hide BaseViewModel;

@injectable
class UserInfoPageViewModel extends AppViewModel {
  final GetProfileUsecase _getProfileUsecase;
  final UpdateProfileUsecase _updateProfileUsecase;

  UserInfoPageViewModel(this._getProfileUsecase, this._updateProfileUsecase);

  StreamSubscription? _listenUserBalanceChanged;
  StreamSubscription? _listenUserInfoChanged;
  StreamSubscription? _listenUserCoinChanged;

  final _user = Rx<User?>(null);
  final _userType = Rx<UserType>(UserType.defaultType);
  final _changeUserType = Rx<UserType>(UserType.defaultType);

  User? get user => _user.value;

  UserType get userType => _userType.value;

  UserType get changeUserType => _changeUserType.value;

  String errorMessage = '';
  String newName = '';

  void onUserBalanceChanged(User user) {
    _user.value = user;
  }

  void onUserInfoChanged(User user) {
    _user.value = user;
  }

  void onUserCoinChanged(User user) {
    _user.value = user;
  }

  @override
  void initState() {
    super.initState();
    getUserProfile();
    _listenUserBalanceChanged = locator<EventBus>().on<UserBalanceChangedEvent>().listen((event) {
      _user.value = null;
      onUserBalanceChanged(event.user);
    });
    _listenUserInfoChanged = locator<EventBus>().on<UserProfileChangedEvent>().listen((event) {
      _user.value = null;
      onUserInfoChanged(event.user);
    });
    _listenUserCoinChanged = locator<EventBus>().on<UserCoinChangedEvent>().listen((event) {
      _user.value = null;
      onUserCoinChanged(event.user);
    });
  }

  @override
  void disposeState() {
    _listenUserBalanceChanged?.cancel();
    _listenUserInfoChanged?.cancel();
    _listenUserCoinChanged?.cancel();
    super.disposeState();
  }

  bool checkNameValid(String name) {
    return name.trim().isNotEmpty;
  }

  String getUserName() => user?.name ?? "";

  String getUserType() => toBeginningOfSentenceCase(user?.type) ?? "";

  Future<Unit> getUserProfile() async {
    User? userLoaded;
    await showLoading();
    final isSuccess = await run(
      () async => userLoaded = await _getProfileUsecase.run(),
    );
    if (isSuccess) {
      _user.value = userLoaded;
      _userType.value = userLoaded?.type?.toUserType() ?? UserType.defaultType;
    }
    await hideLoading();
    return unit;
  }

  Future<Unit> changeUserName() async {
    User? userLoaded;
    if (!checkNameValid(newName)) {
      showToast(LocaleKeys.user_enter_name.trans());
      return unit;
    } else {
      await showLoading();
      final isSuccess = await run(
        () async => userLoaded = await _updateProfileUsecase.run(name: newName),
      );
      await hideLoading();
      if (isSuccess) {
        _user.value = userLoaded;
        Get.back();
        return unit;
      }
    }
    return unit;
  }

  Future<Unit> updateUserType() async {
    late User userLoaded;
    await showLoading();
    final isSuccess = await run(
      () async => userLoaded = await _updateProfileUsecase.run(type: changeUserType.getValue()),
    );
    await hideLoading();
    if (isSuccess) {
      _userType.value = userLoaded.type?.toUserType() ?? UserType.defaultType;
      Get.back();
    }
    return unit;
  }

  void onChangeUserType() {
    _changeUserType.value = userType;
    Get.dialog(
      SGAlertDialog(
        bodyViewDistance: 10.h,
        title: LocaleKeys.user_change_type.trans(),
        bodyView: Obx(
          () => EditUserTypeDialog(
            userType: changeUserType,
            onChangeUserType: (newUserType) => _changeUserType.value = newUserType,
          ),
        ),
        confirmButton: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: 15.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            backgroundColor: AppTheme.yellow1,
          ),
          onPressed: () => updateUserType(),
          child: Text(
            LocaleKeys.user_save.trans(),
            style: AppTheme.white_14w600,
          ),
        ),
        cancelButton: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: 15.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            backgroundColor: AppTheme.border,
          ),
          onPressed: () => Get.back(),
          child: Text(
            LocaleKeys.user_cancel.trans(),
            style: AppTheme.white_14w600,
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
