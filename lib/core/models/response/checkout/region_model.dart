import 'package:equatable/equatable.dart';

/// One Egyptian governorate from `country.available_regions`.
///
/// [id] is the `region_id` Magento wants on an address; [code] is its stable
/// English handle; [name] is localised by store view and is what the dropdown
/// shows.
class RegionModel extends Equatable {
  final int id;
  final String code;
  final String name;

  const RegionModel({required this.id, this.code = '', this.name = ''});

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'code': code, 'name': name};

  /// The `available_regions` payload of [GraphQLDocuments.getCountryRegions].
  static List<RegionModel> listFrom(Map<String, dynamic> json) {
    return ((json['country'] as Map<String, dynamic>?)?['available_regions']
                as List<dynamic>? ??
            const [])
        .whereType<Map<String, dynamic>>()
        .map(RegionModel.fromJson)
        .where((RegionModel region) => region.id > 0)
        .toList();
  }

  /// Falls back to the code for the odd region with no translated name.
  String get displayName => name.trim().isNotEmpty ? name.trim() : code;

  @override
  List<Object?> get props => [id, code, name];
}
