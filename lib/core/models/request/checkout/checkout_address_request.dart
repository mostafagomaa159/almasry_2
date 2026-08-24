import 'package:almasry_2/core/models/response/checkout/address_model.dart';

/// Turns an address-book entry into the `CartAddressInput` both address
/// mutations take.
///
/// `region` carries the governorate's English **code**, not its display name:
/// Magento matches codes, and the Arabic store view returns names it will not
/// accept back. `region_id` goes with it whenever the form captured one —
/// without it Magento answers "regionId is required" for anything it cannot
/// resolve from the string alone. The ids come from
/// [GraphQLDocuments.getCountryRegions]; do not hard-code them, the brief's
/// example value is not even this store's.
Map<String, dynamic> cartAddressInputFrom(AddressModel address) {
  final String region = address.regionCode.trim().isNotEmpty
      ? address.regionCode.trim()
      : address.government.trim();

  return <String, dynamic>{
    'firstname': address.firstName,
    'lastname': address.lastName,
    'street': address.streetLines,
    'city': address.government,
    'region': region,
    if (address.regionId != null) 'region_id': address.regionId,
    'postcode': AddressModel.defaultPostcode,
    'country_code': AddressModel.countryIsoCode,
    'telephone': address.fullPhone,
    if (address.latitude != null) 'latitude': '${address.latitude}',
    if (address.longitude != null) 'longitude': '${address.longitude}',
    'save_in_address_book': false,
  };
}

/// Variables for [GraphQLDocuments.setShippingAddressesOnCart].
class SetShippingAddressRequest {
  final String cartId;
  final AddressModel address;

  const SetShippingAddressRequest({
    required this.cartId,
    required this.address,
  });

  Map<String, dynamic> toVariables() {
    return {
      'input': {
        'cart_id': cartId,
        'shipping_addresses': [
          {'address': cartAddressInputFrom(address)},
        ],
      },
    };
  }
}

/// Variables for [GraphQLDocuments.setBillingAddressOnCart]. The checkout has
/// no separate billing step, so this replays the shipping address.
class SetBillingAddressRequest {
  final String cartId;
  final AddressModel address;

  const SetBillingAddressRequest({required this.cartId, required this.address});

  Map<String, dynamic> toVariables() {
    return {
      'input': {
        'cart_id': cartId,
        'billing_address': {'address': cartAddressInputFrom(address)},
      },
    };
  }
}
