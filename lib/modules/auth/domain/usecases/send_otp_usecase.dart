import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/auth/app/ui/login/enter_phone_page.dart';
import 'package:santapocket/modules/auth/data/repositories/auth_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class SendOtpUsecase extends Usecase {
  final AuthRepository _authRepository;

  const SendOtpUsecase(this._authRepository);

  Future<Unit> run({required String phoneNumber, required String locale, required int method}) {
    switch (method) {
      case EnterPhonePage.smsMethod:
        return _authRepository.sendOtp(phoneNumber: phoneNumber, locale: locale);
      case EnterPhonePage.voiceCallMethod:
        return _authRepository.sendOtpVoiceCall(phoneNumber: phoneNumber, locale: locale);
      case EnterPhonePage.zaloMethod:
        return _authRepository.sendOtpZalo(phoneNumber: phoneNumber, locale: locale);
      case EnterPhonePage.emailMethod:
        return _authRepository.sendOtpEmail(email: phoneNumber, locale: locale);
      default:
        return _authRepository.sendOtp(phoneNumber: phoneNumber, locale: locale);
    }
  }
}
