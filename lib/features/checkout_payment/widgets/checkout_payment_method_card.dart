part of '../checkout_payment_imports.dart';

class CheckoutPaymentMethodCard extends StatelessWidget {
  final CheckoutPaymentViewModel vm;
  final PaymentMethodModel method;

  const CheckoutPaymentMethodCard({
    super.key,
    required this.vm,
    required this.method,
  });

  static const Color _titleColor = Color(0xFF2C2C2C);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<String>, GenericState<String>>(
      bloc: vm._selectedCodeCubit,
      builder: (BuildContext context, GenericState<String> selectedState) {
        return BlocBuilder<GenericCubit<String>, GenericState<String>>(
          bloc: vm._expandedCodeCubit,
          builder: (BuildContext context, GenericState<String> expandedState) {
            return _card(
              isSelected: selectedState.data == method.code,
              isExpanded: expandedState.data == method.code,
            );
          },
        );
      },
    );
  }

  Widget _card({required bool isSelected, required bool isExpanded}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () => vm._selectMethod(method),
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      if (method.hasOptions)
                        InkWell(
                          onTap: () => vm._toggleExpanded(method),
                          customBorder: const CircleBorder(),
                          child: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 26.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 24.sp,
                        color: isSelected
                            ? _titleColor
                            : AppColors.textSecondary,
                      ),
                    ],
                  ),

                  14.horizontalSpace,

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          method.title.trim().isEmpty
                              ? method.code
                              : method.title,
                          style: TextStyle(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? _titleColor
                                : AppColors.textSecondary,
                          ),
                        ),

                        6.verticalSpace,

                        Text(
                          vm._hintFor(method),
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  10.horizontalSpace,

                  Icon(
                    vm._iconFor(method),
                    size: 34.sp,
                    color: const Color(0xFF3B3B3B),
                  ),
                ],
              ),
            ),
          ),

          if (method.hasOptions && isExpanded)
            BlocBuilder<GenericCubit<String>, GenericState<String>>(
              bloc: vm._selectedOptionCubit,
              builder: (BuildContext context, GenericState<String> state) {
                return _options(
                  isMethodSelected: isSelected,
                  selectedOptionCode: state.data,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _options({
    required bool isMethodSelected,
    required String selectedOptionCode,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        children: <Widget>[
          Divider(height: 1.h, color: const Color(0xFFEDEDED)),
          for (final PaymentOptionModel option in method.options)
            _OptionRow(
              option: option,
              isSelected: isMethodSelected && selectedOptionCode == option.code,
              onTap: () => vm._selectOption(method, option),
            ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  final PaymentOptionModel option;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionRow({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 10.h, 14.w, 10.h),
        child: Row(
          children: <Widget>[
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              size: 20.sp,
              color: isSelected
                  ? AppColors.primaryRed
                  : AppColors.textSecondary,
            ),

            12.horizontalSpace,

            Expanded(
              child: Text(
                option.name.trim().isEmpty ? option.code : option.name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: const Color(0xFF3B3B3B),
                ),
              ),
            ),

            if (option.logo.trim().isNotEmpty)
              SizedBox(
                width: 44.w,
                height: 28.h,
                child: CustomAppNetworkImage(
                  url: option.logo,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
