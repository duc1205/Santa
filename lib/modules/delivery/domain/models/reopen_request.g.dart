// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reopen_request.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReopenRequestCWProxy {
  ReopenRequest id(int id);

  ReopenRequest deliveryId(int deliveryId);

  ReopenRequest delivery(Delivery? delivery);

  ReopenRequest status(DeliveryReopenRequestStatus status);

  ReopenRequest createdAt(DateTime createdAt);

  ReopenRequest updatedAt(DateTime updatedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReopenRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReopenRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  ReopenRequest call({
    int? id,
    int? deliveryId,
    Delivery? delivery,
    DeliveryReopenRequestStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReopenRequest.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReopenRequest.copyWith.fieldName(...)`
class _$ReopenRequestCWProxyImpl implements _$ReopenRequestCWProxy {
  const _$ReopenRequestCWProxyImpl(this._value);

  final ReopenRequest _value;

  @override
  ReopenRequest id(int id) => this(id: id);

  @override
  ReopenRequest deliveryId(int deliveryId) => this(deliveryId: deliveryId);

  @override
  ReopenRequest delivery(Delivery? delivery) => this(delivery: delivery);

  @override
  ReopenRequest status(DeliveryReopenRequestStatus status) => this(status: status);

  @override
  ReopenRequest createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  ReopenRequest updatedAt(DateTime updatedAt) => this(updatedAt: updatedAt);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReopenRequest(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReopenRequest(...).copyWith(id: 12, name: "My name")
  /// ````
  ReopenRequest call({
    Object? id = const $CopyWithPlaceholder(),
    Object? deliveryId = const $CopyWithPlaceholder(),
    Object? delivery = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? updatedAt = const $CopyWithPlaceholder(),
  }) {
    return ReopenRequest(
      id: id == const $CopyWithPlaceholder() || id == null
          // ignore: unnecessary_non_null_assertion
          ? _value.id!
          // ignore: cast_nullable_to_non_nullable
          : id as int,
      deliveryId: deliveryId == const $CopyWithPlaceholder() || deliveryId == null
          // ignore: unnecessary_non_null_assertion
          ? _value.deliveryId!
          // ignore: cast_nullable_to_non_nullable
          : deliveryId as int,
      delivery: delivery == const $CopyWithPlaceholder()
          ? _value.delivery
          // ignore: cast_nullable_to_non_nullable
          : delivery as Delivery?,
      status: status == const $CopyWithPlaceholder() || status == null
          // ignore: unnecessary_non_null_assertion
          ? _value.status!
          // ignore: cast_nullable_to_non_nullable
          : status as DeliveryReopenRequestStatus,
      createdAt: createdAt == const $CopyWithPlaceholder() || createdAt == null
          // ignore: unnecessary_non_null_assertion
          ? _value.createdAt!
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      updatedAt: updatedAt == const $CopyWithPlaceholder() || updatedAt == null
          // ignore: unnecessary_non_null_assertion
          ? _value.updatedAt!
          // ignore: cast_nullable_to_non_nullable
          : updatedAt as DateTime,
    );
  }
}

extension $ReopenRequestCopyWith on ReopenRequest {
  /// Returns a callable class that can be used as follows: `instanceOfReopenRequest.copyWith(...)` or like so:`instanceOfReopenRequest.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReopenRequestCWProxy get copyWith => _$ReopenRequestCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReopenRequest _$ReopenRequestFromJson(Map<String, dynamic> json) => ReopenRequest(
      id: json['id'] as int,
      deliveryId: json['delivery_id'] as int,
      delivery: json['delivery'] == null ? null : Delivery.fromJson(json['delivery'] as Map<String, dynamic>),
      status: $enumDecode(_$DeliveryReopenRequestStatusEnumMap, json['status'], unknownValue: DeliveryReopenRequestStatus.unknown),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ReopenRequestToJson(ReopenRequest instance) => <String, dynamic>{
      'id': instance.id,
      'delivery_id': instance.deliveryId,
      'status': _$DeliveryReopenRequestStatusEnumMap[instance.status]!,
      'delivery': instance.delivery?.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$DeliveryReopenRequestStatusEnumMap = {
  DeliveryReopenRequestStatus.unknown: 'unknown',
  DeliveryReopenRequestStatus.created: 'created',
  DeliveryReopenRequestStatus.opening: 'opening',
  DeliveryReopenRequestStatus.opened: 'opened',
  DeliveryReopenRequestStatus.completed: 'completed',
  DeliveryReopenRequestStatus.failed: 'failed',
};
