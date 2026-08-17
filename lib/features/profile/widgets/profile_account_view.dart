part of '../profile_imports.dart';

class AccountProfileView extends StatefulWidget {
  final ProfileViewModel vm;

  const AccountProfileView({super.key, required this.vm});

  @override
  State<AccountProfileView> createState() => _AccountProfileViewState();
}

class _AccountProfileViewState extends State<AccountProfileView> {
  @override
  void initState() {
    super.initState();
    widget.vm._initAccount();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;

    return Container(
      color: AppColors.surfaceAction,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            ProfileHeader(onBackTap: vm._onBackTap),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    ProfileInfoCard(vm: vm),
                    20.verticalSpace,
                    ProfileMenuList(vm: vm),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
