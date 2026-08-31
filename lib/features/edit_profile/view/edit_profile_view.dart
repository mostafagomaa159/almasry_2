part of '../edit_profile_imports.dart';

class EditProfileView extends StatefulWidget {
  final EditProfileArgs? args;

  const EditProfileView({super.key, this.args});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final EditProfileViewModel vm = EditProfileViewModel();

  @override
  void initState() {
    super.initState();
    vm._init(widget.args);
  }

  @override
  void dispose() {
    vm._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfacePage,
      body: SafeArea(
        child: Column(
          children: [
            EditProfileHeader(onBackTap: vm._goBack),
            Expanded(child: EditProfileForm(vm: vm)),
          ],
        ),
      ),
    );
  }
}
