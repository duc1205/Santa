import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/firebase/notification_type.dart';
import 'package:santapocket/modules/user/data/repositories/user_repository.dart';
import 'package:santapocket/modules/user/domain/events/user_balance_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_coin_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_cone_changed_event.dart';
import 'package:santapocket/modules/user/domain/events/user_free_usage_changed_event.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class HandleFcmUserEventsUsecase {
  final UserRepository _userRepository;
  final EventBus _eventBus;

  HandleFcmUserEventsUsecase(this._userRepository, this._eventBus);

  Future<Unit> run(String type, String jsonData) async {
    await _userRepository.removeProfileCache();

    final data = json.decode(jsonData) as Map<String, dynamic>;
    final user = User.fromJson(data["user"] as Map<String, dynamic>);

    switch (type) {
      case NotificationType.userBalanceChanged:
        _eventBus.fire(UserBalanceChangedEvent(user: user));
        break;
      case NotificationType.userFreeUsageChanged:
        _eventBus.fire(UserFreeUsageChangedEvent(user: user));
        break;
      case NotificationType.userCoinChanged:
        _eventBus.fire(UserCoinChangedEvent(user: user));
        break;
      case NotificationType.userConeChangedEvent:
        _eventBus.fire(UserConeChangedEvent(user: user));
        break;
    }

    return unit;
  }
}
