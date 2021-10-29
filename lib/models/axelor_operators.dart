import 'package:flutter/foundation.dart';

enum AxelorOperator {
  and,
  or,
  not,

  like,
  notLike,
  between,
  notBetween,
  isNull,
  notNull,

  equal,
  notEqual,
  greaterThan,
  lessThan,
  greaterOrEqualTo,
  lessOrEqualTo,
}

extension AxelorOperatorExt on AxelorOperator {
  bool get isGroup => this == AxelorOperator.and || this == AxelorOperator.or || this == AxelorOperator.not;
  String get row {
    if (this == AxelorOperator.equal) {
      return '=';
    }
    if (this == AxelorOperator.notEqual) {
      return '!=';
    }
    if (this == AxelorOperator.greaterThan) {
      return '>';
    }
    if (this == AxelorOperator.lessThan) {
      return '<';
    }
    if (this == AxelorOperator.greaterOrEqualTo) {
      return '>=';
    }
    if (this == AxelorOperator.lessOrEqualTo) {
      return '<=';
    }
    return describeEnum(this);
  }

  static String? asJson(AxelorOperator? op) => op?.row;
}
