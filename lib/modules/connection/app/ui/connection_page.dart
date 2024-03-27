import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/connection/domain/enums/connection_status.dart';
import 'package:santapocket/modules/connection/domain/events/connection_status_changed_event.dart';
import 'package:santapocket/modules/connection/domain/usecases/handle_connection_status_changed_usecase.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  StreamSubscription? _internetConnectionStatusChangedListener;
  StreamSubscription? _connectionStatusChangedListener;

  ConnectionStatus _connectionStatus = ConnectionStatus.connected;

  @override
  void initState() {
    super.initState();
    _internetConnectionStatusChangedListener = InternetConnectionChecker().onStatusChange.listen(
          locator<HandleConnectionStatusChangedUsecase>().run,
        );
    _connectionStatusChangedListener = locator<EventBus>().on<ConnectionStatusChangedEvent>().listen((event) {
      setState(() => _connectionStatus = event.status);
    });
  }

  @override
  void dispose() {
    _internetConnectionStatusChangedListener?.cancel();
    _connectionStatusChangedListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_connectionStatus) {
      case ConnectionStatus.connected:
        return const SizedBox();
      case ConnectionStatus.connectedRecently:
        return _buildWidget(context, Colors.green, LocaleKeys.connection_connected.trans());
      case ConnectionStatus.disconnected:
        return _buildWidget(context, Colors.red, LocaleKeys.connection_disconnected.trans());
    }
  }

  Widget _buildWidget(BuildContext context, Color backgroundColor, String text) {
    final height = MediaQuery.of(context).padding.top;
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: EdgeInsets.only(top: height),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            alignment: Alignment.center,
            height: 24.h,
            padding: EdgeInsets.all(5.h),
            color: backgroundColor,
            child: Text(
              text,
              style: AppTheme.white_12w400,
            ),
          ),
        ),
      ),
    );
  }
}
