part of '../checkout_shipping_imports.dart';

/// One saved address.
///
/// The red border marks the card the cart is quoted against; the corner ribbon
/// marks the address flagged default in the book. They usually coincide,
/// because the default is what the screen preselects.
///
/// The default address has no delete button: removing it would leave the book
/// with nothing flagged.
class CheckoutAddressCard extends StatelessWidget {
  final CheckoutShippingViewModel vm;
  final AddressModel address;
  final bool isSelected;

  const CheckoutAddressCard({
    super.key,
    required this.vm,
    required this.address,
    required this.isSelected,
  });

  static const Color _labelColor = AppColors.darkBlue;
  static const Color _valueColor = Color(0xFF7C7C7C);

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(12.r);

    return InkWell(
      onTap: () => vm._selectAddress(address),
      borderRadius: radius,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : const Color(0xFFDDDDDD),
            width: isSelected ? 1.6 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _row(
                            LocaleKeys.checkoutPhoneLabel.tr(),
                            address.fullPhone,
                          ),
                          8.verticalSpace,
                          _row(
                            LocaleKeys.checkoutCityLabel.tr(),
                            address.cityLine,
                          ),
                          8.verticalSpace,
                          _row(
                            LocaleKeys.checkoutAddressLabel.tr(),
                            address.summaryLine,
                          ),
                        ],
                      ),
                    ),

                    8.horizontalSpace,

                    Column(
                      children: <Widget>[
                        if (!address.isDefault) ...<Widget>[
                          _CardIconButton(
                            icon: Icons.delete_outline,
                            color: AppColors.primaryRed,
                            onTap: () => vm._deleteAddress(address),
                          ),
                          10.verticalSpace,
                        ],
                        _CardIconButton(
                          icon: Icons.edit_outlined,
                          color: const Color(0xFF2C2C2C),
                          onTap: () => vm._editAddress(address),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (address.isDefault)
                PositionedDirectional(end: 0, top: 0, child: _defaultRibbon()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: _labelColor,
          ),
        ),

        6.horizontalSpace,

        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: _valueColor,
            ),
          ),
        ),
      ],
    );
  }

  /// A rotated banner clipped by the card's rounded corner, which is how the
  /// design draws it.
  Widget _defaultRibbon() {
    return Transform.rotate(
      angle: 0.785398,
      alignment: Alignment.topRight,
      child: Container(
        width: 130.w,
        padding: EdgeInsets.symmetric(vertical: 4.h),
        color: AppColors.primaryRed,
        alignment: Alignment.center,
        child: Text(
          LocaleKeys.checkoutDefaultAddress.tr(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _CardIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CardIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 42.w,
        height: 42.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFF3F3F3),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 20.sp, color: color),
      ),
    );
  }
}
