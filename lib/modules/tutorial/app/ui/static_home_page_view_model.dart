import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/modules/user/domain/usecases/complete_tutorial_usecase.dart';
import 'package:suga_core/suga_core.dart' hide BaseViewModel;

@injectable
class StaticHomePageViewModel extends AppViewModel {
  final CompleteTutorialUsecase _completeTutorialUsecase;

  StaticHomePageViewModel(this._completeTutorialUsecase);

  Future<Unit> completeTutorial() async {
    await run(
      () => _completeTutorialUsecase.run(),
    );
    return unit;
  }
}
