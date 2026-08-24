import 'package:equatable/equatable.dart';

/// One entry of the checkout address book.
///
/// Magento's customer-address API is not part of this integration — the brief
/// only exposes `setShippingAddressesOnCart` / `setBillingAddressOnCart`,
/// which take a whole address inline. So the book is kept on the device by
/// `AddressBookService` and each entry is replayed into the cart at checkout,
/// which is also why this model is JSON round-trippable in both directions.
///
/// [Equatable] so the checkout can tell an edit that changed the delivery
/// point from one that did not, and skip re-quoting when nothing moved.
class AddressModel extends Equatable {
  /// Local identity only — Magento never sees it.
  final String id;

  final String firstName;
  final String lastName;

  /// Stored without the dialling code; [fullPhone] puts them back together.
  final String phone;
  final String countryCode;

  /// The free-text line under the map, e.g. "25 Makram Ebeid St, Nasr City".
  final String addressLine;

  final String buildingNumber;
  final String floor;
  final String apartment;

  /// The optional landmark the form calls "Mark".
  final String mark;

  /// The governorate's display name — what the form's "Government" dropdown
  /// shows, localised by store view. Sent as Magento's `city`.
  final String government;

  /// Magento's `region_id`. Not optional in practice: without it Magento
  /// rejects the address with "regionId is required" unless it can resolve
  /// [regionCode] on its own, which it only manages for exact matches.
  final int? regionId;

  /// The governorate's stable English handle (`Cairo`, `Kafr Al sheikh`),
  /// which is what Magento wants in `region` — the localised name is not
  /// accepted there.
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

  /// The form has no postcode field and Magento rejects an address without
  /// one, so every address ships with this placeholder.
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

  AddressModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? countryCode,
    String? addressLine,
    String? buildingNumber,
    String? floor,
    String? apartment,
    String? mark,
    String? government,
    int? regionId,
    String? regionCode,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      addressLine: addressLine ?? this.addressLine,
      buildingNumber: buildingNumber ?? this.buildingNumber,
      floor: floor ?? this.floor,
      apartment: apartment ?? this.apartment,
      mark: mark ?? this.mark,
      government: government ?? this.government,
      regionId: regionId ?? this.regionId,
      regionCode: regionCode ?? this.regionCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  String get fullPhone => '$countryCode$phone';

  /// "Cairo / Nasr City" on the address card. The area is pulled off the tail
  /// of the free-text line, which is how the map picker writes it.
  String get cityLine {
    final String area = addressLine.split(',').last.trim();

    if (government.trim().isEmpty) return area;
    if (area.isEmpty || area == government.trim()) return government.trim();

    return '${government.trim()} / $area';
  }

  /// The second Magento street line: everything the form collects that is not
  /// part of the free-text address.
  String get detailsLine {
    final List<String> parts = <String>[
      if (buildingNumber.trim().isNotEmpty) buildingNumber.trim(),
      if (floor.trim().isNotEmpty) floor.trim(),
      if (apartment.trim().isNotEmpty) apartment.trim(),
      if (mark.trim().isNotEmpty) mark.trim(),
    ];

    return parts.join(' - ');
  }

  /// What the address card and the order review print.
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

  /// [isDefault] is left out on purpose: flagging a different card default does
  /// not move the parcel, so it must not force the cart to be re-quoted.
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
