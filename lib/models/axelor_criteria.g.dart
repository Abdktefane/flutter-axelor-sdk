// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'axelor_criteria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AxelorCriteria _$AxelorCriteriaFromJson(Map<String, dynamic> json) {
  return AxelorCriteria(
    axelorOperator: _$enumDecode(_$AxelorOperatorEnumMap, json['operator']),
    fieldName: json['fieldName'] as String?,
    criteria: (json['criteria'] as List<dynamic>?)
        ?.map((e) => AxelorCriteria.fromJson(e as Map<String, dynamic>))
        .toList(),
    value: json['value'],
    value2: json['value2'] as String?,
  );
}

Map<String, dynamic> _$AxelorCriteriaToJson(AxelorCriteria instance) {
  final val = <String, dynamic>{
    'operator': AxelorOperatorExt.asJson(instance.axelorOperator),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('fieldName', instance.fieldName);
  writeNotNull('criteria', instance.criteria?.map((e) => e.toJson()).toList());
  writeNotNull('value', _valueConverter(instance.value));
  writeNotNull('value2', instance.value2);
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$AxelorOperatorEnumMap = {
  AxelorOperator.and: 'and',
  AxelorOperator.or: 'or',
  AxelorOperator.not: 'not',
  AxelorOperator.like: 'like',
  AxelorOperator.notLike: 'notLike',
  AxelorOperator.between: 'between',
  AxelorOperator.notBetween: 'notBetween',
  AxelorOperator.isNull: 'isNull',
  AxelorOperator.notNull: 'notNull',
  AxelorOperator.equal: 'equal',
  AxelorOperator.notEqual: 'notEqual',
  AxelorOperator.greaterThan: 'greaterThan',
  AxelorOperator.lessThan: 'lessThan',
  AxelorOperator.greaterOrEqualTo: 'greaterOrEqualTo',
  AxelorOperator.lessOrEqualTo: 'lessOrEqualTo',
  AxelorOperator.inValues: 'inValues',
};
