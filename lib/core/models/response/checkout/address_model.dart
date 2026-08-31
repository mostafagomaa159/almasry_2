import 'package:equatable/equatable.dart';

class AddressModel extends Equatable {
  final String id;

  final String firstName;
  final String lastName;

  final String phone;
  final String countryCode;

  final String addressLine;

  final String buildingNumber;
  final String floor;
  final String apartment;

  final String mark;

  final String government;

  final int? regionId;

  final String regionCode;

  final double? latitude;
  final double? longitude;

  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.countryCode = defaultCountryDialCode,
    this.addressLine = '',
    this.buildingNumber = '',
    this.floor = '',
    this.apartment = '',
    this.mark = '',
    this.government = '',
    this.regionId,
    this.regionCode = '',
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  static const String defaultCountryDialCode = '+20';
  static const String countryIsoCode = 'EG';

  static const String defaultPostcode = '00000';

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      countryCode: json['country_code']?.toString() ?? defaultCountryDialCode,
      addressLine: json['address_line']?.toString() ?? '',
      buildingNumber: json['building_number']?.toString() ?? '',
      floor: json['floor']?.toString() ?? '',
      apartment: json['apartment']?.toString() ?? '',
      mark: json['mark']?.toString() ?? '',
      government: json['government']?.toString() ?? '',
      regionId: (json['region_id'] as num?)?.toInt(),
      regionCode: json['region_code']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isDefault: json['is_default'] as bool? ?? false,
    );
  }

  factory AddressModel.flagged(AddressModel source, {required bool isDefault}) {
    return AddressModel(
      id: source.id,
      firstName: source.firstName,
      lastName: source.lastName,
      phone: source.phone,
      countryCode: source.countryCode,
      addressLine: source.addressLine,
      buildingNumber: source.buildingNumber,
      floor: source.floor,
      apartment: source.apartment,
      mark: source.mark,
      government: source.government,
      regionId: source.regionId,
      regionCode: source.regionCode,
      latitude: source.latitude,
      longitude: source.longitude,
      isDefault: isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'country_code': countryCode,
      'address_line': addressLine,
      'building_number': buildingNumber,
      'floor': floor,
      'apartment': apartment,
      'mark': mark,
      'government': government,
      'region_id': regionId,
      'region_code': regionCode,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    };
  }

  String get fullPhone => '$countryCode$phone';

  String get cityLine {
    final String area = addressLine.split(',').last.trim();

    if (government.trim().isEmpty) return area;
    if (area.isEmpty || area == government.trim()) return government.trim();

    return '${government.trim()} / $area';
  }

  String get detailsLine {
    final List<String> parts = <String>[
      if (buildingNumber.trim().isNotEmpty) buildingNumber.trim(),
      if (floor.trim().isNotEmpty) floor.trim(),
      if (apartment.trim().isNotEmpty) apartment.trim(),
      if (mark.trim().isNotEmpty) mark.trim(),
    ];

    return parts.join(' - ');
  }

  String get summaryLine {
    final String details = detailsLine;

    if (details.isEmpty) return addressLine.trim();

    return '${addressLine.trim()} - $details';
  }

  List<String> get streetLines {
    final String details = detailsLine;

    return <String>[
      addressLine.trim().isEmpty ? government.trim() : addressLine.trim(),
      if (details.isNotEmpty) details,
    ];
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    phone,
    countryCode,
    addressLine,
    buildingNumber,
    floor,
    apartment,
    mark,
    government,
    regionId,
    regionCode,
    latitude,
    longitude,
  ];
}
