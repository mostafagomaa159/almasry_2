part of '../checkout_shipping_imports.dart';

/// The "Shipping Address" block: the header with its add link, the address
/// cards, and the show-all toggle.
///
/// Listens to `AddressBookService` directly, so saving from the address form
/// lands here without this screen having to re-read anything on pop.
class CheckoutShippingAddressSection extends StatelessWidget {
  final CheckoutShippingViewModel vm;

  const CheckoutShippingAddressSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<List<AddressModel>>,
      GenericState<List<AddressModel>>
    >(
      bloc: vm._addressesCubit,
      builder: (BuildContext context, GenericState<List<AddressModel>> state) {
        final List<AddressModel> all = state.data;
        final List<AddressModel> visible = vm._visibleAddresses;

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
                  isSelected: address.id == vm._data.selectedAddressId,
                ),
                14.verticalSpace,
              ],

            // One card is already on screen, so the toggle only earns its place
            // once there is a second one to reveal.
            if (all.length > 1)
              Center(
                child: InkWell(
                  onTap: vm._toggleShowAllAddresses,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      vm._data.showAllAddresses
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
      },
    );
  }
}
