import 'package:flutter/material.dart';

/// Every colour the app draws, in one place.
///
/// This is a *catalogue*, not a curated palette: it holds each value the
/// screens were already using, named by the job it does, with nothing merged.
/// Several entries are a shade or two apart — five reds, a long run of greys —
/// because the designs they came from are. Collapsing them is a separate,
/// deliberate change; doing it here would have moved pixels on screens nobody
/// was looking at.
///
/// Names describe the role, so a later consolidation is a matter of pointing
/// two names at one value rather than hunting hex literals again.
class AppColors {
  // ---------------------------------------------------------------------------
  // Base
  // ---------------------------------------------------------------------------

  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;
  static const Color black = Color(0xFF000000);

  // ---------------------------------------------------------------------------
  // Brand — navy
  // ---------------------------------------------------------------------------

  /// Brand chrome: the drawer, the auth headers, the bottom bar.
  static const Color darkBlue = Color(0xFF173B63);

  /// Headline navy on the product, order and search cards.
  static const Color titleNavy = Color(0xFF18314F);

  /// Section headings across the product details screen.
  static const Color navyHeading = Color(0xFF11385B);

  /// Names and values on the profile and edit-profile screens.
  static const Color navyProfile = Color(0xFF17375E);

  /// Titles on the home product and wide-info cards.
  static const Color navyCard = Color(0xFF183B61);

  /// The deepest navy, on the guest profile body.
  static const Color navyDeepest = Color(0xFF0A3152);

  // ---------------------------------------------------------------------------
  // Brand — red
  // ---------------------------------------------------------------------------

  /// The brand red: primary buttons, active hearts, the refresh spinner.
  static const Color primaryRed = Color(0xFFFF0D0D);

  /// Edit-profile's save affordance.
  static const Color redSave = Color(0xFFFF0A0A);

  /// Login links, the remember-me tick and the form toggle.
  static const Color redLink = Color(0xFFFF1717);

  /// Header accents on profile and edit profile.
  static const Color redAction = Color(0xFFFF2D2D);

  /// The deeper red the product details headings use.
  static const Color redHeading = Color(0xFFD7262E);

  /// OTP resend and pin accents.
  static const Color redOtp = Color(0xFFD62828);

  /// The guest profile header.
  static const Color redGuest = Color(0xFFD72626);

  /// Error copy under the OTP pin.
  static const Color redError = Color(0xFFB42318);

  /// A focused underline on [CustomAppTextField].
  static const Color redFieldFocus = Color(0xFFB71C1C);

  static const Color lightPink = Color(0xFFF8B7B7);

  // ---------------------------------------------------------------------------
  // Warm tints — the pale fills behind red and amber content
  // ---------------------------------------------------------------------------

  static const Color redTintLightest = Color(0xFFFFF5F5);
  static const Color redTintPink = Color(0xFFFFF1F2);

  /// Behind the wishlist's remove button.
  static const Color redTintSurface = Color(0xFFFFF1F1);

  static const Color redTintBorder = Color(0xFFFECDD3);

  /// The quick-action and drawer cards.
  static const Color redTintCard = Color(0xFFFDEBEC);

  /// Home's offer tabs.
  static const Color peachTint = Color(0xFFFCEEE8);
  static const Color peachBorder = Color(0xFFF8DCD2);

  // ---------------------------------------------------------------------------
  // Accents
  // ---------------------------------------------------------------------------

  /// In-stock ticks and the add-to-basket confirmation.
  static const Color successGreen = Color(0xFF43A047);

  /// Points and reward copy.
  static const Color amber = Color(0xFFE07C00);

  /// Behind the goals section and the wide info card.
  static const Color goldTint = Color(0xFFF9F3E6);

  /// The offer tabs' muted label.
  static const Color taupe = Color(0xFFB98B7B);

  /// Behind one of the home quick actions.
  static const Color violetTint = Color(0xFFF3F0FF);

  // ---------------------------------------------------------------------------
  // Order status chip — background/text pairs
  // ---------------------------------------------------------------------------

  static const Color statusPendingBg = Color(0xFFFFF3CD);
  static const Color statusPendingText = Color(0xFF856404);

  static const Color statusProcessingBg = Color(0xFFD1ECF1);
  static const Color statusProcessingText = Color(0xFF0C5460);

  static const Color statusCompleteBg = Color(0xFFD4EDDA);
  static const Color statusCompleteText = Color(0xFF155724);

  static const Color statusCanceledBg = Color(0xFFF8D7DA);
  static const Color statusCanceledText = Color(0xFF721C24);

  static const Color statusDefaultBg = Color(0xFFE9ECEF);
  static const Color statusDefaultText = Color(0xFF495057);

  // ---------------------------------------------------------------------------
  // Text and icons — darkest to lightest
  // ---------------------------------------------------------------------------

  /// Bottom bar's selected label.
  static const Color textNearBlack = Color(0xFF1F1F1F);

  /// OTP phone header.
  static const Color textSlateDark = Color(0xFF1F2A37);

  /// The OTP pin digits.
  static const Color textSlate = Color(0xFF1F2937);

  /// Icons on the product details header and image rail.
  static const Color textInk = Color(0xFF202020);

  /// Profile info-row labels.
  static const Color textCharcoal = Color(0xFF2A2A2A);

  /// Product details body copy.
  static const Color textGraphite = Color(0xFF2C2C2C);

  /// The guest profile header's name.
  static const Color textGuestName = Color(0xFF2D2D2D);

  /// Default body text.
  static const Color textPrimary = Color(0xFF2E3142);

  /// The guest action cards' titles.
  static const Color textIron = Color(0xFF2F2F2F);

  /// What a search label falls back to when the backend sends no text colour.
  static const Color textLabelFallback = Color(0xFF34323C);

  /// Description and rating copy.
  static const Color textBody = Color(0xFF3A3A3A);

  /// [CustomAppTextField]'s hint.
  static const Color hintField = Color(0xFF3A3A4A);

  /// Text on the discount strip.
  static const Color strongGrey = Color(0xFF3B3B3B);

  /// Product details info-row values.
  static const Color textInfoValue = Color(0xFF3E3E3E);

  /// The home card's secondary copy, and the drawer's items.
  static const Color textMuted = Color(0xFF4A4A4A);

  /// Login form field labels.
  static const Color textFormLabel = Color(0xFF4F4F4F);

  /// The guest profile subtitle.
  static const Color textGuestSubtitle = Color(0xFF5A4A4A);

  /// An unselected login tab.
  static const Color textTabInactive = Color(0xFF5E5E5E);

  /// The OTP phone header's secondary line.
  static const Color textSlateMuted = Color(0xFF6B7280);

  /// Rating counts.
  static const Color textRatingMuted = Color(0xFF6F6F6F);

  /// Field labels on edit profile, login and the profile header.
  static const Color textFieldLabel = Color(0xFF7A7A7A);

  /// The pencil on the profile info card.
  static const Color iconEdit = Color(0xFF8A8A8A);

  /// Product details info-row labels.
  static const Color textInfoMuted = Color(0xFF8B8B8B);

  /// Captions under descriptions, ratings and profile menu items.
  static const Color textCaption = Color(0xFF8C8C8C);

  /// The guest profile body's caption.
  static const Color textGuestCaption = Color(0xFF8D8D8D);

  /// An unset favourite heart, and other muted trailing icons.
  static const Color iconMuted = Color(0xFF8E8E8E);

  /// Empty field values on profile and edit profile.
  static const Color textPlaceholder = Color(0xFF9A9A9A);

  /// The OTP resend countdown.
  static const Color textSlateLight = Color(0xFF9CA3AF);

  /// Secondary body text.
  static const Color textSecondary = Color(0xFF9E9E9E);

  /// The glyphs on the guest action cards.
  static const Color iconGuestCard = Color(0xFFA7A7A7);

  /// Disabled field text.
  static const Color textDisabled = Color(0xFFB0B0B0);

  /// Edit-profile hints.
  static const Color textHint = Color(0xFFB9B9B9);

  /// The flat grey the out-of-stock banner is filled with, and struck-through
  /// prices on the home card.
  static const Color unavailableGrey = Color(0xFFBDBDBD);

  /// A section header's "more ›".
  static const Color textSectionAction = Color(0xFFC4C4C4);

  /// An unselected bottom-bar icon.
  static const Color iconNavInactive = Color(0xFFC6C6C6);

  /// The home card's unset heart.
  static const Color iconFavoriteInactive = Color(0xFFC8C8C8);

  /// An idle underline on [CustomAppTextField].
  static const Color borderField = Color(0xFFCFCFCF);

  /// Icon or label colour once a control is disabled.
  static const Color disabledGrey = Color(0xFFD0D0D0);

  // ---------------------------------------------------------------------------
  // Borders and dividers — darkest to lightest
  // ---------------------------------------------------------------------------

  /// The default outline: fields, chips, steppers.
  static const Color border = Color(0xFFD9D9D9);

  /// An unselected gallery thumbnail.
  static const Color borderThumbnail = Color(0xFFE0E0E0);

  /// Around the home card's stepper.
  static const Color borderStepper = Color(0xFFE1E1E1);

  /// Between product details info rows.
  static const Color borderInfoRow = Color(0xFFE3E3E3);

  /// Under the product details header.
  static const Color borderHeader = Color(0xFFE5E5E5);

  /// Around the small square buttons.
  static const Color borderButton = Color(0xFFE6E6E6);

  /// Above the bottom action bar.
  static const Color borderAction = Color(0xFFE7E7E7);

  /// Around an unselected offer tab.
  static const Color borderOfferTab = Color(0xFFE8E8E8);

  /// Hairline rules between sections.
  static const Color divider = Color(0xFFE9E9E9);

  /// Hairline around cards and the small square icon buttons.
  static const Color borderLight = Color(0xFFEAEAEA);

  /// Around a wishlist row.
  static const Color borderWishlist = Color(0xFFECECEC);

  /// The warmer hairline the home cards use, the discount strip's fill, and
  /// the shimmer's base.
  static const Color borderSoft = Color(0xFFEDEDED);

  // ---------------------------------------------------------------------------
  // Surfaces — the pale fills, darkest to lightest
  // ---------------------------------------------------------------------------

  /// Disabled control fills, and the profile edit circle.
  static const Color surfaceGrey = Color(0xFFF0F0F0);

  /// The filled search box, OTP pins and login toggle.
  static const Color surfaceField = Color(0xFFF1F1F1);

  /// The edit-profile page.
  static const Color surfacePage = Color(0xFFF2F2F2);

  /// Behind a missing image.
  static const Color surfacePlaceholder = Color(0xFFF3F3F3);

  /// Login, OTP and the product details header.
  static const Color surfaceLight = Color(0xFFF5F5F5);

  /// The floating action buttons over a product image.
  static const Color surfaceAction = Color(0xFFF6F6F6);

  /// Fill behind a disabled stepper button, and several page backgrounds.
  static const Color surfaceMuted = Color(0xFFF7F7F7);

  /// The scaffold behind home, brands, categories and the layout shell — and
  /// the shimmer's highlight.
  static const Color surfaceScaffold = Color(0xFFF8F8F8);
}
