import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_axelor_sdk/models/axelor_model.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends AxelorModel with EquatableMixin {
  const UserModel({
    int? id,
    int? version,
    this.fullName,
    this.email,
  }) : super(id: id, version: version);

  final String? fullName;
  final String? email;

  static String modelName = 'User';
  static bool isBaseDomain = false;

  UserModel copyWith({
    String? fullName,
    String? email,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, version, fullName, email];

  static UserModel fromJson(Object? json) => _$UserModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
