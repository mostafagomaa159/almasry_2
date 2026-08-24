part of '../profile_imports.dart';

class GuestProfileView extends StatefulWidget {
  final ProfileViewModel vm;

  const GuestProfileView({super.key, required this.vm});

  @override
  State<GuestProfileView> createState() => _GuestProfileViewState();
}

class _GuestProfileViewState extends State<GuestProfileView> {
  @override
  void initState() {
    super.initState();
    widget.vm._initGuest();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceMuted,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const ProfileGuestHeader(),
            Expanded(child: GuestProfileBody(vm: widget.vm)),
          ],
        ),
      ),
    );
  }
}
