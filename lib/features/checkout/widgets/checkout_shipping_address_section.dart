part of '../checkout_imports.dart';

class CheckoutShippingAddressSection extends StatelessWidget {
  final CheckoutViewModel vm;

  const CheckoutShippingAddressSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<ListAddresses>,
      GenericState<ListAddresses>
    >(
      bloc: vm._addressesCubit,
      builder: (BuildContext context, GenericState<ListAddresses> state) {
        return BlocBuilder<GenericCubit<String>, GenericState<String>>(
          bloc: vm._selectedAddressIdCubit,
          builder: (BuildContext context, GenericState<String> selectedState) {
            return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
              bloc: vm._showAllAddressesCubit,
              builder: (BuildContext context, GenericState<bool> showAll) {
                return _section(
                  all: state.data,
                  selectedId: selectedState.data,
                  showAllAddresses: showAll.data,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _section({
    required ListAddresses all,
    required String selectedId,
    required bool showAllAddresses,
  }) {
    final ListAddresses visible = vm._visibleAddresses();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                LocaleKeys.checkoutShippingAddress.tr(),
                style: TextStyle(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkBlue,
                ),
              ),
            ),

            InkWell(
              onTap: vm._addNewAddress,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  children: <Widget>[
                    Text(
                      LocaleKeys.checkoutAddNewAddress.tr(),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.add,
                      size: 20.sp,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        18.verticalSpace,

        if (all.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: CustomAppEmptyView(
              message: LocaleKeys.checkoutNoAddresses.tr(),
            ),
          )
        else
          for (final AddressModel address in visible) ...<Widget>[
            CheckoutAddressCard(
              vm: vm,
              address: address,
              isSelected: address.id == selectedId,
            ),
            14.verticalSpace,
          ],

        if (all.length > 1)
          Center(
            child: InkWell(
              onTap: vm._toggleShowAllAddresses,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  showAllAddresses
                      ? LocaleKeys.checkoutShowLessAddresses.tr()
                      : LocaleKeys.checkoutShowAllAddresses.tr(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlue,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
