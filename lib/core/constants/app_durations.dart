/// Every timing the app runs on — animations, debounces, polls and network
/// deadlines.
///
/// Named by the job rather than the number, so two roles that happen to share
/// a value today (the alert's slide and edit-profile's save pause are both
/// 500ms; the banner's dwell and the splash hold are both 3s) can drift apart
/// without a hunt through the call sites.
class AppDurations {
  const AppDurations._();

  // ---------------------------------------------------------------------------
  // Interface animation — shortest to longest
  // ---------------------------------------------------------------------------

  /// Long enough for the OTP field to settle before focus hops on.
  static const Duration focusHop = Duration(milliseconds: 50);

  /// The gallery thumbnail highlight, and the remember-me tick.
  static const Duration highlight = Duration(milliseconds: 180);

  /// The per-item stagger down a list or grid.
  static const Duration listStagger = Duration(milliseconds: 200);

  /// Expanding and collapsing the product description.
  static const Duration expand = Duration(milliseconds: 220);

  /// The content fade-in once a screen's data lands.
  static const Duration contentFade = Duration(milliseconds: 250);

  /// Paging the product gallery, and centring its thumbnail strip.
  static const Duration page = Duration(milliseconds: 280);

  /// The floating scroll-to-top button.
  static const Duration floatToggle = Duration(milliseconds: 300);

  /// Sliding the home banner to the next slide.
  static const Duration bannerSlide = Duration(milliseconds: 400);

  /// The alert banner's slide in and out.
  static const Duration alertSlide = Duration(milliseconds: 500);

  /// The entrance animation on the brands and search grids.
  static const Duration entrance = Duration(milliseconds: 800);

  /// The splash logo's animation.
  static const Duration splashLogo = Duration(milliseconds: 1800);

  // ---------------------------------------------------------------------------
  // Input and pacing
  // ---------------------------------------------------------------------------

  /// How long the search box waits after the last keystroke before querying.
  static const Duration searchDebounce = Duration(milliseconds: 450);

  /// The beat edit-profile holds after a save so the result is legible.
  static const Duration savePause = Duration(milliseconds: 500);

  /// How long each home banner slide is shown.
  static const Duration bannerInterval = Duration(seconds: 3);

  /// How long the splash sits before routing on.
  static const Duration splashHold = Duration(seconds: 3);

  /// How long an alert stays on screen.
  static const Duration alertVisible = Duration(seconds: 4);

  // ---------------------------------------------------------------------------
  // Network
  // ---------------------------------------------------------------------------

  /// Connect and receive deadlines on every request.
  static const Duration networkTimeout = Duration(seconds: 20);

  /// The pause the stubbed login and register fake work with. Delete this with
  /// them, once the Magento endpoints are wired.
  static const Duration authStub = Duration(seconds: 1);
}
