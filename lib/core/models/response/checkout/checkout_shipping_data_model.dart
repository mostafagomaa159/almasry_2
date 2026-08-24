part of '../../../../features/checkout_shipping/checkout_shipping_imports.dart';

/// [CheckoutShippingStatus.initial] is the screen with no address chosen yet —
/// not an error, and not the same as [CheckoutShippingStatus.success] with an
/// empty method list, which means nobody delivers there.
enum CheckoutShippingStatus { initial, loading, success, error }

class CheckoutShippingData extends Equatable {
  final CheckoutShippingStatus status;

  /// The address the cart is being quoted for. Empty before one is picked, and
  /// before the address book has finished loading.
  final String selectedAddressId;

  /// Collapsed, the design shows only the chosen card behind a
  /// "Show all addresses" link.
  final bool showAllAddresses;

  final List<ShippingMethodModel> methods;

  /// `carrier_code|method_code` — see `ShippingMethodModel.key`.
  final String selectedMethodKey;

  /// True while the address is being pushed onto the cart and its methods
  /// re-quoted, which is one visible step even though it is three calls.
  final bool isApplyingAddress;

  final bool isSettingMethod;
  final String errorMessage;

  /// True once `setGuestEmailOnCart` has landed. `placeOrder` refuses a cart
  /// without it, so this is checked before leaving the step rather than three
  /// screens later.
  final bool isEmailReady;

  /// Why the email could not be set, when Magento gave a reason. Empty means
  /// "there simply isn't one on the account".
  final String emailErrorMessage;

  const CheckoutShippingData({
    this.status = CheckoutShippingStatus.initial,
    this.selectedAddressId = '',
    this.showAllAddresses = false,
    this.methods = const [],
    this.selectedMethodKey = '',
    this.isApplyingAddress = false,
    this.isSettingMethod = false,
    this.errorMessage = '',
    this.isEmailReady = false,
    this.emailErrorMessage = '',
  });

  CheckoutShippingData copyWith({
    CheckoutShippingStatus? status,
    String? selectedAddressId,
    bool? showAllAddresses,
    List<ShippingMethodModel>? methods,
    String? selectedMethodKey,
    bool? isApplyingAddress,
    bool? isSettingMethod,
    String? errorMessage,
    bool? isEmailReady,
    String? emailErrorMessage,
    bool clearErrorMessage = false,
    bool clearSelectedMethod = false,
    bool clearEmailError = false,
  }) {
    return CheckoutShippingData(
      status: status ?? this.status,
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      showAllAddresses: showAllAddresses ?? this.showAllAddresses,
      methods: methods ?? this.methods,
      selectedMethodKey: clearSelectedMethod
          ? ''
          : (selectedMethodKey ?? this.selectedMethodKey),
      isApplyingAddress: isApplyingAddress ?? this.isApplyingAddress,
      isSettingMethod: isSettingMethod ?? this.isSettingMethod,
      errorMessage: clearErrorMessage
          ? ''
          : (errorMessage ?? this.errorMessage),
      isEmailReady: isEmailReady ?? this.isEmailReady,
      emailErrorMessage: clearEmailError
          ? ''
          : (emailErrorMessage ?? this.emailErrorMessage),
    );
  }

  bool get isBusy => isApplyingAddress || isSettingMethod;

  bool get hasAddress => selectedAddressId.trim().isNotEmpty;

  bool get hasMethod => selectedMethodKey.trim().isNotEmpty;

  @override
  List<Object?> get props => [
    status,
    selectedAddressId,
    showAllAddresses,
    methods,
    selectedMethodKey,
    isApplyingAddress,
    isSettingMethod,
    errorMessage,
    isEmailReady,
    emailErrorMessage,
  ];
}
