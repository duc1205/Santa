import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/shared/enums/view_state.dart';
import 'package:suga_core/suga_core.dart';

class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  Future<Unit> setState(ViewState viewState, {bool showLoadingOnBusyState = true}) async {
    _state = viewState;
    notifyListeners();

    switch (viewState) {
      case ViewState.idle:
      case ViewState.error:
        if (EasyLoading.isShow) {
          await EasyLoading.dismiss();
        }
        break;
      case ViewState.busy:
        if (showLoadingOnBusyState) {
          await EasyLoading.show(
            status: LocaleKeys.shared_loading.trans(),
            maskType: EasyLoadingMaskType.black,
          );
        }
        break;
    }
    return unit;
  }
}
