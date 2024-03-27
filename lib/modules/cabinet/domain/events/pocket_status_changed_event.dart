import 'package:santapocket/modules/cabinet/domain/models/pocket.dart';
import 'package:suga_core/suga_core.dart';

class PocketStatusChangedEvent extends Event {
  final Pocket pocket;

  const PocketStatusChangedEvent({required this.pocket});
}
