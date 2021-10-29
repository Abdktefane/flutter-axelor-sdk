part of '../flutter_axelor_sdk.dart';

extension AxelorStringCriteriaExt on String {
  AxelorCriteria like(String value) => AxelorCriteria(
        axelorOperator: AxelorOperator.like,
        fieldName: this,
        value: value,
      );
  AxelorCriteria notLike(String value) => AxelorCriteria(
        axelorOperator: AxelorOperator.notLike,
        fieldName: this,
        value: value,
      );

  AxelorCriteria between(String value, String value2) => AxelorCriteria(
        axelorOperator: AxelorOperator.between,
        fieldName: this,
        value: value,
        value2: value2,
      );
  AxelorCriteria notBetween(String value, String value2) => AxelorCriteria(
        axelorOperator: AxelorOperator.notBetween,
        fieldName: this,
        value: value,
        value2: value2,
      );

  AxelorCriteria get isNull => AxelorCriteria(axelorOperator: AxelorOperator.isNull, fieldName: this);
  AxelorCriteria get isNotNull => AxelorCriteria(axelorOperator: AxelorOperator.notNull, fieldName: this);

  AxelorCriteria equal(String value) => AxelorCriteria(
        axelorOperator: AxelorOperator.equal,
        fieldName: this,
        value: value,
      );
  AxelorCriteria notEaual(String value) => AxelorCriteria(
        axelorOperator: AxelorOperator.notEqual,
        fieldName: this,
        value: value,
      );

  AxelorCriteria greaterThan(String value) => AxelorCriteria(
        axelorOperator: AxelorOperator.greaterThan,
        fieldName: this,
        value: value,
      );

  AxelorCriteria lessThan(String value) => AxelorCriteria(
        axelorOperator: AxelorOperator.lessThan,
        fieldName: this,
        value: value,
      );

  AxelorCriteria greaterOrEqualTo(String value) => AxelorCriteria(
        axelorOperator: AxelorOperator.greaterOrEqualTo,
        fieldName: this,
        value: value,
      );

  AxelorCriteria lessOrEqualTo(String value) => AxelorCriteria(
        axelorOperator: AxelorOperator.lessOrEqualTo,
        fieldName: this,
        value: value,
      );
}
