# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

`almasry_2` — a Flutter (Dart SDK ^3.10.8) e-commerce/pharmacy app for Al Masry Pharmacy, backed by a Magento REST API. Arabic-first (RTL) with English fallback.

## Commands

```bash
flutter pub get                      # install deps
flutter run                          # run on connected device/emulator
flutter analyze                      # lint (rules in analysis_options.yaml)
dart format lib                      # format
flutter test                         # run all tests
flutter test test/widget_test.dart   # run a single test file
flutter test --plain-name "substring of test name"   # run one test
flutter build apk --release
flutter pub run flutter_launcher_icons   # regenerate launcher icons
```

Note: `test/widget_test.dart` is still the untouched Flutter counter template and fails against this app. Replace it rather than trusting it as a baseline.

## Architecture

### The `part` / barrel-file convention (most important thing to know)

Every feature under `lib/features/<feature>/` has a barrel file `<feature>_imports.dart` (e.g. `login_imports.dart`, `home_imports.dart`). That barrel holds **all** the imports for the feature and a list of `part` directives. Each view, view_model, and widget file begins with `part of '../<feature>_imports.dart';` and contains **no imports of its own**.

Consequences when editing:
- To use a new symbol inside a view/widget/view_model, add the `import` to the feature's `_imports.dart`, not to the file you're editing.
- To add a new file to a feature, create it as a `part of`, then register a `part '...'` line in the barrel. A file not listed in the barrel will not compile as part of the feature.
- Cross-feature use works by importing the *other feature's barrel* (e.g. `home_imports.dart` imports `product_list_imports.dart`).
- **A `part` file belongs to exactly one library.** So anything two features both need cannot be a `part` — it has to be a standalone library (its own imports, no `part of`) that both barrels `import`. That is why the shared state models (`UserModel`, `SplashData`), the shared args (`OtpVerificationArgs`, `OrderDetailsArgs`), the shared services (`AuthSessionService`, `AppStartupService`, `FavoritesService`) and the shared widgets (`AuthHeader`, `OrderStatusChip`) all live in `lib/core/` as plain libraries.
- **No feature barrel imports another feature barrel.** This is now an invariant — if you find yourself needing one, the symbol you want belongs in `core` instead.
- Some files live outside the feature folder but are still `part of` its barrel — notably the per-feature state models under `lib/core/models/response/...` (e.g. `product_list_view_model.dart` there defines `ProductListData`, and is `part of` `product_list_imports.dart`), plus `lib/features/layout/view/layout_shell_view.dart` which is `part of` `home_imports.dart`.

### One feature per screen, with a per-screen ViewModel

**Every feature follows this** — login, register, otp_verification, splash, wishlist, my_order_details, orders, categories, product_list, edit_profile, profile, product_details, home. (`login`, `register` and `otp_verification` are three separate features; there is no `auth` feature.) In each:

- The **View** holds only lifecycle and layout: `vm._init()` in `initState`, `vm._dispose()` in `dispose`, and a widget tree. No validation, no API calls, no prefs, no navigation.
- The **ViewModel** is per-screen, constructed by the View (`final LoginViewModel vm = LoginViewModel();`) and owns the controllers, focus nodes, validation, persistence and navigation. Its members are **private** (`_emailOrPhoneController`, `_submitRegularLogin`), which works because the View and widgets are `part of` the same barrel.
- **Widgets take a single `vm` param** — `RegularLoginForm(vm: vm)` — and read `vm._data`, `vm._passwordController`, `vm._togglePasswordVisibility` directly instead of receiving a dozen constructor arguments.
- View-local *layout* state stays in the View as `setState` (e.g. which login form is visible, the OTP pin rebuild that enables the verify button). Only business logic belongs in the VM.

- Each ViewModel has a `_dispose()` that closes its cubits and disposes its controllers, called from the View's `dispose`. Add it when you add a cubit — the pre-refactor code leaked nearly all of them.

Cross-screen state does **not** live in a feature. It goes in a locator-registered service under `lib/core/services/` — `AuthSessionService`, `AppStartupService`, `FavoritesService`. Their members are public precisely because several feature libraries consume them; per-screen ViewModel members are private.

Two deliberate exceptions to "private members":
- A member nothing reads yet stays public with a comment, because privatising it would only produce an `unused_element` / `unused_field` warning (`OrdersViewModel.fetchMore`/`reset`, `CategoriesViewModel.errorMessage`, `HomeViewModel.changeOfferTab`).
- Genuinely presentational leaf widgets keep their parameters — `AppTextField`, `EditProfileTextField`, `ProfileMenuItem`, `OtpVerifyButton`, `ProductDetailsSummarySection`. The *section* widget above them takes `vm`.

### State management: `GenericCubit<T>` (no per-feature blocs)

There are no feature-specific Bloc events/states. Everything uses:

- `GenericCubit<T>` (`lib/core/base/bloc/generic_cubit.dart`) — a `Cubit<GenericState<T>>` with one method, `onUpdateData(T data)`.
- `GenericState<T>` (`Equatable`) carries `data` plus a `changed` bool that `onUpdateData` flips each emit, so identical data still triggers a rebuild.

A ViewModel is a **plain class** (not a Cubit) that owns one `GenericCubit<TData>` and mutates it with `cubit.onUpdateData(cubit.state.data.copyWith(...))`. Every `TData` class is immutable with a `copyWith` that also takes explicit `clearX` / `resetX` flags (needed because `copyWith` can't otherwise null a field).

Beyond that the `TData` classes are **not** uniform — don't assume a shape, check the file:
- `ProductListData` — `extends Equatable`, has a `ProductListStatus` enum (`initial/loading/success/error`) and an `errorMessage`. This is the fullest form.
- `SplashData` — plain class (not `Equatable`), but does have a `StartupStatus` enum.
- `UserModel`, `ProfileData`, `FavoritesModel` — plain classes, no `Equatable`, no status enum. `UserModel` tracks progress with discrete bool flags instead (`isLoading`, `isPhoneAuthLoading`, `isOtpVerificationLoading`) plus nullable per-field error strings.

Note that `GenericState<T>` itself *is* `Equatable`, which is what makes the `changed` flag necessary.

Views consume the cubit two ways, both in use:
- `BlocBuilder<GenericCubit<T>, GenericState<T>>(bloc: viewModel.xCubit, ...)` — for locally-created ViewModels (e.g. `home_view.dart`).
- `BlocProvider<GenericCubit<T>>.value(value: viewModel.xCubit, child: BlocBuilder<...>)` — e.g. `profile_view.dart`; the three global cubits are provided this way in `main.dart`. The login/register/otp views rely on this: they use a bare `BlocBuilder<GenericCubit<UserModel>, ...>` with no `bloc:` argument, resolving the cubit `main.dart` provided.

### Dependency injection (`get_it`)

`lib/core/base/locator/locator.dart` exposes `sl` and registers lazy singletons: `ApiService`, `NavigationService`, `AuthSessionService`, `AppStartupService`, `FavoritesService`. The cubits of the last three are hoisted into `MultiBlocProvider` in `main.dart`, so they hold **app-global** state.

**No ViewModel is registered in the locator** — every feature's view constructs its own in `initState()` (`final HomeViewModel vm = HomeViewModel();` then `vm._init();`) and disposes it. Global state belongs in a `core/services` singleton, per-screen state does not.

### Routing (`go_router`)

`lib/core/routing/app_router.dart` defines a single static `GoRouter`. `app_routes.dart` holds two constant classes: `AppRoutes` (paths, used only in the router's `path:` fields) and `RouteNames` (names, used in the router's `name:` fields and at every call site).

**All navigation goes through `NavigationService` — no `context.go` / `context.push` / `Navigator` anywhere in `lib/`.** Get it with `sl<NavigationService>()`: a `final NavigationService _nav = sl<NavigationService>();` field in `State` classes and ViewModels, or a `NavigationService get _nav => sl<NavigationService>();` getter in `StatelessWidget`s (a field would break their `const` constructors). It wraps the router (`goNamed` / `pushNamed` / `pushNamedAndReturn` / `replaceNamed` / `pop` / `canPop`) so ViewModels can navigate with no `BuildContext`.

Always pass a `RouteNames` constant, never an `AppRoutes` path — the two are easy to confuse and both are `String`. Passing a path to `goNamed` throws at runtime, and pushing a raw path fails for shell-nested screens whose real location differs from their `AppRoutes` constant (`orderDetails` actually lives at `/profile/orderDetails`, `productDetails` at `/home/productDetails`).

Structure: `splash` → `login` / `otpVerification` / `signup` sit outside the shell, each coming from its own barrel (`login_imports.dart`, `otp_verification_imports.dart`, `register_imports.dart`). A `StatefulShellRoute.indexedStack` wraps four branches — home, categories, cart (`ComingSoonView` placeholder), profile — rendered inside `LayoutShellView`, which drives `HomeBottomNavBar` via `navigationShell.goBranch`. Nested routes (`productList`, `productDetails` under home; `orders`, `orderDetails`, `wishlist`, `editProfile` under profile) keep the bottom bar visible.

Arguments are passed as `state.extra` and cast to typed `*Args` models under `lib/core/models/response/*/..._args_model.dart`. Casts are unguarded (`state.extra as ProductListArgs`), so a navigation missing `extra` crashes — always pass it.

### Networking

`ApiService` is a thin Dio wrapper (`get` / `post`) over `ApiConstants.baseUrl`, with the Magento bearer token and 20s timeouts set on `BaseOptions`. There is **no repository/data layer** — each ViewModel (or `AuthSessionService`, for auth) calls `_apiService` directly, maps the raw JSON into models itself, and owns its own `_extractApiMessage(DioException)` helper (duplicated across them). Endpoints and the token are hardcoded in `lib/core/constants/app_api.dart`; `mediaBaseUrl` is used to build image URLs.

Auth is only half-wired: `AuthSessionService.login()` and `register()` are **stubs** — `await Future.delayed(const Duration(seconds: 1))` with no API call, so they can never fail. Only the phone path is real (`startPhoneAuth` → `_forgetPassword`, `verifyOtpCode` → `_activateAccount` + `_loginAfterOtp`). Don't treat email/password login as functional; the Magento login endpoint isn't in `app_api.dart` yet.

Request DTOs live in `lib/core/models/request/`, responses in `lib/core/models/response/`, both hand-written `fromJson` / `toJson` (no codegen).

### Persistence

- `SharedPrefsServices` — static wrapper over `shared_preferences`, `init()`ed in `main()`; keys in `pref_keys.dart`. Drives the splash gate (`isFirstTime` / `isLoggedIn`) via `SplashViewModel.checkAppStart/saveLoggedIn/logout`, and caches profile fields.
- `DbServices` — sqflite singleton backing the wishlist (`favorites` table), consumed by `FavoritesViewModel`.

### Localization & UI conventions

- `easy_localization` with `assets/translations/{ar,en}.json`; `startLocale` is Arabic, fallback English. Reference strings via `LocaleKeys.someKey.tr()` — add the constant to `lib/core/localization/locale_keys.dart` **and** both JSON files. (Some validation/API error messages are still hardcoded Arabic literals — most of them in `AuthSessionService`.)
- `flutter_screenutil` with `designSize: Size(430, 932)` — size text with `.sp`, dimensions with `.w` / `.h` / `.r`.
- Shared constants in `lib/core/constants/` (`AppColors`, `AppSizes`, `AppImages`); shared widgets in `lib/core/widgets/` (`AppButton`, `AppTextField`, `AuthHeader`); form validation helpers in `lib/core/utils/validators.dart`.

### Lint expectations

`analysis_options.yaml` enables beyond `flutter_lints`: `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `prefer_final_locals`, `always_declare_return_types`, `avoid_print`, `sized_box_for_whitespace`, `use_key_in_widget_constructors`. `lines_longer_than_80_chars` is off.
