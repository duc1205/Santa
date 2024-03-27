import 'package:json_annotation/json_annotation.dart';

enum UserBalanceChangingType {
  unknown,
  @JsonValue("new_user")
  newUser,
  @JsonValue("admin_adding")
  adminAdding,
  @JsonValue("topup")
  topUp,
  @JsonValue("delivery_receiving")
  deliveryReceiving,
  @JsonValue("delivery_sending")
  deliverySending,
  @JsonValue("delivery_refund")
  deliveryRefund,
  @JsonValue("delivery_rent")
  deliveryRent,
  @JsonValue("delivery_charge")
  deliveryCharge,
  @JsonValue("admin_transfer")
  adminTransfer,
}
