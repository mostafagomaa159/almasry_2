/// The Magento store views the app talks to, and the header that picks one.
///
/// Magento resolves a GraphQL request against whichever store view the `store`
/// header names, falling back to the default view when the header is absent.
/// Relying on that fallback is what the search queries used to do; naming the
/// view explicitly is safer, because "no header" and "the default view" stop
/// meaning the same thing the moment the backend's default changes.
class AppStores {
  const AppStores._();

  /// HTTP headers are case-insensitive, and lower-case `store` is what the
  /// brands and search queries have been sending against this backend.
  static const String header = 'store';

  /// The Arabic store view.
  static const String arabic = 'arabic';

  /// The default (English) store view.
  static const String defaultView = 'default';

  /// The store view an ISO language code maps to.
  static String forLanguage(String languageCode) =>
      languageCode == arabicLanguageCode ? arabic : defaultView;

  static const String arabicLanguageCode = 'ar';
  static const String englishLanguageCode = 'en';
}
