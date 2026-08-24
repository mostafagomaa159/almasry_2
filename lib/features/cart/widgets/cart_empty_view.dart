part of '../cart_imports.dart';

/// The empty cart: the pharmacy logo over a single line. Deliberately not
/// `CustomAppEmptyView` — the design uses the brand mark rather than an icon.
class CartEmptyView extends StatelessWidget {
  const CartEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            AppLogo.asset(context),
            width: 220.w,
            fit: BoxFit.contain,
          ),

          24.verticalSpace,

          Text(
            LocaleKeys.cartEmpty.tr(),
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}
