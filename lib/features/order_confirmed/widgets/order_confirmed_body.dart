part of '../order_confirmed_imports.dart';

class OrderConfirmedBody extends StatelessWidget {
  final OrderConfirmedViewModel vm;

  const OrderConfirmedBody({super.key, required this.vm});

  static const Color _successGreen = Color(0xFF3EA96B);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 40.h, 20.w, 32.h),
      children: <Widget>[
        const Center(child: OrderConfirmedIllustration()),

        32.verticalSpace,

        Text(
          '${LocaleKeys.orderConfirmedTitle.tr()} 👍💊',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w700,
            color: _successGreen,
          ),
        ),

        24.verticalSpace,

        Text(
          LocaleKeys.orderConfirmedNumber.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBlue,
          ),
        ),

        18.verticalSpace,

        OrderConfirmedCard(vm: vm),

        26.verticalSpace,

        CustomAppButton(
          title: LocaleKeys.orderConfirmedTrack.tr(),
          onPressed: vm._openOrders,
          borderRadius: 10,
        ),

        14.verticalSpace,

        CustomAppButton(
          title: LocaleKeys.orderConfirmedBackToMain.tr(),
          onPressed: vm._backToMain,
          borderRadius: 10,
        ),
      ],
    );
  }
}
