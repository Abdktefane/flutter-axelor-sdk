import 'package:equatable/equatable.dart';
import 'package:flutter_axelor_sdk/models/axelor_operators.dart';
import 'package:json_annotation/json_annotation.dart';

part 'axelor_criteria.g.dart';

dynamic _valueConverter(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is List) {
    return value;
  }
  return value.toString();
}

@JsonSerializable(explicitToJson: true)
class AxelorCriteria extends Equatable {
  const AxelorCriteria({
    required this.axelorOperator,
    this.fieldName,
    this.criteria,
    this.value,
    this.value2,
  });

  @JsonKey(name: 'operator', toJson: AxelorOperatorExt.asJson)
  final AxelorOperator axelorOperator;

  @JsonKey(includeIfNull: false)
  final String? fieldName;

  @JsonKey(includeIfNull: false)
  final List<AxelorCriteria>? criteria;

  @JsonKey(includeIfNull: false, toJson: _valueConverter)
  final dynamic value;

  @JsonKey(includeIfNull: false)
  final String? value2;

  AxelorCriteria copyWith({
    AxelorOperator? axelorOperator,
    String? fieldName,
    List<AxelorCriteria>? criteria,
    String? value,
    String? value2,
  }) {
    return AxelorCriteria(
      axelorOperator: axelorOperator ?? this.axelorOperator,
      fieldName: fieldName ?? this.fieldName,
      criteria: criteria ?? this.criteria,
      value: value ?? this.value,
      value2: value2 ?? this.value2,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      axelorOperator,
      fieldName,
      criteria,
      value,
      value2,
    ];
  }

  static AxelorCriteria and(List<AxelorCriteria> criterias) => AxelorCriteria(
        axelorOperator: AxelorOperator.and,
        criteria: criterias,
      );

  static AxelorCriteria or(List<AxelorCriteria> criterias) => AxelorCriteria(
        axelorOperator: AxelorOperator.or,
        criteria: criterias,
      );

  static AxelorCriteria not(List<AxelorCriteria> criterias) => AxelorCriteria(
        axelorOperator: AxelorOperator.not,
        criteria: criterias,
      );

  static AxelorCriteria fromJson(Map<String, dynamic> json) => _$AxelorCriteriaFromJson(json);
  Map<String, dynamic> toJson() => _$AxelorCriteriaToJson(this);
}
