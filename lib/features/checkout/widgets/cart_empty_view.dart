part of '../checkout_imports.dart';

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
