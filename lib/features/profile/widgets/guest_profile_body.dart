part of '../profile_imports.dart';

class GuestProfileBody extends StatelessWidget {
  final ProfileViewModel vm;

  const GuestProfileBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 22.h),
      child: Column(
        children: [
          Image.asset(
            AppImages.startWithPharmacy,
            width: double.infinity,
            height: 250.h,
            fit: BoxFit.contain,
          ),
          24.verticalSpace,
          Text(
            LocaleKeys.guestStartWithPharmacy.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.sp,
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0A3152),
            ),
          ),
          28.verticalSpace,
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              onPressed: vm._goToLogin,
              child: Text(
                LocaleKeys.start.tr(),
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          56.verticalSpace,
          Row(
            children: [
              Expanded(
                child: GuestActionCard(
                  icon: Icons.translate,
                  title: LocaleKeys.changeLanguage.tr(),
                  onTap: () => vm._toggleLanguage(context),
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: GuestActionCard(
                  icon: Icons.favorite,
                  title: LocaleKeys.wishlist.tr(),
                  onTap: vm._openWishlist,
                ),
              ),
            ],
          ),
          28.verticalSpace,
          BlocBuilder<GenericCubit<String>, GenericState<String>>(
            bloc: vm._appVersionCubit,
            builder: (context, state) {
              final appVersion = state.data;

              return Text(
                '${LocaleKeys.appVersion.tr()} ${appVersion.isEmpty ? '...' : appVersion}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFF8D8D8D),
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
