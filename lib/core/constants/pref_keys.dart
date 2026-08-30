class PrefKeys {
  PrefKeys._();

  static const String isFirstTime = 'is_first_time';
  static const String isLoggedIn = 'is_logged_in';
  static const String languageCode = 'language_code';

  static const String email = 'email';
  static const String phone = 'phone';
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';

  static const String recentSearches = 'recent_searches';

  /// The masked cart id — `customerCart` for a signed-in customer, otherwise
  /// `createEmptyCart`. Kept so the basket survives a restart instead of a new
  /// cart being minted every run.
  static const String cartId = 'cart_id';

  /// Magento's customer token, from the OTP login reply. Its presence is what
  /// turns every GraphQL call into a customer call — see `GraphQLService`.
  static const String customerToken = 'customer_token';

  /// Cache keys — see `CacheManagerService`.
  static const String cachedBrands = 'cached_brands';

  /// Keyed by language because the governorate *names* are localised by store
  /// view, even though their ids are not.
  static String cachedRegions(String languageCode) =>
      'cached_regions_$languageCode';

  /// The local address book — Magento's customer address API is not part of
  /// this integration, so the checkout keeps its own list.
  static const String savedAddresses = 'saved_addresses';
}
