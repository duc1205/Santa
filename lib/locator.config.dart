// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:alice_lightweight/alice.dart' as _i3;
import 'package:dio/dio.dart' as _i6;
import 'package:event_bus/event_bus.dart' as _i7;
import 'package:firebase_remote_config/firebase_remote_config.dart' as _i11;
import 'package:flutter/widgets.dart' as _i31;
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as _i12;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i13;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:logger/logger.dart' as _i21;
import 'package:shared_preferences/shared_preferences.dart' as _i35;

import 'core/helpers/loading_helper.dart' as _i20;
import 'firebase/domain/usecases/register_fcm_token_usecase.dart' as _i29;
import 'firebase/domain/usecases/unregister_fcm_token_usecase.dart' as _i38;
import 'firebase/fcm_manager.dart' as _i8;
import 'locator.dart' as _i227;
import 'modules/auth/app/ui/login/enter_phone_page_viewmodel.dart' as _i213;
import 'modules/auth/data/datasources/auth_remote_datasource.dart' as _i71;
import 'modules/auth/data/datasources/services/auth_service.dart' as _i41;
import 'modules/auth/data/datasources/services/otp_service.dart' as _i25;
import 'modules/auth/data/repositories/auth_repository.dart' as _i72;
import 'modules/auth/domain/usecases/get_countries_usecase.dart' as _i116;
import 'modules/auth/domain/usecases/refresh_token_usecase.dart' as _i170;
import 'modules/auth/domain/usecases/send_otp_usecase.dart' as _i176;
import 'modules/boarding/app/ui/splash/splash_page_view_model.dart' as _i177;
import 'modules/cabinet/app/ui/cabinet_detail/cabinet_detail_page_view_model.dart' as _i186;
import 'modules/cabinet/app/ui/cabinet_list/cabinet_list_page_viewmodel.dart' as _i187;
import 'modules/cabinet/app/ui/cabinet_list/filter/filer_cities/filter_cities_page_view_model.dart' as _i215;
import 'modules/cabinet/app/ui/cabinet_list/filter/filter_cabinet_page_view_model.dart' as _i9;
import 'modules/cabinet/app/ui/cabinet_list/filter/filter_district/filter_districts_page_view_model.dart' as _i216;
import 'modules/cabinet/app/ui/cabinet_maintenance/cabinet_maintenance_page_viewmodel.dart' as _i188;
import 'modules/cabinet/app/ui/cabinet_map/cabinet_map_page_viewmodel.dart' as _i5;
import 'modules/cabinet/data/datasources/cabinet_remote_datasource.dart' as _i73;
import 'modules/cabinet/data/datasources/services/cabinet_location_service.dart' as _i42;
import 'modules/cabinet/data/datasources/services/cabinet_service.dart' as _i43;
import 'modules/cabinet/data/repositories/cabinet_repository.dart' as _i74;
import 'modules/cabinet/domain/usecases/get_cabinet_cities_usecase.dart' as _i99;
import 'modules/cabinet/domain/usecases/get_cabinet_districts_usecase.dart' as _i100;
import 'modules/cabinet/domain/usecases/get_cabinet_info_usecase.dart' as _i101;
import 'modules/cabinet/domain/usecases/get_cabinet_usecase.dart' as _i102;
import 'modules/cabinet/domain/usecases/get_cabinets_nearby_usecase.dart' as _i103;
import 'modules/cabinet/domain/usecases/get_cabinets_usecase.dart' as _i104;
import 'modules/cabinet/domain/usecases/get_list_cabinet_info_usecase.dart' as _i126;
import 'modules/cabinet/domain/usecases/get_list_cabinet_info_with_authorizations_usecase.dart' as _i127;
import 'modules/cabinet/domain/usecases/get_pocket_sizes_usecase.dart' as _i133;
import 'modules/charity/app/ui/charity_campaign_detail/charity_campaign_detail_page_viewmodel.dart' as _i194;
import 'modules/charity/app/ui/charity_campaigns/charity_campaigns_page_viewmodel.dart' as _i195;
import 'modules/charity/app/ui/charity_donors/charity_donors_page_viewmodel.dart' as _i197;
import 'modules/charity/app/ui/charity_history/charity_delivery_history_page_viewmodel.dart' as _i196;
import 'modules/charity/app/ui/charity_organization_detail/charity_organization_detail_page_viewmodel.dart' as _i198;
import 'modules/charity/app/ui/charity_page_viewmodel.dart' as _i199;
import 'modules/charity/app/ui/charity_phone_number_picker/charity_phone_number_picker_page_view_model.dart' as _i200;
import 'modules/charity/app/ui/charity_phone_number_picker/volunteers/volunteers_page_viewmodel.dart' as _i184;
import 'modules/charity/app/ui/charity_scan/charity_scan_page_viewmodel.dart' as _i201;
import 'modules/charity/app/ui/workflow/result/fail/charity_delivery_failed_page_view_model.dart' as _i226;
import 'modules/charity/app/ui/workflow/send/charity_send_package_info_page_viewmodel.dart' as _i202;
import 'modules/charity/app/ui/workflow/send/charity_send_pocket_state_page_viewmodel.dart' as _i203;
import 'modules/charity/data/datasources/charity_remote_datasource.dart' as _i75;
import 'modules/charity/data/datasources/services/charity_service.dart' as _i44;
import 'modules/charity/data/repositories/charity_repository.dart' as _i76;
import 'modules/charity/domain/usecases/check_if_donatable_usecase.dart' as _i77;
import 'modules/charity/domain/usecases/get_available_charity_campaigns_usecase.dart' as _i96;
import 'modules/charity/domain/usecases/get_charities_usecase.dart' as _i105;
import 'modules/charity/domain/usecases/get_charity_by_id_usecase.dart' as _i106;
import 'modules/charity/domain/usecases/get_charity_campaign_detail_usecase.dart' as _i107;
import 'modules/charity/domain/usecases/get_charity_campaign_images_usecase.dart' as _i108;
import 'modules/charity/domain/usecases/get_charity_campaigns_usecase.dart' as _i109;
import 'modules/charity/domain/usecases/get_charity_deliveries_usecase.dart' as _i111;
import 'modules/charity/domain/usecases/get_charity_donations_usecase.dart' as _i113;
import 'modules/charity/domain/usecases/get_charity_donors_usecase.dart' as _i114;
import 'modules/charity/domain/usecases/get_charity_volunteers_usecase.dart' as _i115;
import 'modules/connection/domain/usecases/handle_connection_status_changed_usecase.dart' as _i15;
import 'modules/delivery/app/ui/cancel/cancel_delivery_state_page_view_model.dart' as _i190;
import 'modules/delivery/app/ui/detail/delivery_detail_page_view_model.dart' as _i210;
import 'modules/delivery/app/ui/history/delivery_history_page_viewmodel.dart' as _i212;
import 'modules/delivery/app/ui/history/filter/filter_cabinets/filter_cabinets_view_model.dart' as _i214;
import 'modules/delivery/app/ui/history/filter/filter_page_view_model.dart' as _i10;
import 'modules/delivery/app/ui/workflow/receive/owner_package/receive_owner_packages_page_viewmodel.dart' as _i165;
import 'modules/delivery/app/ui/workflow/receive/receive_packages_page_viewmodel.dart' as _i166;
import 'modules/delivery/app/ui/workflow/receive/receive_pocket_state_page_viewmodel.dart' as _i168;
import 'modules/delivery/app/ui/workflow/reopen_pocket/reopen_pocket_state_page_viewmodel.dart' as _i172;
import 'modules/delivery/app/ui/workflow/result/fail/delivery_failed_page_view_model.dart' as _i211;
import 'modules/delivery/app/ui/workflow/result/success/receive_pocket_state_complete_page_viewmodel.dart' as _i167;
import 'modules/delivery/app/ui/workflow/self_rent/self_rent_pocket_info_page_viewmodel.dart' as _i221;
import 'modules/delivery/app/ui/workflow/self_rent/self_rent_pocket_state_page_viewmodel.dart' as _i222;
import 'modules/delivery/app/ui/workflow/send/send_package_info_page_viewmodel.dart' as _i223;
import 'modules/delivery/app/ui/workflow/send/send_pocket_state_page_viewmodel.dart' as _i224;
import 'modules/delivery/app/ui/workflow/send_and_receive/send_and_receive_page_viewmodel.dart' as _i33;
import 'modules/delivery/app/ui/workflow/shared/phone_number_picker/contacts/contacts_page_viewmodel.dart' as _i45;
import 'modules/delivery/app/ui/workflow/shared/phone_number_picker/phone_number_picker_page_view_model.dart' as _i159;
import 'modules/delivery/data/datasources/delivery_remote_datasource.dart' as _i91;
import 'modules/delivery/data/datasources/services/delivery_service.dart' as _i47;
import 'modules/delivery/data/repositories/delivery_repository.dart' as _i92;
import 'modules/delivery/domain/usecases/cancel_delivery_usecase.dart' as _i191;
import 'modules/delivery/domain/usecases/cancel_sent_delivery_usecase.dart' as _i192;
import 'modules/delivery/domain/usecases/change_pocket_size_usecase.dart' as _i193;
import 'modules/delivery/domain/usecases/check_delivery_reopenable_usecase.dart' as _i205;
import 'modules/delivery/domain/usecases/create_delivery_usecase.dart' as _i207;
import 'modules/delivery/domain/usecases/donate_for_charity_usecase.dart' as _i93;
import 'modules/delivery/domain/usecases/get_charity_deliveries_usecase.dart' as _i110;
import 'modules/delivery/domain/usecases/get_charity_delivery_usecase.dart' as _i112;
import 'modules/delivery/domain/usecases/get_deliveries_usecase.dart' as _i117;
import 'modules/delivery/domain/usecases/get_delivery_reopen_request_usecase.dart' as _i120;
import 'modules/delivery/domain/usecases/get_delivery_usecase.dart' as _i121;
import 'modules/delivery/domain/usecases/get_estimate_final_receiving_price_usecase.dart' as _i122;
import 'modules/delivery/domain/usecases/get_people_usecase.dart' as _i14;
import 'modules/delivery/domain/usecases/get_receivable_deliveries_usecase.dart' as _i135;
import 'modules/delivery/domain/usecases/get_recent_receivers_usecase.dart' as _i137;
import 'modules/delivery/domain/usecases/receive_delivery_usecase.dart' as _i164;
import 'modules/delivery/domain/usecases/rent_pocket_usecase.dart' as _i171;
import 'modules/delivery/domain/usecases/reopen_pocket_usecase.dart' as _i173;
import 'modules/delivery/domain/usecases/search_people_usecase.dart' as _i32;
import 'modules/delivery/domain/usecases/self_rent_pocket_usecase.dart' as _i174;
import 'modules/delivery/domain/usecases/send_delivery_usecase.dart' as _i175;
import 'modules/delivery_authorization/app/ui/authorize/authorize_delivery_view_model.dart' as _i225;
import 'modules/delivery_authorization/app/ui/delivery_authorization_detail/delivery_authorization_detail_page_viewmodel.dart' as _i209;
import 'modules/delivery_authorization/app/ui/receive_delivery_authorization/receive_delivery_authorization_state_page_viewmodel.dart' as _i160;
import 'modules/delivery_authorization/app/ui/receive_delivery_authorization/receive_delivery_authorizations_page_viewmodel.dart' as _i163;
import 'modules/delivery_authorization/app/ui/result/receive_delivery_authorization_success_page_viewmodel.dart' as _i161;
import 'modules/delivery_authorization/data/datasources/delivery_authorization_datasource.dart' as _i89;
import 'modules/delivery_authorization/data/datasources/services/delivery_authorization_service.dart' as _i46;
import 'modules/delivery_authorization/data/repositories/delivery_authorization_repositories.dart' as _i90;
import 'modules/delivery_authorization/domain/usecases/cancel_delivery_authorization_usecase.dart' as _i189;
import 'modules/delivery_authorization/domain/usecases/create_delivery_authorization_usecase.dart' as _i206;
import 'modules/delivery_authorization/domain/usecases/get_delivery_authorization_usecase.dart' as _i118;
import 'modules/delivery_authorization/domain/usecases/get_delivery_authorizations_usecase.dart' as _i119;
import 'modules/delivery_authorization/domain/usecases/get_receivable_delivery_authorizations_usecase.dart' as _i136;
import 'modules/delivery_authorization/domain/usecases/notify_delivery_authorization_receiver_usecase.dart' as _i157;
import 'modules/delivery_authorization/domain/usecases/receive_delivery_authorization_usecase.dart' as _i162;
import 'modules/hrm_payroll/app/ui/detail/hrm_payroll_detail_page_viewmodel.dart' as _i148;
import 'modules/hrm_payroll/app/ui/hrm_payroll_register_page_viewmodel.dart' as _i218;
import 'modules/hrm_payroll/app/ui/info/hrm_payroll_info_page_viewmodel.dart' as _i149;
import 'modules/hrm_payroll/app/ui/result/hrm_payroll_success_page_viewmodel.dart' as _i17;
import 'modules/hrm_payroll/data/datasources/hrm_payroll_remote_datasource.dart' as _i48;
import 'modules/hrm_payroll/data/datasources/services/hrm_payroll_service.dart' as _i16;
import 'modules/hrm_payroll/data/repositories/hrm_payroll_repository.dart' as _i49;
import 'modules/hrm_payroll/domain/usecases/activate_payroll_account_usecase.dart' as _i69;
import 'modules/hrm_payroll/domain/usecases/check_payroll_status_usecase.dart' as _i78;
import 'modules/hrm_payroll/domain/usecases/deactivate_payroll_account_usecase.dart' as _i87;
import 'modules/hrm_payroll/domain/usecases/get_payroll_amount_usecase.dart' as _i131;
import 'modules/hrm_payroll/domain/usecases/get_payroll_logs_usecase.dart' as _i132;
import 'modules/instruction/app/ui/detail/instruction_detail_page_view_model.dart' as _i151;
import 'modules/instruction/app/ui/instruction_page_view_model.dart' as _i152;
import 'modules/instruction/data/datasources/instruction_remote_datasource.dart' as _i50;
import 'modules/instruction/data/datasources/services/instruction_service.dart' as _i19;
import 'modules/instruction/data/repositories/instruction_repository.dart' as _i51;
import 'modules/instruction/domain/usecases/get_instruction_by_id_usecase.dart' as _i123;
import 'modules/instruction/domain/usecases/get_instruction_images_usecase.dart' as _i124;
import 'modules/instruction/domain/usecases/get_instructions_usecase.dart' as _i125;
import 'modules/main/app/ui/home/home_page_viewmodel.dart' as _i217;
import 'modules/main/app/ui/main_page_viewmodel.dart' as _i219;
import 'modules/marketing_campaign/app/ui/marketing_campaign/marketing_campaigns_page_viewmodel.dart' as _i155;
import 'modules/marketing_campaign/data/datasources/marketing_campaign_datasource.dart' as _i52;
import 'modules/marketing_campaign/data/datasources/services/marketing_campaign_service.dart' as _i22;
import 'modules/marketing_campaign/data/repositories/marketing_campaign_repositories.dart' as _i53;
import 'modules/marketing_campaign/domain/usecases/click_on_campaign_banner_usecase.dart' as _i81;
import 'modules/marketing_campaign/domain/usecases/click_on_campaign_popup_usecase.dart' as _i82;
import 'modules/marketing_campaign/domain/usecases/get_running_marketing_campaigns_usecase.dart' as _i138;
import 'modules/notification/app/ui/notification_page_viewmodel.dart' as _i156;
import 'modules/notification/data/datasources/notification_remote_datasource.dart' as _i54;
import 'modules/notification/data/datasources/services/notification_service.dart' as _i24;
import 'modules/notification/data/repositories/notification_repository.dart' as _i55;
import 'modules/notification/domain/usecases/count_unread_notifications_usecase.dart' as _i84;
import 'modules/notification/domain/usecases/get_notifications_usecase.dart' as _i128;
import 'modules/notification/domain/usecases/get_system_notifications_usecase.dart' as _i143;
import 'modules/notification/domain/usecases/get_total_system_notifications_usecase.dart' as _i144;
import 'modules/notification/domain/usecases/mark_all_notifications_as_read_usecase.dart' as _i154;
import 'modules/notification/domain/usecases/read_notification_usecase.dart' as _i58;
import 'modules/payment/app/ui/hrm_payroll/hrm_payroll_transaction_confirmation_page_viewmodel.dart' as _i150;
import 'modules/payment/app/ui/payment_page_viewmodel.dart' as _i158;
import 'modules/payment/data/datasources/payment_remote_datasource.dart' as _i56;
import 'modules/payment/data/datasources/services/payment_service.dart' as _i26;
import 'modules/payment/data/repositories/payment_repository.dart' as _i57;
import 'modules/payment/domain/usecases/create_payment_momo_usecase.dart' as _i85;
import 'modules/payment/domain/usecases/create_payment_vnpay_usecase.dart' as _i86;
import 'modules/payment/domain/usecases/get_bank_transfer_message_usecase.dart' as _i98;
import 'modules/payment/domain/usecases/get_payment_order_usecase.dart' as _i129;
import 'modules/payment/domain/usecases/get_payment_products_usecase.dart' as _i130;
import 'modules/payment/domain/usecases/topup_payroll_usecase.dart' as _i65;
import 'modules/permission/domain/usecases/check_and_request_notification_permission_usecase.dart' as _i204;
import 'modules/referral_campaign/app/ui/insert_code/referral_insert_code_page_viewmodel.dart' as _i169;
import 'modules/referral_campaign/data/datasources/referral_campaign_cache_datasource.dart' as _i27;
import 'modules/referral_campaign/data/datasources/referral_campaign_remote_datasource.dart' as _i59;
import 'modules/referral_campaign/data/datasources/services/referral_campaign_service.dart' as _i28;
import 'modules/referral_campaign/data/repositories/referral_campaign_repositories.dart' as _i60;
import 'modules/referral_campaign/domain/usecases/check_referral_code_usecase.dart' as _i79;
import 'modules/referral_campaign/domain/usecases/get_running_referral_campaign_usecase.dart' as _i139;
import 'modules/referral_campaign/domain/usecases/verify_referral_code_usecase.dart' as _i68;
import 'modules/setting/data/datasources/services/setting_service.dart' as _i34;
import 'modules/setting/data/datasources/setting_remote_datasource.dart' as _i61;
import 'modules/setting/data/repositories/setting_repository.dart' as _i62;
import 'modules/setting/domain/usecases/get_setting_usecase.dart' as _i141;
import 'modules/setting/domain/usecases/get_settings_usecase.dart' as _i142;
import 'modules/system_maintenance/app/ui/system_maintenance_page_view_model.dart' as _i179;
import 'modules/system_maintenance/data/datasources/services/system_maintenance_service.dart' as _i37;
import 'modules/system_maintenance/data/datasources/system_maintenance_datasource.dart' as _i63;
import 'modules/system_maintenance/data/datasources/system_maintenance_firebase_datasource.dart' as _i36;
import 'modules/system_maintenance/data/repositories/system_maintenance_repository.dart' as _i64;
import 'modules/system_maintenance/domain/usecases/get_active_system_maintenance_usecase.dart' as _i95;
import 'modules/system_maintenance/domain/usecases/get_running_system_maintenance_usecase.dart' as _i140;
import 'modules/tutorial/app/ui/static_home_page_view_model.dart' as _i178;
import 'modules/user/app/ui/app_info/app_info_viewmodel.dart' as _i4;
import 'modules/user/app/ui/delete_account/delete_account_page_view_model.dart' as _i208;
import 'modules/user/app/ui/profile/profile_page_view_model.dart' as _i220;
import 'modules/user/app/ui/transaction_history/transaction_history_page_view_model.dart' as _i180;
import 'modules/user/app/ui/user_info/user_info_page_view_model.dart' as _i183;
import 'modules/user/app/ui/wizard/wizard_profile_page_viewmodel.dart' as _i185;
import 'modules/user/data/datasources/services/me_service.dart' as _i23;
import 'modules/user/data/datasources/services/user_service.dart' as _i40;
import 'modules/user/data/datasources/user_cache_datasource.dart' as _i39;
import 'modules/user/data/datasources/user_remote_datasource.dart' as _i66;
import 'modules/user/data/repositories/user_repository.dart' as _i67;
import 'modules/user/domain/usecases/agree_tos_usecase.dart' as _i70;
import 'modules/user/domain/usecases/clear_user_cache_usecase.dart' as _i80;
import 'modules/user/domain/usecases/complete_tutorial_usecase.dart' as _i83;
import 'modules/user/domain/usecases/delete_account_usecase.dart' as _i88;
import 'modules/user/domain/usecases/find_user_public_info_usecase.dart' as _i94;
import 'modules/user/domain/usecases/get_balance_logs_usecase.dart' as _i97;
import 'modules/user/domain/usecases/get_profile_usecase.dart' as _i134;
import 'modules/user/domain/usecases/get_user_cone_logs_usecase.dart' as _i145;
import 'modules/user/domain/usecases/handle_fcm_user_events_usecase.dart' as _i147;
import 'modules/user/domain/usecases/logout_usecase.dart' as _i153;
import 'modules/user/domain/usecases/update_device_info_usecase.dart' as _i181;
import 'modules/user/domain/usecases/update_profile_usecase.dart' as _i182;
import 'modules/version/domain/usecases/get_version_status_usecase.dart' as _i146;
import 'retrofit/rest_client.dart' as _i30;
import 'shared/ui/in_app_web_view_page_view_model.dart' as _i18; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final locator = _$Locator();
  gh.lazySingleton<_i3.Alice>(() => locator.getAlice());
  gh.factory<_i4.AppInfoViewModel>(() => _i4.AppInfoViewModel());
  gh.factory<_i5.CabinetMapPageViewModel>(() => _i5.CabinetMapPageViewModel());
  gh.lazySingleton<_i6.Dio>(() => locator.getDio());
  gh.lazySingleton<_i7.EventBus>(() => locator.getEventBus());
  gh.lazySingleton<_i8.FCMManager>(() => locator.getFcmManager());
  gh.factory<_i9.FilterCabinetPageViewModel>(() => _i9.FilterCabinetPageViewModel());
  gh.factory<_i10.FilterPageViewModel>(() => _i10.FilterPageViewModel());
  gh.lazySingleton<_i11.FirebaseRemoteConfig>(() => locator.getFirebaseRemoteConfig());
  gh.lazySingleton<_i12.FlutterLocalNotificationsPlugin>(() => locator.getFlutterNotificationPlugin());
  gh.lazySingleton<_i13.FlutterSecureStorage>(() => locator.getStorage());
  gh.lazySingleton<_i14.GetPeopleUsecase>(() => _i14.GetPeopleUsecase());
  gh.lazySingleton<_i15.HandleConnectionStatusChangedUsecase>(() => _i15.HandleConnectionStatusChangedUsecase(get<_i7.EventBus>()));
  gh.lazySingleton<_i16.HrmPayrollService>(() => _i16.HrmPayrollService(get<_i6.Dio>()));
  gh.factory<_i17.HrmPayrollSuccessPageViewmodel>(() => _i17.HrmPayrollSuccessPageViewmodel());
  gh.factory<_i18.InAppWebViewPageViewModel>(() => _i18.InAppWebViewPageViewModel());
  gh.lazySingleton<_i19.InstructionService>(() => _i19.InstructionService(get<_i6.Dio>()));
  gh.lazySingleton<_i20.LoadingHelper>(() => _i20.LoadingHelper());
  gh.lazySingleton<_i21.Logger>(() => locator.getLogger());
  gh.lazySingleton<_i22.MarketingCampaignService>(() => _i22.MarketingCampaignService(get<_i6.Dio>()));
  gh.lazySingleton<_i23.MeService>(() => _i23.MeService(get<_i6.Dio>()));
  gh.lazySingleton<_i24.NotificationService>(() => _i24.NotificationService(get<_i6.Dio>()));
  gh.lazySingleton<_i25.OTPService>(() => _i25.OTPService(get<_i6.Dio>()));
  gh.lazySingleton<_i26.PaymentService>(() => _i26.PaymentService(get<_i6.Dio>()));
  gh.lazySingleton<_i27.ReferralCampaignCacheDatasource>(() => _i27.ReferralCacheDataSourceImpl(get<_i13.FlutterSecureStorage>()));
  gh.lazySingleton<_i28.ReferralCampaignService>(() => _i28.ReferralCampaignService(get<_i6.Dio>()));
  gh.lazySingleton<_i29.RegisterFcmTokenUsecase>(() => _i29.RegisterFcmTokenUsecase());
  gh.lazySingleton<_i30.RestClient>(() => _i30.RestClient());
  gh.lazySingleton<_i31.RouteObserver<_i31.Route<dynamic>>>(() => locator.getRouteObserver());
  gh.lazySingleton<_i32.SearchPeopleUsecase>(() => _i32.SearchPeopleUsecase());
  gh.factory<_i33.SendAndReceivePageViewModel>(() => _i33.SendAndReceivePageViewModel());
  gh.lazySingleton<_i34.SettingService>(() => _i34.SettingService(get<_i6.Dio>()));
  await gh.lazySingletonAsync<_i35.SharedPreferences>(
    () => locator.getSharePreferences(),
    preResolve: true,
  );
  gh.lazySingleton<_i36.SystemMaintenanceFirebaseDatasource>(
      () => _i36.SystemMaintenanceFirebaseConfigDatasourceImpl(get<_i11.FirebaseRemoteConfig>()));
  gh.lazySingleton<_i37.SystemMaintenanceService>(() => _i37.SystemMaintenanceService(get<_i6.Dio>()));
  gh.lazySingleton<_i38.UnregisterFcmTokenUsecase>(() => _i38.UnregisterFcmTokenUsecase());
  gh.lazySingleton<_i39.UserCacheDatasource>(() => _i39.UseCacheDataSourceImpl(get<_i13.FlutterSecureStorage>()));
  gh.lazySingleton<_i40.UserService>(() => _i40.UserService(get<_i6.Dio>()));
  gh.lazySingleton<_i41.AuthService>(() => _i41.AuthService(get<_i6.Dio>()));
  gh.lazySingleton<_i42.CabinetLocationService>(() => _i42.CabinetLocationService(get<_i6.Dio>()));
  gh.lazySingleton<_i43.CabinetService>(() => _i43.CabinetService(get<_i6.Dio>()));
  gh.lazySingleton<_i44.CharityService>(() => _i44.CharityService(get<_i6.Dio>()));
  gh.factory<_i45.ContactsPageViewModel>(() => _i45.ContactsPageViewModel(get<_i32.SearchPeopleUsecase>()));
  gh.lazySingleton<_i46.DeliveryAuthorizationService>(() => _i46.DeliveryAuthorizationService(get<_i6.Dio>()));
  gh.lazySingleton<_i47.DeliveryService>(() => _i47.DeliveryService(get<_i6.Dio>()));
  gh.lazySingleton<_i48.HrmPayrollRemoteDatasource>(() => _i48.HrmPayrollRemoteDatasourceImpl(get<_i16.HrmPayrollService>()));
  gh.lazySingleton<_i49.HrmPayrollRepository>(() => _i49.HrmPayrollRepository(get<_i48.HrmPayrollRemoteDatasource>()));
  gh.lazySingleton<_i50.InstructionRemoteDatasource>(() => _i50.InstructionRemoteDatasourceImpl(get<_i19.InstructionService>()));
  gh.lazySingleton<_i51.InstructionRepository>(() => _i51.InstructionRepository(get<_i50.InstructionRemoteDatasource>()));
  gh.lazySingleton<_i52.MarketingCampaignDatasource>(() => _i52.MarketingCampaignDatasourceImpl(get<_i22.MarketingCampaignService>()));
  gh.lazySingleton<_i53.MarketingCampaignRepositories>(() => _i53.MarketingCampaignRepositories(get<_i52.MarketingCampaignDatasource>()));
  gh.lazySingleton<_i54.NotificationRemoteDatasource>(() => _i54.NotificationRemoteDatasourceImpl(get<_i24.NotificationService>()));
  gh.lazySingleton<_i55.NotificationRepository>(() => _i55.NotificationRepository(get<_i54.NotificationRemoteDatasource>()));
  gh.lazySingleton<_i56.PaymentRemoteDatasource>(() => _i56.PaymentRemoteDatasourceImpl(get<_i26.PaymentService>()));
  gh.lazySingleton<_i57.PaymentRepository>(() => _i57.PaymentRepository(get<_i56.PaymentRemoteDatasource>()));
  gh.lazySingleton<_i58.ReadNotificationUsecase>(() => _i58.ReadNotificationUsecase(get<_i55.NotificationRepository>()));
  gh.lazySingleton<_i59.ReferralCampaignRemoteDatasource>(() => _i59.MarketingCampaignDatasourceImpl(get<_i28.ReferralCampaignService>()));
  gh.lazySingleton<_i60.ReferralCampaignRepositories>(() => _i60.ReferralCampaignRepositories(
        get<_i59.ReferralCampaignRemoteDatasource>(),
        get<_i27.ReferralCampaignCacheDatasource>(),
      ));
  gh.lazySingleton<_i61.SettingRemoteDatasource>(() => _i61.SettingRemoteDatasourceImpl(get<_i34.SettingService>()));
  gh.lazySingleton<_i62.SettingRepository>(() => _i62.SettingRepository(get<_i61.SettingRemoteDatasource>()));
  gh.lazySingleton<_i63.SystemMaintenanceDatasource>(() => _i63.SystemMaintenanceDatasourceImpl(get<_i37.SystemMaintenanceService>()));
  gh.lazySingleton<_i64.SystemMaintenanceRepository>(() => _i64.SystemMaintenanceRepository(
        get<_i63.SystemMaintenanceDatasource>(),
        get<_i36.SystemMaintenanceFirebaseDatasource>(),
      ));
  gh.lazySingleton<_i65.TopupPayrollUsecase>(() => _i65.TopupPayrollUsecase(get<_i57.PaymentRepository>()));
  gh.lazySingleton<_i66.UserRemoteDatasource>(() => _i66.UserRemoteDatasourceImpl(
        get<_i23.MeService>(),
        get<_i40.UserService>(),
      ));
  gh.lazySingleton<_i67.UserRepository>(() => _i67.UserRepository(
        get<_i66.UserRemoteDatasource>(),
        get<_i39.UserCacheDatasource>(),
      ));
  gh.lazySingleton<_i68.VerifyReferralCodeUsecase>(() => _i68.VerifyReferralCodeUsecase(get<_i60.ReferralCampaignRepositories>()));
  gh.lazySingleton<_i69.ActivatePayrollAccountUsecase>(() => _i69.ActivatePayrollAccountUsecase(get<_i49.HrmPayrollRepository>()));
  gh.lazySingleton<_i70.AgreeTosUsecase>(() => _i70.AgreeTosUsecase(get<_i67.UserRepository>()));
  gh.lazySingleton<_i71.AuthRemoteDatasource>(() => _i71.AuthRemoteDatasourceImpl(
        get<_i25.OTPService>(),
        get<_i41.AuthService>(),
      ));
  gh.lazySingleton<_i72.AuthRepository>(() => _i72.AuthRepository(get<_i71.AuthRemoteDatasource>()));
  gh.lazySingleton<_i73.CabinetRemoteDatasource>(() => _i73.CabinetRemoteDatasourceImpl(
        get<_i43.CabinetService>(),
        get<_i42.CabinetLocationService>(),
      ));
  gh.lazySingleton<_i74.CabinetRepository>(() => _i74.CabinetRepository(get<_i73.CabinetRemoteDatasource>()));
  gh.lazySingleton<_i75.CharityRemoteDatasource>(() => _i75.CharityRemoteDatasourceImpl(get<_i44.CharityService>()));
  gh.lazySingleton<_i76.CharityRepository>(() => _i76.CharityRepository(get<_i75.CharityRemoteDatasource>()));
  gh.lazySingleton<_i77.CheckIfDonatableUsecase>(() => _i77.CheckIfDonatableUsecase(get<_i76.CharityRepository>()));
  gh.lazySingleton<_i78.CheckPayrollStatusUsecase>(() => _i78.CheckPayrollStatusUsecase(get<_i49.HrmPayrollRepository>()));
  gh.lazySingleton<_i79.CheckReferralCodeUsecase>(() => _i79.CheckReferralCodeUsecase(get<_i60.ReferralCampaignRepositories>()));
  gh.lazySingleton<_i80.ClearUserCacheUsecase>(() => _i80.ClearUserCacheUsecase(get<_i67.UserRepository>()));
  gh.lazySingleton<_i81.ClickOnCampaignBannerUsecase>(() => _i81.ClickOnCampaignBannerUsecase(get<_i53.MarketingCampaignRepositories>()));
  gh.lazySingleton<_i82.ClickOnCampaignPopupUsecase>(() => _i82.ClickOnCampaignPopupUsecase(get<_i53.MarketingCampaignRepositories>()));
  gh.lazySingleton<_i83.CompleteTutorialUsecase>(() => _i83.CompleteTutorialUsecase(
        get<_i67.UserRepository>(),
        get<_i80.ClearUserCacheUsecase>(),
      ));
  gh.lazySingleton<_i84.CountUnreadNotificationsUsecase>(() => _i84.CountUnreadNotificationsUsecase(get<_i55.NotificationRepository>()));
  gh.lazySingleton<_i85.CreatePaymentMomoUsecase>(() => _i85.CreatePaymentMomoUsecase(get<_i57.PaymentRepository>()));
  gh.lazySingleton<_i86.CreatePaymentVnPayUsecase>(() => _i86.CreatePaymentVnPayUsecase(get<_i57.PaymentRepository>()));
  gh.lazySingleton<_i87.DeactivatePayrollAccountUsecase>(() => _i87.DeactivatePayrollAccountUsecase(get<_i49.HrmPayrollRepository>()));
  gh.lazySingleton<_i88.DeleteAccountUsecase>(() => _i88.DeleteAccountUsecase(
        get<_i67.UserRepository>(),
        get<_i80.ClearUserCacheUsecase>(),
        get<_i12.FlutterLocalNotificationsPlugin>(),
      ));
  gh.lazySingleton<_i89.DeliveryAuthorizationDatasource>(() => _i89.DeliveryAuthorizationDatasourceImpl(get<_i46.DeliveryAuthorizationService>()));
  gh.lazySingleton<_i90.DeliveryAuthorizationRepositories>(() => _i90.DeliveryAuthorizationRepositories(get<_i89.DeliveryAuthorizationDatasource>()));
  gh.lazySingleton<_i91.DeliveryRemoteDatasource>(() => _i91.DeliveryRemoteDatasourceImpl(get<_i47.DeliveryService>()));
  gh.lazySingleton<_i92.DeliveryRepository>(() => _i92.DeliveryRepository(get<_i91.DeliveryRemoteDatasource>()));
  gh.lazySingleton<_i93.DonateForCharityUsecase>(() => _i93.DonateForCharityUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i94.FindUserPublicInfoUsecase>(() => _i94.FindUserPublicInfoUsecase(get<_i67.UserRepository>()));
  gh.lazySingleton<_i95.GetActiveSystemMaintenanceUsecase>(() => _i95.GetActiveSystemMaintenanceUsecase(get<_i64.SystemMaintenanceRepository>()));
  gh.lazySingleton<_i96.GetAvailableCharityCampaignsUsecase>(() => _i96.GetAvailableCharityCampaignsUsecase(get<_i76.CharityRepository>()));
  gh.lazySingleton<_i97.GetBalanceLogsUsecase>(() => _i97.GetBalanceLogsUsecase(get<_i67.UserRepository>()));
  gh.lazySingleton<_i98.GetBankTransferMessageUsecase>(() => _i98.GetBankTransferMessageUsecase(get<_i57.PaymentRepository>()));
  gh.lazySingleton<_i99.GetCabinetCitiesUsecase>(() => _i99.GetCabinetCitiesUsecase(get<_i74.CabinetRepository>()));
  gh.lazySingleton<_i100.GetCabinetDistrictsUsecase>(() => _i100.GetCabinetDistrictsUsecase(get<_i74.CabinetRepository>()));
  gh.lazySingleton<_i101.GetCabinetInfoUsecase>(() => _i101.GetCabinetInfoUsecase(get<_i74.CabinetRepository>()));
  gh.lazySingleton<_i102.GetCabinetUsecase>(() => _i102.GetCabinetUsecase(get<_i74.CabinetRepository>()));
  gh.lazySingleton<_i103.GetCabinetsNearbyUsecase>(() => _i103.GetCabinetsNearbyUsecase(get<_i74.CabinetRepository>()));
  gh.lazySingleton<_i104.GetCabinetsUsecase>(() => _i104.GetCabinetsUsecase(get<_i74.CabinetRepository>()));
  gh.lazySingleton<_i105.GetCharitiesUsecase>(() => _i105.GetCharitiesUsecase(get<_i76.CharityRepository>()));
  gh.lazySingleton<_i106.GetCharityByIdUsecase>(() => _i106.GetCharityByIdUsecase(get<_i76.CharityRepository>()));
  gh.lazySingleton<_i107.GetCharityCampaignDetailUsecase>(() => _i107.GetCharityCampaignDetailUsecase(get<_i76.CharityRepository>()));
  gh.lazySingleton<_i108.GetCharityCampaignImagesUsecase>(() => _i108.GetCharityCampaignImagesUsecase(get<_i76.CharityRepository>()));
  gh.lazySingleton<_i109.GetCharityCampaignsUsecase>(() => _i109.GetCharityCampaignsUsecase(get<_i76.CharityRepository>()));
  gh.lazySingleton<_i110.GetCharityDeliveriesUsecase>(() => _i110.GetCharityDeliveriesUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i111.GetCharityDeliveriesUsecase>(() => _i111.GetCharityDeliveriesUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i112.GetCharityDeliveryUsecase>(() => _i112.GetCharityDeliveryUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i113.GetCharityDonationsUsecase>(() => _i113.GetCharityDonationsUsecase(get<_i76.CharityRepository>()));
  gh.lazySingleton<_i114.GetCharityDonorsUsecase>(() => _i114.GetCharityDonorsUsecase(get<_i76.CharityRepository>()));
  gh.lazySingleton<_i115.GetCharityVolunteersUsecase>(() => _i115.GetCharityVolunteersUsecase(get<_i76.CharityRepository>()));
  gh.lazySingleton<_i116.GetCountriesUsecase>(() => _i116.GetCountriesUsecase(get<_i72.AuthRepository>()));
  gh.lazySingleton<_i117.GetDeliveriesUsecase>(() => _i117.GetDeliveriesUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i118.GetDeliveryAuthorizationUsecase>(() => _i118.GetDeliveryAuthorizationUsecase(get<_i90.DeliveryAuthorizationRepositories>()));
  gh.lazySingleton<_i119.GetDeliveryAuthorizationsUsecase>(
      () => _i119.GetDeliveryAuthorizationsUsecase(get<_i90.DeliveryAuthorizationRepositories>()));
  gh.lazySingleton<_i120.GetDeliveryReopenRequestUsecase>(() => _i120.GetDeliveryReopenRequestUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i121.GetDeliveryUsecase>(() => _i121.GetDeliveryUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i122.GetEstimateFinalReceivingPriceUsecase>(() => _i122.GetEstimateFinalReceivingPriceUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i123.GetInstructionByIdUsecase>(() => _i123.GetInstructionByIdUsecase(get<_i51.InstructionRepository>()));
  gh.lazySingleton<_i124.GetInstructionImagesUsecase>(() => _i124.GetInstructionImagesUsecase(get<_i51.InstructionRepository>()));
  gh.lazySingleton<_i125.GetInstructionsUsecase>(() => _i125.GetInstructionsUsecase(get<_i51.InstructionRepository>()));
  gh.lazySingleton<_i126.GetListCabinetInfoUsecase>(() => _i126.GetListCabinetInfoUsecase(get<_i74.CabinetRepository>()));
  gh.lazySingleton<_i127.GetListCabinetInfoWithAuthorizationsUsecase>(
      () => _i127.GetListCabinetInfoWithAuthorizationsUsecase(get<_i74.CabinetRepository>()));
  gh.lazySingleton<_i128.GetNotificationsUsecase>(() => _i128.GetNotificationsUsecase(get<_i55.NotificationRepository>()));
  gh.lazySingleton<_i129.GetPaymentOrderUsecase>(() => _i129.GetPaymentOrderUsecase(get<_i57.PaymentRepository>()));
  gh.lazySingleton<_i130.GetPaymentProductsUsecase>(() => _i130.GetPaymentProductsUsecase(get<_i57.PaymentRepository>()));
  gh.lazySingleton<_i131.GetPayrollAmountUsecase>(() => _i131.GetPayrollAmountUsecase(get<_i49.HrmPayrollRepository>()));
  gh.lazySingleton<_i132.GetPayrollLogsUsecase>(() => _i132.GetPayrollLogsUsecase(get<_i49.HrmPayrollRepository>()));
  gh.lazySingleton<_i133.GetPocketSizesUsecase>(() => _i133.GetPocketSizesUsecase(get<_i74.CabinetRepository>()));
  gh.lazySingleton<_i134.GetProfileUsecase>(() => _i134.GetProfileUsecase(get<_i67.UserRepository>()));
  gh.lazySingleton<_i135.GetReceivableDeliveriesUsecase>(() => _i135.GetReceivableDeliveriesUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i136.GetReceivableDeliveryAuthorizationsUsecase>(
      () => _i136.GetReceivableDeliveryAuthorizationsUsecase(get<_i90.DeliveryAuthorizationRepositories>()));
  gh.lazySingleton<_i137.GetRecentReceiversUsecase>(() => _i137.GetRecentReceiversUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i138.GetRunningMarketingCampaignsUsecase>(
      () => _i138.GetRunningMarketingCampaignsUsecase(get<_i53.MarketingCampaignRepositories>()));
  gh.lazySingleton<_i139.GetRunningReferralCampaignUsecase>(() => _i139.GetRunningReferralCampaignUsecase(get<_i60.ReferralCampaignRepositories>()));
  gh.lazySingleton<_i140.GetRunningSystemMaintenanceUsecase>(() => _i140.GetRunningSystemMaintenanceUsecase(get<_i64.SystemMaintenanceRepository>()));
  gh.lazySingleton<_i141.GetSettingUsecase>(() => _i141.GetSettingUsecase(get<_i62.SettingRepository>()));
  gh.lazySingleton<_i142.GetSettingsUsecase>(() => _i142.GetSettingsUsecase(get<_i62.SettingRepository>()));
  gh.lazySingleton<_i143.GetSystemNotificationsUsecase>(() => _i143.GetSystemNotificationsUsecase(get<_i55.NotificationRepository>()));
  gh.lazySingleton<_i144.GetTotalSystemNotificationsUsecase>(() => _i144.GetTotalSystemNotificationsUsecase(get<_i55.NotificationRepository>()));
  gh.lazySingleton<_i145.GetUserConeLogsUsecase>(() => _i145.GetUserConeLogsUsecase(get<_i67.UserRepository>()));
  gh.lazySingleton<_i146.GetVersionStatusUsecase>(() => _i146.GetVersionStatusUsecase(get<_i141.GetSettingUsecase>()));
  gh.lazySingleton<_i147.HandleFcmUserEventsUsecase>(() => _i147.HandleFcmUserEventsUsecase(
        get<_i67.UserRepository>(),
        get<_i7.EventBus>(),
      ));
  gh.factory<_i148.HrmPayrollDetailPageViewmodel>(() => _i148.HrmPayrollDetailPageViewmodel(
        get<_i87.DeactivatePayrollAccountUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i131.GetPayrollAmountUsecase>(),
        get<_i132.GetPayrollLogsUsecase>(),
        get<_i134.GetProfileUsecase>(),
      ));
  gh.factory<_i149.HrmPayrollInfoPageViewmodel>(() => _i149.HrmPayrollInfoPageViewmodel(get<_i141.GetSettingUsecase>()));
  gh.factory<_i150.HrmPayrollTransactionConfirmationPageViewmodel>(() => _i150.HrmPayrollTransactionConfirmationPageViewmodel(
        get<_i141.GetSettingUsecase>(),
        get<_i131.GetPayrollAmountUsecase>(),
        get<_i65.TopupPayrollUsecase>(),
      ));
  gh.factory<_i151.InstructionDetailPageViewModel>(() => _i151.InstructionDetailPageViewModel(get<_i124.GetInstructionImagesUsecase>()));
  gh.factory<_i152.InstructionPageViewModel>(() => _i152.InstructionPageViewModel(get<_i125.GetInstructionsUsecase>()));
  gh.lazySingleton<_i153.LogoutUsecase>(() => _i153.LogoutUsecase(
        get<_i67.UserRepository>(),
        get<_i38.UnregisterFcmTokenUsecase>(),
        get<_i12.FlutterLocalNotificationsPlugin>(),
        get<_i80.ClearUserCacheUsecase>(),
      ));
  gh.lazySingleton<_i154.MarkAllNotificationsAsReadUsecase>(() => _i154.MarkAllNotificationsAsReadUsecase(get<_i55.NotificationRepository>()));
  gh.factory<_i155.MarketingCampaignsPageViewModel>(() => _i155.MarketingCampaignsPageViewModel(
        get<_i138.GetRunningMarketingCampaignsUsecase>(),
        get<_i82.ClickOnCampaignPopupUsecase>(),
        get<_i81.ClickOnCampaignBannerUsecase>(),
        get<_i7.EventBus>(),
      ));
  gh.factory<_i156.NotificationPageViewModel>(() => _i156.NotificationPageViewModel(
        get<_i84.CountUnreadNotificationsUsecase>(),
        get<_i144.GetTotalSystemNotificationsUsecase>(),
        get<_i128.GetNotificationsUsecase>(),
        get<_i143.GetSystemNotificationsUsecase>(),
        get<_i154.MarkAllNotificationsAsReadUsecase>(),
        get<_i58.ReadNotificationUsecase>(),
        get<_i134.GetProfileUsecase>(),
        get<_i121.GetDeliveryUsecase>(),
        get<_i118.GetDeliveryAuthorizationUsecase>(),
      ));
  gh.lazySingleton<_i157.NotifyDeliveryAuthorizationReceiverUsecase>(
      () => _i157.NotifyDeliveryAuthorizationReceiverUsecase(get<_i90.DeliveryAuthorizationRepositories>()));
  gh.factory<_i158.PaymentPageViewModel>(() => _i158.PaymentPageViewModel(
        get<_i85.CreatePaymentMomoUsecase>(),
        get<_i86.CreatePaymentVnPayUsecase>(),
        get<_i130.GetPaymentProductsUsecase>(),
        get<_i129.GetPaymentOrderUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i134.GetProfileUsecase>(),
        get<_i98.GetBankTransferMessageUsecase>(),
        get<_i7.EventBus>(),
        get<_i78.CheckPayrollStatusUsecase>(),
      ));
  gh.factory<_i159.PhoneNumberPickerPageViewModel>(() => _i159.PhoneNumberPickerPageViewModel(
        get<_i14.GetPeopleUsecase>(),
        get<_i137.GetRecentReceiversUsecase>(),
      ));
  gh.factory<_i160.ReceiveDeliveryAuthorizationStatePageViewModel>(() => _i160.ReceiveDeliveryAuthorizationStatePageViewModel(
        get<_i118.GetDeliveryAuthorizationUsecase>(),
        get<_i7.EventBus>(),
      ));
  gh.factory<_i161.ReceiveDeliveryAuthorizationSuccessPageViewModel>(() => _i161.ReceiveDeliveryAuthorizationSuccessPageViewModel(
        get<_i135.GetReceivableDeliveriesUsecase>(),
        get<_i136.GetReceivableDeliveryAuthorizationsUsecase>(),
        get<_i118.GetDeliveryAuthorizationUsecase>(),
      ));
  gh.lazySingleton<_i162.ReceiveDeliveryAuthorizationUsecase>(
      () => _i162.ReceiveDeliveryAuthorizationUsecase(get<_i90.DeliveryAuthorizationRepositories>()));
  gh.factory<_i163.ReceiveDeliveryAuthorizationsPageViewModel>(() => _i163.ReceiveDeliveryAuthorizationsPageViewModel(
        get<_i162.ReceiveDeliveryAuthorizationUsecase>(),
        get<_i157.NotifyDeliveryAuthorizationReceiverUsecase>(),
      ));
  gh.lazySingleton<_i164.ReceiveDeliveryUsecase>(() => _i164.ReceiveDeliveryUsecase(get<_i92.DeliveryRepository>()));
  gh.factory<_i165.ReceiveOwnerPackagesPageViewModel>(() => _i165.ReceiveOwnerPackagesPageViewModel(
        get<_i164.ReceiveDeliveryUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i122.GetEstimateFinalReceivingPriceUsecase>(),
      ));
  gh.factory<_i166.ReceivePackagesPageViewModel>(() => _i166.ReceivePackagesPageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i136.GetReceivableDeliveryAuthorizationsUsecase>(),
        get<_i135.GetReceivableDeliveriesUsecase>(),
        get<_i126.GetListCabinetInfoUsecase>(),
        get<_i127.GetListCabinetInfoWithAuthorizationsUsecase>(),
        get<_i70.AgreeTosUsecase>(),
      ));
  gh.factory<_i167.ReceivePocketStateCompletePageViewModel>(() => _i167.ReceivePocketStateCompletePageViewModel(
        get<_i135.GetReceivableDeliveriesUsecase>(),
        get<_i136.GetReceivableDeliveryAuthorizationsUsecase>(),
      ));
  gh.factory<_i168.ReceivePocketStatePageViewModel>(() => _i168.ReceivePocketStatePageViewModel(
        get<_i121.GetDeliveryUsecase>(),
        get<_i7.EventBus>(),
      ));
  gh.factory<_i169.ReferralInsertCodePageViewModel>(() => _i169.ReferralInsertCodePageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i68.VerifyReferralCodeUsecase>(),
      ));
  gh.lazySingleton<_i170.RefreshTokenUsecase>(() => _i170.RefreshTokenUsecase(get<_i72.AuthRepository>()));
  gh.lazySingleton<_i171.RentPocketUsecase>(() => _i171.RentPocketUsecase(get<_i92.DeliveryRepository>()));
  gh.factory<_i172.ReopenPocketStatePageViewModel>(() => _i172.ReopenPocketStatePageViewModel(
        get<_i120.GetDeliveryReopenRequestUsecase>(),
        get<_i7.EventBus>(),
      ));
  gh.lazySingleton<_i173.ReopenPocketUsecase>(() => _i173.ReopenPocketUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i174.SelfRentPocketUsecase>(() => _i174.SelfRentPocketUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i175.SendDeliveryUsecase>(() => _i175.SendDeliveryUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i176.SendOtpUsecase>(() => _i176.SendOtpUsecase(get<_i72.AuthRepository>()));
  gh.factory<_i177.SplashPageViewModel>(() => _i177.SplashPageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i146.GetVersionStatusUsecase>(),
        get<_i80.ClearUserCacheUsecase>(),
        get<_i7.EventBus>(),
        get<_i140.GetRunningSystemMaintenanceUsecase>(),
      ));
  gh.factory<_i178.StaticHomePageViewModel>(() => _i178.StaticHomePageViewModel(get<_i83.CompleteTutorialUsecase>()));
  gh.factory<_i179.SystemMaintenancePageViewModel>(() => _i179.SystemMaintenancePageViewModel(get<_i140.GetRunningSystemMaintenanceUsecase>()));
  gh.factory<_i180.TransactionHistoryPageViewModel>(() => _i180.TransactionHistoryPageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i97.GetBalanceLogsUsecase>(),
        get<_i145.GetUserConeLogsUsecase>(),
      ));
  gh.lazySingleton<_i181.UpdateDeviceInfoUsecase>(() => _i181.UpdateDeviceInfoUsecase(get<_i67.UserRepository>()));
  gh.lazySingleton<_i182.UpdateProfileUsecase>(() => _i182.UpdateProfileUsecase(
        get<_i67.UserRepository>(),
        get<_i7.EventBus>(),
        get<_i80.ClearUserCacheUsecase>(),
      ));
  gh.factory<_i183.UserInfoPageViewModel>(() => _i183.UserInfoPageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i182.UpdateProfileUsecase>(),
      ));
  gh.factory<_i184.VolunteersPageViewModel>(() => _i184.VolunteersPageViewModel(get<_i115.GetCharityVolunteersUsecase>()));
  gh.factory<_i185.WizardProfilePageViewModel>(() => _i185.WizardProfilePageViewModel(
        get<_i182.UpdateProfileUsecase>(),
        get<_i79.CheckReferralCodeUsecase>(),
        get<_i134.GetProfileUsecase>(),
        get<_i139.GetRunningReferralCampaignUsecase>(),
      ));
  gh.factory<_i186.CabinetDetailPageViewModel>(() => _i186.CabinetDetailPageViewModel(
        get<_i102.GetCabinetUsecase>(),
        get<_i133.GetPocketSizesUsecase>(),
      ));
  gh.factory<_i187.CabinetListPageViewModel>(() => _i187.CabinetListPageViewModel(get<_i104.GetCabinetsUsecase>()));
  gh.factory<_i188.CabinetMaintenancePageViewModel>(() => _i188.CabinetMaintenancePageViewModel(get<_i141.GetSettingUsecase>()));
  gh.lazySingleton<_i189.CancelDeliveryAuthorizationUsecase>(
      () => _i189.CancelDeliveryAuthorizationUsecase(get<_i90.DeliveryAuthorizationRepositories>()));
  gh.factory<_i190.CancelDeliveryStatePageViewModel>(() => _i190.CancelDeliveryStatePageViewModel(
        get<_i121.GetDeliveryUsecase>(),
        get<_i7.EventBus>(),
      ));
  gh.lazySingleton<_i191.CancelDeliveryUsecase>(() => _i191.CancelDeliveryUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i192.CancelSentDeliveryUsecase>(() => _i192.CancelSentDeliveryUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i193.ChangePocketSizeUsecase>(() => _i193.ChangePocketSizeUsecase(get<_i92.DeliveryRepository>()));
  gh.factory<_i194.CharityCampaignDetailPageViewModel>(() => _i194.CharityCampaignDetailPageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i107.GetCharityCampaignDetailUsecase>(),
        get<_i113.GetCharityDonationsUsecase>(),
        get<_i108.GetCharityCampaignImagesUsecase>(),
        get<_i101.GetCabinetInfoUsecase>(),
        get<_i106.GetCharityByIdUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i77.CheckIfDonatableUsecase>(),
      ));
  gh.factory<_i195.CharityCampaignsPageViewModel>(() => _i195.CharityCampaignsPageViewModel(
        get<_i109.GetCharityCampaignsUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i134.GetProfileUsecase>(),
      ));
  gh.factory<_i196.CharityDeliveryHistoryPageViewModel>(() => _i196.CharityDeliveryHistoryPageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i111.GetCharityDeliveriesUsecase>(),
      ));
  gh.factory<_i197.CharityDonorsPageViewModel>(() => _i197.CharityDonorsPageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i113.GetCharityDonationsUsecase>(),
        get<_i141.GetSettingUsecase>(),
      ));
  gh.factory<_i198.CharityOrganizationDetailPageViewModel>(() => _i198.CharityOrganizationDetailPageViewModel(
        get<_i96.GetAvailableCharityCampaignsUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i106.GetCharityByIdUsecase>(),
        get<_i134.GetProfileUsecase>(),
      ));
  gh.factory<_i199.CharityPageViewModel>(() => _i199.CharityPageViewModel(
        get<_i141.GetSettingUsecase>(),
        get<_i134.GetProfileUsecase>(),
      ));
  gh.factory<_i200.CharityPhoneNumberPickerPageViewModel>(() => _i200.CharityPhoneNumberPickerPageViewModel(
        get<_i14.GetPeopleUsecase>(),
        get<_i137.GetRecentReceiversUsecase>(),
      ));
  gh.factory<_i201.CharityScanPageViewModel>(() => _i201.CharityScanPageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i105.GetCharitiesUsecase>(),
        get<_i101.GetCabinetInfoUsecase>(),
      ));
  gh.factory<_i202.CharitySendPackageInfoPageViewModel>(() => _i202.CharitySendPackageInfoPageViewModel(
        get<_i133.GetPocketSizesUsecase>(),
        get<_i134.GetProfileUsecase>(),
        get<_i70.AgreeTosUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i106.GetCharityByIdUsecase>(),
        get<_i93.DonateForCharityUsecase>(),
      ));
  gh.factory<_i203.CharitySendPocketStatePageViewModel>(() => _i203.CharitySendPocketStatePageViewModel(
        get<_i121.GetDeliveryUsecase>(),
        get<_i191.CancelDeliveryUsecase>(),
        get<_i133.GetPocketSizesUsecase>(),
        get<_i193.ChangePocketSizeUsecase>(),
        get<_i7.EventBus>(),
      ));
  gh.lazySingleton<_i204.CheckAndRequestNotificationPermissionUsecase>(
      () => _i204.CheckAndRequestNotificationPermissionUsecase(get<_i141.GetSettingUsecase>()));
  gh.lazySingleton<_i205.CheckDeliveryReopenableUsecase>(() => _i205.CheckDeliveryReopenableUsecase(get<_i92.DeliveryRepository>()));
  gh.lazySingleton<_i206.CreateDeliveryAuthorizationUsecase>(
      () => _i206.CreateDeliveryAuthorizationUsecase(get<_i90.DeliveryAuthorizationRepositories>()));
  gh.lazySingleton<_i207.CreateDeliveryUsecase>(() => _i207.CreateDeliveryUsecase(get<_i92.DeliveryRepository>()));
  gh.factory<_i208.DeleteAccountPageViewModel>(() => _i208.DeleteAccountPageViewModel(get<_i88.DeleteAccountUsecase>()));
  gh.factory<_i209.DeliveryAuthorizationDetailPageViewModel>(() => _i209.DeliveryAuthorizationDetailPageViewModel(
        get<_i118.GetDeliveryAuthorizationUsecase>(),
        get<_i101.GetCabinetInfoUsecase>(),
        get<_i136.GetReceivableDeliveryAuthorizationsUsecase>(),
        get<_i122.GetEstimateFinalReceivingPriceUsecase>(),
        get<_i90.DeliveryAuthorizationRepositories>(),
        get<_i141.GetSettingUsecase>(),
        get<_i134.GetProfileUsecase>(),
        get<_i157.NotifyDeliveryAuthorizationReceiverUsecase>(),
      ));
  gh.factory<_i210.DeliveryDetailPageViewModel>(() => _i210.DeliveryDetailPageViewModel(
        get<_i121.GetDeliveryUsecase>(),
        get<_i112.GetCharityDeliveryUsecase>(),
        get<_i134.GetProfileUsecase>(),
        get<_i164.ReceiveDeliveryUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i101.GetCabinetInfoUsecase>(),
        get<_i135.GetReceivableDeliveriesUsecase>(),
        get<_i122.GetEstimateFinalReceivingPriceUsecase>(),
        get<_i189.CancelDeliveryAuthorizationUsecase>(),
        get<_i192.CancelSentDeliveryUsecase>(),
        get<_i205.CheckDeliveryReopenableUsecase>(),
        get<_i173.ReopenPocketUsecase>(),
        get<_i7.EventBus>(),
      ));
  gh.factory<_i211.DeliveryFailedPageViewModel>(() => _i211.DeliveryFailedPageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i173.ReopenPocketUsecase>(),
        get<_i205.CheckDeliveryReopenableUsecase>(),
        get<_i121.GetDeliveryUsecase>(),
      ));
  gh.factory<_i212.DeliveryHistoryPageViewModel>(() => _i212.DeliveryHistoryPageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i117.GetDeliveriesUsecase>(),
      ));
  gh.factory<_i213.EnterPhonePageViewModel>(() => _i213.EnterPhonePageViewModel(
        get<_i176.SendOtpUsecase>(),
        get<_i116.GetCountriesUsecase>(),
        get<_i134.GetProfileUsecase>(),
        get<_i29.RegisterFcmTokenUsecase>(),
        get<_i182.UpdateProfileUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i70.AgreeTosUsecase>(),
      ));
  gh.factory<_i214.FilterCabinetsViewModel>(() => _i214.FilterCabinetsViewModel(get<_i104.GetCabinetsUsecase>()));
  gh.factory<_i215.FilterCitiesPageViewModel>(() => _i215.FilterCitiesPageViewModel(get<_i99.GetCabinetCitiesUsecase>()));
  gh.factory<_i216.FilterDistrictsPageViewModel>(() => _i216.FilterDistrictsPageViewModel(get<_i100.GetCabinetDistrictsUsecase>()));
  gh.factory<_i217.HomePageViewModel>(() => _i217.HomePageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i117.GetDeliveriesUsecase>(),
        get<_i135.GetReceivableDeliveriesUsecase>(),
        get<_i84.CountUnreadNotificationsUsecase>(),
        get<_i144.GetTotalSystemNotificationsUsecase>(),
        get<_i101.GetCabinetInfoUsecase>(),
        get<_i146.GetVersionStatusUsecase>(),
        get<_i80.ClearUserCacheUsecase>(),
        get<_i136.GetReceivableDeliveryAuthorizationsUsecase>(),
        get<_i181.UpdateDeviceInfoUsecase>(),
        get<_i29.RegisterFcmTokenUsecase>(),
        get<_i141.GetSettingUsecase>(),
      ));
  gh.factory<_i218.HrmPayrollRegisterPageViewmodel>(() => _i218.HrmPayrollRegisterPageViewmodel(
        get<_i141.GetSettingUsecase>(),
        get<_i176.SendOtpUsecase>(),
        get<_i69.ActivatePayrollAccountUsecase>(),
      ));
  gh.factory<_i219.MainPageViewModel>(() => _i219.MainPageViewModel(
        get<_i101.GetCabinetInfoUsecase>(),
        get<_i134.GetProfileUsecase>(),
        get<_i204.CheckAndRequestNotificationPermissionUsecase>(),
      ));
  gh.factory<_i220.ProfilePageViewModel>(() => _i220.ProfilePageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i182.UpdateProfileUsecase>(),
        get<_i153.LogoutUsecase>(),
        get<_i79.CheckReferralCodeUsecase>(),
        get<_i139.GetRunningReferralCampaignUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i78.CheckPayrollStatusUsecase>(),
      ));
  gh.factory<_i221.SelfRentPocketInfoPageViewModel>(() => _i221.SelfRentPocketInfoPageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i133.GetPocketSizesUsecase>(),
        get<_i174.SelfRentPocketUsecase>(),
      ));
  gh.factory<_i222.SelfRentPocketStatePageViewModel>(() => _i222.SelfRentPocketStatePageViewModel(
        get<_i121.GetDeliveryUsecase>(),
        get<_i191.CancelDeliveryUsecase>(),
        get<_i133.GetPocketSizesUsecase>(),
        get<_i193.ChangePocketSizeUsecase>(),
        get<_i7.EventBus>(),
      ));
  gh.factory<_i223.SendPackageInfoPageViewModel>(() => _i223.SendPackageInfoPageViewModel(
        get<_i133.GetPocketSizesUsecase>(),
        get<_i207.CreateDeliveryUsecase>(),
        get<_i94.FindUserPublicInfoUsecase>(),
        get<_i134.GetProfileUsecase>(),
        get<_i70.AgreeTosUsecase>(),
        get<_i141.GetSettingUsecase>(),
      ));
  gh.factory<_i224.SendPocketStatePageViewModel>(() => _i224.SendPocketStatePageViewModel(
        get<_i121.GetDeliveryUsecase>(),
        get<_i191.CancelDeliveryUsecase>(),
        get<_i133.GetPocketSizesUsecase>(),
        get<_i193.ChangePocketSizeUsecase>(),
        get<_i7.EventBus>(),
      ));
  gh.factory<_i225.AuthorizeDeliveryViewModel>(() => _i225.AuthorizeDeliveryViewModel(
        get<_i94.FindUserPublicInfoUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i206.CreateDeliveryAuthorizationUsecase>(),
      ));
  gh.factory<_i226.CharityDeliveryFailedPageViewModel>(() => _i226.CharityDeliveryFailedPageViewModel(
        get<_i134.GetProfileUsecase>(),
        get<_i141.GetSettingUsecase>(),
        get<_i173.ReopenPocketUsecase>(),
        get<_i205.CheckDeliveryReopenableUsecase>(),
        get<_i121.GetDeliveryUsecase>(),
      ));
  return get;
}

class _$Locator extends _i227.Locator {}
