import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_details.freezed.dart';
part 'cart_details.g.dart';

@freezed
class CartDetails with _$CartDetails {
  const factory CartDetails({
    @Default(0) int itemCount,
    @Default(0) double totalPrice,
  }) = _CartDetails;
  factory CartDetails.fromJson(Map<String, dynamic> json) =>
      _$CartDetailsFromJson(json);
}
