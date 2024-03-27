import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/system_maintenance/domain/models/system_maintenance.dart';

abstract class SystemMaintenanceFirebaseDatasource {
  Future<SystemMaintenance?> getRunningSystemMaintenance();
}

@LazySingleton(as: SystemMaintenanceFirebaseDatasource)
class SystemMaintenanceFirebaseConfigDatasourceImpl extends SystemMaintenanceFirebaseDatasource {
  final FirebaseRemoteConfig _firebaseRemoteConfig;

  SystemMaintenanceFirebaseConfigDatasourceImpl(
    this._firebaseRemoteConfig,
  );

  @override
  Future<SystemMaintenance?> getRunningSystemMaintenance() async {
    try {
      final data = _firebaseRemoteConfig.getString(Config.systemMaintenanceRemoteConfigKey);
      final jsonData = json.decode(data) as Map<String, dynamic>;
      if (jsonData["started_at"] != null && jsonData["ended_at"] != null) {
        return SystemMaintenance.fromJson(jsonData);
      }
    } catch (_) {}
    return null;
  }
}
