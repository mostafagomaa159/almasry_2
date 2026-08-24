part of '../../../../features/checkout_payment/checkout_payment_imports.dart';

enum CheckoutPaymentStatus { loading, success, error }

class CheckoutPaymentData extends Equatable {
  final CheckoutPaymentStatus status;
  final List<PaymentMethodModel> methods;

  /// The Magento payment method `code`.
  final String selectedCode;

  /// The sub-option code, for the methods that carry a list of providers.
  /// Empty for the ones that do not.
  final String selectedOptionCode;

  /// Which expandable row is open. Independent of the selection: the design
  /// lets a row be opened to look at its providers without choosing it.
  final String expandedCode;

  final bool isSubmitting;
  final String errorMessage;

  const CheckoutPaymentData({
    this.status = CheckoutPaymentStatus.loading,
    this.methods = const [],
    this.selectedCode = '',
    this.selectedOptionCode = '',
    this.expandedCode = '',
    this.isSubmitting = false,
    this.errorMessage = '',
  });

  CheckoutPaymentData copyWith({
    CheckoutPaymentStatus? status,
    List<PaymentMethodModel>? methods,
    String? selectedCode,
    String? selectedOptionCode,
    String? expandedCode,
    bool? isSubmitting,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearSelectedOption = false,
    bool clearExpanded = false,
  }) {
    return CheckoutPaymentData(
      status: status ?? this.status,
      methods: methods ?? this.methods,
      selectedCode: selectedCode ?? this.selectedCode,
      selectedOptionCode: clearSelectedOption
          ? ''
          : (selectedOptionCode ?? this.selectedOptionCode),
      expandedCode: clearExpanded ? '' : (expandedCode ?? this.expandedCode),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearErrorMessage
          ? ''
          : (errorMessage ?? this.errorMessage),
    );
  }

  PaymentMethodModel? get selectedMethod {
    for (final PaymentMethodModel method in methods) {
      if (method.code == selectedCode) return method;
    }

    return null;
  }

  /// A method with providers is not a complete choice until one is picked, so
  /// the button stays inert until then.
  bool get canProceed {
    final PaymentMethodModel? method = selectedMethod;

    if (method == null) return false;

    return !method.hasOptions || selectedOptionCode.trim().isNotEmpty;
  }

  @override
  List<Object?> get props => [
    status,
    methods,
    selectedCode,
    selectedOptionCode,
    expandedCode,
    isSubmitting,
    errorMessage,
  ];
}
