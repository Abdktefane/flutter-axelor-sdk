import 'package:equatable/equatable.dart';
import 'package:flutter_axelor_sdk/models/axelor_criteria.dart';
import 'package:flutter_axelor_sdk/models/axelor_operators.dart';

class AxelorBody extends Equatable {
  const AxelorBody({
    this.offset,
    this.limit,
    this.fields,
    this.translate,
    this.sortBy,
    this.action,
    this.related,
    this.data,
    this.domain,
    this.domainContext,
    this.archived,
    this.criteria,
    this.version,
    this.id,
  });

  final int? offset;
  final int? limit;
  final List<String>? fields;
  final bool? translate;
  final List<String>? sortBy;
  final String? action;
  final List<MapEntry<String, List<String>>>? related;
  final Map<String, dynamic>? data;
  final String? domain;
  final Map<String, dynamic>? domainContext;
  final bool? archived;
  final AxelorCriteria? criteria;
  final int? version;
  final int? id;

  Map<String, dynamic> toJson() {
    return {
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
      if (fields != null) 'fields': fields,
      if (translate != null) 'translate': translate,
      if (sortBy != null) 'sortBy': sortBy,
      if (action != null) 'action': action,
      if (related != null) 'related': Map.fromEntries(related!),
      'data': {
        if (version != null) 'version': version,
        if (id != null) 'id': id,
        if (data != null) ...?data,
        if (domain != null) '_domain': domain,
        if (domainContext != null) '_domainContext': domainContext,
        if (archived != null) '_archived': archived,
        if (criteria != null) ...parseCriteria(criteria!),
      }
    };
  }

  Map<String, dynamic> parseCriteria(AxelorCriteria criteria) {
    return {
      'operator': (criteria.axelorOperator.isGroup == true ? criteria.axelorOperator : AxelorOperator.and).row,
      'criteria': criteria.axelorOperator.isGroup == true
          ? criteria.criteria?.map((it) => it.toJson()).toList()
          : [criteria.toJson()],
    };
  }

  AxelorBody copyWith({
    int? offset,
    int? limit,
    List<String>? fields,
    bool? translate,
    List<String>? sortBy,
    String? action,
    List<MapEntry<String, List<String>>>? related,
    Map<String, dynamic>? data,
    String? domain,
    Map<String, dynamic>? domainContext,
    bool? archived,
    AxelorCriteria? criteria,
    int? version,
    int? id,
  }) {
    return AxelorBody(
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      fields: fields ?? this.fields,
      translate: translate ?? this.translate,
      sortBy: sortBy ?? this.sortBy,
      action: action ?? this.action,
      related: related ?? this.related,
      data: data ?? this.data,
      domain: domain ?? this.domain,
      domainContext: domainContext ?? this.domainContext,
      archived: archived ?? this.archived,
      criteria: criteria ?? this.criteria,
      version: version ?? this.version,
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      offset,
      limit,
      fields,
      translate,
      sortBy,
      action,
      related,
      data,
      domain,
      domainContext,
      archived,
      criteria,
      version,
      id,
    ];
  }
}
