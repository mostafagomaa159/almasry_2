import 'package:almasry_2/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';

/// Single entry point for navigation across the app.
///
/// Resolve it with `sl<NavigationService>()` — views, widgets and view models
/// all navigate through this instead of `context.go` / `context.push`, so no
/// `BuildContext` is required and navigation works from view models too.
///
/// Always pass a [RouteNames] constant, never an [AppRoutes] path.
class NavigationService {
  final GoRouter _router = AppRouter.router;

  void goNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) {
    _router.goNamed(name, pathParameters: pathParameters, extra: extra);
  }

  void pushNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) {
    _router.pushNamed(name, pathParameters: pathParameters, extra: extra);
  }

  /// Use this when you need to get data back from the next screen
  Future<Object?> pushNamedAndReturn(
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) {
    return _router.pushNamed(
      name,
      pathParameters: pathParameters,
      extra: extra,
    );
  }

  void replaceNamed(
    String name, {
    Map<String, String> pathParameters = const {},
    Object? extra,
  }) {
    _router.replaceNamed(name, pathParameters: pathParameters, extra: extra);
  }

  void pop([Object? result]) {
    if (_router.canPop()) {
      _router.pop(result);
    }
  }

  bool get canPop => _router.canPop();
}
