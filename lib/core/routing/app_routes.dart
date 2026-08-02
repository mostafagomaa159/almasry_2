class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String otpVerification = '/otp-verification';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String editProfile = '/editProfile';

  static const orders = '/orders';
  static const orderDetails = '/orderDetails';
  static const String productDetails = '/product-details';
  static const String productList = '/productList';
  static const String categories = '/categories';

  static const String comingsoonview = '/comingsoonview';

  static const String wishlist = '/wishlist';
}

/// Route *names* used by [NavigationService] and [AppRouter].
///
/// Always navigate by name, never by the paths in [AppRoutes]: several screens
/// are nested inside the shell branches, so their real path is not the constant
/// declared above (e.g. `orderDetails` actually lives at `/profile/orderDetails`).
class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String otpVerification = 'otpVerification';
  static const String signup = 'signup';
  static const String home = 'home';
  static const String profile = 'profile';
  static const String editProfile = 'editProfile';
  static const String orders = 'orders';
  static const String orderDetails = 'orderDetails';
  static const String productDetails = 'productDetails';
  static const String productList = 'productList';
  static const String categories = 'categories';
  static const String comingSoon = 'comingsoonview';
  static const String wishlist = 'wishlist';
}
