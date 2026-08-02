part of '../profile_imports.dart';

class AccountProfileView extends StatefulWidget {
  final ProfileViewModel vm;

  const AccountProfileView({super.key, required this.vm});

  @override
  State<AccountProfileView> createState() => _AccountProfileViewState();
}

class _AccountProfileViewState extends State<AccountProfileView> {
  /// Stateful only so that a language change, which remounts this subtree with
  /// a new key, re-seeds the profile exactly as it did before.
  @override
  void initState() {
    super.initState();
    widget.vm._initAccount();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;

    return Container(
      color: const Color(0xFFF6F6F6),
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
                    SizedBox(height: 20.h),
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
