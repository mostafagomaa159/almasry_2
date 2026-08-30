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
- **A `part` file belongs to exactly one library.** So anything two features both need cannot be a `part` — it has to be a standalone library (its own imports, no `part of`) that both barrels `import`. That is why the shared state models (`UserModel`, `SplashData`, `CartData`), the shared args (`OtpVerificationArgs`, `OrderDetailsArgs`, `AddressFormArgs`, `OrderConfirmedArgs`), the shared services (`AuthSessionService`, `AppStartupService`, `FavoritesService`, `CartService`, `AddressBookService`) and the shared widgets (`AuthHeader`, `OrderStatusChip`, `CartTotalsCard`, `CheckoutStepper`) all live in `lib/core/` as plain libraries.
- **No feature barrel imports another feature barrel.** This is now an invariant — if you find yourself needing one, the symbol you want belongs in `core` instead.
- Some files live outside the feature folder but are still `part of` its barrel — notably the per-feature state models under `lib/core/models/response/...` (e.g. `product_list_view_model.dart` there defines `ProductListData`, and is `part of` `product_list_imports.dart`), plus `lib/features/layout/view/layout_shell_view.dart` which is `part of` `home_imports.dart`.

### One feature per screen, with a per-screen ViewModel

**Every feature follows this** — login, register, otp_verification, splash, wishlist, my_order_details, orders, categories, product_list, edit_profile, profile, product_details, home, cart, checkout_shipping, checkout_payment, checkout_review, order_confirmed, address_form. (`login`, `register` and `otp_verification` are three separate features; there is no `auth` feature. Likewise the three checkout steps are three features, not one `checkout`.) In each:

- The **View** holds only lifecycle and layout: `vm._init()` in `initState`, `vm._dispose()` in `dispose`, and a widget tree. No validation, no API calls, no prefs, no navigation.
- The **ViewModel** is per-screen, constructed by the View (`final LoginViewModel vm = LoginViewModel();`) and owns the controllers, focus nodes, validation, persistence and navigation. Its members are **private** (`_emailOrPhoneController`, `_submitRegularLogin`), which works because the View and widgets are `part of` the same barrel.
- **Widgets take a single `vm` param** — `RegularLoginForm(vm: vm)` — and read `vm._data`, `vm._passwordController`, `vm._togglePasswordVisibility` directly instead of receiving a dozen constructor arguments.
- View-local *layout* state stays in the View as `setState` (e.g. which login form is visible, the OTP pin rebuild that enables the verify button). Only business logic belongs in the VM.

- Each ViewModel has a `_dispose()` that closes its cubits and disposes its controllers, called from the View's `dispose`. Add it when you add a cubit — the pre-refactor code leaked nearly all of them.

Cross-screen state does **not** live in a feature. It goes in a locator-registered service under `lib/core/services/` — `AuthSessionService`, `AppStartupService`, `FavoritesService`, `CartService`, `AddressBookService`. Their members are public precisely because several feature libraries consume them; per-screen ViewModel members are private.

`CartViewModel` is the clearest example of the split: it owns **no cubit at all**, reads `CartService.cartCubit`, and its `_dispose()` is deliberately empty — closing the service cubit would take the bottom-bar badge and every later screen down with the screen.

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

`lib/core/base/locator/locator.dart` exposes `sl` and registers lazy singletons: `SharedPrefsServices`, `ApiService`, `GraphQLService`, `NavigationService`, `AuthSessionService`, `AppStartupService`, `FavoritesService`, `CartService`, `AddressBookService`, `AlertService`, `CacheManagerService`, `PushNotificationService`. The service-owned cubits hold **app-global** state; consumers reach them with an explicit `bloc:` on the `BlocBuilder` (e.g. `bloc: sl<CartService>().cartCubit` in `LayoutShellView`) rather than through a provider.

**No ViewModel is registered in the locator** — every feature's view constructs its own in `initState()` (`final HomeViewModel vm = HomeViewModel();` then `vm._init();`) and disposes it. Global state belongs in a `core/services` singleton, per-screen state does not.

### Routing (`go_router`)

`lib/core/routing/app_router.dart` defines a single static `GoRouter`. `app_routes.dart` holds two constant classes: `AppRoutes` (paths, used only in the router's `path:` fields) and `RouteNames` (names, used in the router's `name:` fields and at every call site).

**All navigation goes through `NavigationService` — no `context.go` / `context.push` / `Navigator` anywhere in `lib/`.** Get it with `sl<NavigationService>()`: a `final NavigationService _nav = sl<NavigationService>();` field in `State` classes and ViewModels, or a `NavigationService get _nav => sl<NavigationService>();` getter in `StatelessWidget`s (a field would break their `const` constructors). It wraps the router (`goNamed` / `pushNamed` / `pushNamedAndReturn` / `replaceNamed` / `pop` / `canPop`) so ViewModels can navigate with no `BuildContext`.

Always pass a `RouteNames` constant, never an `AppRoutes` path — the two are easy to confuse and both are `String`. Passing a path to `goNamed` throws at runtime, and pushing a raw path fails for shell-nested screens whose real location differs from their `AppRoutes` constant (`orderDetails` actually lives at `/profile/orderDetails`, `productDetails` at `/home/productDetails`).

Structure: `splash` → `login` / `otpVerification` / `signup` sit outside the shell, each coming from its own barrel (`login_imports.dart`, `otp_verification_imports.dart`, `register_imports.dart`). The three checkout steps (`checkoutShipping`, `checkoutPayment`, `checkoutReview`) and `addressForm` also sit outside the shell — the design shows no bottom bar on them, and stepping back through them must not switch tabs.

A `StatefulShellRoute.indexedStack` wraps four branches — home, categories, cart, profile — rendered inside `LayoutShellView`, which drives `HomeBottomNavBar` via `navigationShell.goBranch`. Nested routes (`productList`, `productDetails` under home; `orders`, `orderDetails`, `wishlist`, `editProfile` under profile; `orderConfirmed` under cart) keep the bottom bar visible.

Arguments are passed as `state.extra` and cast to typed `*Args` models under `lib/core/models/response/*/..._args_model.dart`. Casts are unguarded (`state.extra as ProductListArgs`), so a navigation missing `extra` crashes — always pass it.

**One exception: a route with children must type-test rather than cast.** go_router hands the *same* `extra` to every route in the matched chain, so `goNamed` straight to a nested route also rebuilds its parents with that child's argument. `home` and `profile` therefore do `extra is ProfileArgs ? extra : null` — `/profile/orders` takes a `String` email and `/home/comingSoon` takes a `String` title, and a plain cast in the parent throws `type 'String' is not a subtype of type 'ProfileArgs?'`. (`pushNamed` from inside the parent hides this, because the parent is already mounted and never rebuilt.)

### Networking

`ApiService` is a thin Dio wrapper (`get` / `post`) over `ApiConstants.baseUrl`, with the Magento bearer token and 20s timeouts set on `BaseOptions`. There is **no repository/data layer** — each ViewModel (or `AuthSessionService`, for auth) calls `_apiService` directly, maps the raw JSON into models itself, and owns its own `_extractApiMessage(DioException)` helper (duplicated across them). Endpoints and the token are hardcoded in `lib/core/constants/app_api.dart`; `mediaBaseUrl` is used to build image URLs.

Auth is only half-wired: `AuthSessionService.login()` and `register()` are **stubs** — `await Future.delayed(const Duration(seconds: 1))` with no API call, so they can never fail. Only the phone path is real (`startPhoneAuth` → `_forgetPassword`, `verifyOtpCode` → `_activateAccount` + `_loginAfterOtp`). Don't treat email/password login as functional; the Magento login endpoint isn't in `app_api.dart` yet.

The phone path is also the only one that produces a **customer session**: `_saveOtpSession` persists the phone, the `customer.email` the reply carries, and Magento's customer token (`PrefKeys.customerToken`), then calls `AppStartupService.saveLoggedIn()` and `CartService.adoptCustomerCart()`. The email/password stub sets `isLoggedIn` but has no token, so those users stay on a guest cart. `AppStartupService.logout()` is what takes the token and the cart back off the device.

`GraphQLService` is the equivalent wrapper for GraphQL (`query` / `mutate`), holding one long-lived `GraphQLClient` for the whole app session. Every call carries `Authorization: Bearer <PrefKeys.customerToken>` once a customer token is stored — that header is the whole difference between a guest cart and a customer one. A reply whose message reads as an auth failure drops the stored token (`_forgetTokenIfRejected`), because a token Magento no longer accepts would otherwise break browsing too, with no way back. **Both methods deliberately bypass the normalized cache** (`FetchPolicy.noCache`) — read the comment on `query` before changing it. `networkOnly` looks equivalent (both always hit the network) but hands back a *re-read* of the normalized cache, and because the client is shared, two queries selecting the same entity with different field sets make that re-read fail with `CacheMissException: Round trip cache re-read failed`. The cart hit this: `getCartDetails` selects `Cart.id` and stores a `shipping_addresses` list with no `available_shipping_methods`, then `getCartShippingMethods` selects `cart` without `id` and its re-read resolves back to that stored entity. Nothing in the app reads the cache, so there is nothing to gain by re-enabling it.

`errorMessageFrom` is the one place that turns a caught error into copy. It rejects anything implausible as a *message* — empty, over 240 characters, or starting with `<` — because both wrappers fall back to stringifying the underlying exception, which can be an HTML error page or a whole request dump. Discarded text goes to `debugPrint`, so a mystery failure is still diagnosable from the console.

Request DTOs live in `lib/core/models/request/`, responses in `lib/core/models/response/`, both hand-written `fromJson` / `toJson` (no codegen).

### Cart & checkout (GraphQL)

The whole basket-to-order flow is GraphQL — documents in `app_graphql.dart`, no REST involved.

- **`GraphQLDocuments.cartFragment`** is the shape `getCartDetails` and *every* cart mutation select. So one round trip both applies a change and refreshes the state, and `CartModel.fromResponse(json, mutationKey: 'addSimpleProductsToCart')` parses them all. Add a field to the fragment, not to one operation.
- **`CartService`** is the only owner of the masked cart id (persisted under `PrefKeys.cartId`). `ensureCartId()` mints one lazily on first add, so nothing else has to know whether a cart exists. Its mutation methods return a `bool` and leave the message on the cubit — no screen translates an exception. A "Could not find a cart with ID" reply drops the id rather than reporting it, or the app would be stuck on an unretryable error.
- **`updateCartItems` is not in the API brief** (which documents only add and remove) but the cart rows carry a stepper. Quantity 0 removes the line, which is what the minus button does on the last unit.
- **Checkout order is fixed by Magento**, not by preference: shipping address → shipping method → payment method → `placeOrder`. Methods are only quoted for a cart that already has an address, and a payment method is only accepted once a carrier is set. `CheckoutShippingViewModel._selectAddress` therefore fires three calls behind one spinner (set shipping, set billing, re-quote).
- **`placeOrder` answers HTTP 200 with an `errors` list** when it refuses. `PlaceOrderResponse.isSuccess` — not the absence of a thrown exception — is what decides.
- **Adding to the cart requires an account**, and that is the only place the app asks. `CartService.addToCart` answers an anonymous tap with `AlertService.showConfirmation` — "Sign in to continue", Cancel or Confirm — and returns `false` with no message; only Confirm pushes `RouteNames.login`, so the tap otherwise leaves the shopper where they were. Every screen with a cart icon is covered by that one check, and the callers show a failure message only when there is one to show. Neither sign-in is privileged: `PrefKeys.isLoggedIn` is what counts. Each screen's own wrapper is `_addToCart` too — the name is the same from the widget's tap handler down to the service.
- **A customer's cart is resolved, not minted.** With a token stored, `ensureCartId()` asks `customerCart` for the account's masked id (and `loadCart` does the same on a fresh install, so the basket follows the account onto a new device); `createEmptyCart` is the fallback and the guest path. `setGuestEmailOnCart` still fires when `PrefKeys.email` holds one, silently — it is what keeps the stubbed email/password login able to order at all, since it produces no token. Nothing gates the shipping step on it any more: if Magento still refuses, `placeOrder` says so in its own words on the review screen.
- **The address book is device-local** (`AddressBookService`, shared preferences). Magento's customer-address API is not part of this integration; the brief only exposes the two "set address on cart" mutations, which take a whole address inline. `region_id` is likewise not sent — there is no governorate table, and Magento resolves the `region` label on its own.
- Two places knowingly diverge from the payload: `ShippingMethodModel.displayTitle` uses `carrier_title` ("Best Way"), not `method_title` ("Table Rate"), because that is what the design shows; and the payment rows draw a code-derived icon rather than borrow an option's logo, because this store's `bankcards` options carry Instapay artwork.
- The map on the address form is `AddressFormLocationPicker`, a **placeholder** — a real picker needs `google_maps_flutter` and a platform API key, neither of which this project has. `AddressModel` already carries `latitude` / `longitude`, so wiring one in is a change to that widget alone.

### Persistence

- `SharedPrefsServices` — static wrapper over `shared_preferences`, `init()`ed in `main()`; keys in `pref_keys.dart`. Drives the splash gate (`isFirstTime` / `isLoggedIn`) via `SplashViewModel.checkAppStart/saveLoggedIn/logout`, and caches profile fields.
- `DbServices` — sqflite singleton backing the wishlist (`favorites` table), consumed by `FavoritesViewModel`.

### Localization & UI conventions

- `easy_localization` with `assets/translations/{ar,en}.json`; `startLocale` is Arabic, fallback English. Reference strings via `LocaleKeys.someKey.tr()` — add the constant to `lib/core/localization/locale_keys.dart` **and** both JSON files. (Some validation/API error messages are still hardcoded Arabic literals — most of them in `AuthSessionService`.)
- `flutter_screenutil` with `designSize: Size(430, 932)` — size text with `.sp`, dimensions with `.w` / `.h` / `.r`.
- Shared constants in `lib/core/constants/` (`AppColors`, `AppSizes`, `AppImages`); shared widgets in `lib/core/widgets/` (`AppButton`, `AppTextField`, `AuthHeader`); form validation helpers in `lib/core/utils/validators.dart`.

### Lint expectations

`analysis_options.yaml` enables beyond `flutter_lints`: `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `prefer_final_locals`, `always_declare_return_types`, `avoid_print`, `sized_box_for_whitespace`, `use_key_in_widget_constructors`. `lines_longer_than_80_chars` is off.
