import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'axelor_model.dart';

part 'axelor_version_model.g.dart';

@JsonSerializable()
class AxelorVersionModel extends AxelorModel with EquatableMixin {
  AxelorVersionModel({int? id, int? version}) : super(id: id, version: version);

  static Map<String, dynamic> get body => {
        'fields': ['version']
      };

  AxelorVersionModel copyWith({int? id, int? version}) => AxelorVersionModel(
        version: version ?? this.version,
        id: id ?? this.id,
      );

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [version, id];

  static AxelorVersionModel fromJson(Object? json) => _$AxelorVersionModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AxelorVersionModelToJson(this);

  static List<String> get fields => ['version'];
}
