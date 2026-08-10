part of '../profile_imports.dart';

class ProfileMenuList extends StatelessWidget {
  final ProfileViewModel vm;

  const ProfileMenuList({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(
          title: LocaleKeys.profileOrders.tr(),
          onTap: vm._openOrders,
        ),
        ProfileMenuItem(
          title: LocaleKeys.wishlist.tr(),
          onTap: vm._openWishlist,
        ),
        ProfileMenuItem(
          title: LocaleKeys.profilePaymentMethods.tr(),
          onTap: () {},
        ),
        ProfileMenuItem(title: LocaleKeys.profileNews.tr(), onTap: () {}),
        ProfileMenuItem(
          title: LocaleKeys.profilePointsProgram.tr(),
          onTap: () {},
        ),
        ProfileMenuItem(
          title: LocaleKeys.changeLanguage.tr(),
          onTap: () => vm._toggleLanguage(context),
        ),
        ProfileMenuItem(
          title: LocaleKeys.logOut.tr(),
          onTap: () => vm._logout(context),
        ),
      ],
    );
  }
}
