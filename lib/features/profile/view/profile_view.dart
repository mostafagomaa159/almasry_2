part of '../profile_imports.dart';

class ProfileView extends StatefulWidget {
  final ProfileArgs? args;

  const ProfileView({super.key, this.args});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileViewModel vm;

  @override
  void initState() {
    super.initState();
    vm = ProfileViewModel(args: widget.args);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vm._initLanguage(context);
  }

  @override
  void dispose() {
    vm._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GenericCubit<ProfileData>>.value(
      value: vm._profileCubit,
      child: BlocBuilder<GenericCubit<ProfileData>, GenericState<ProfileData>>(
        builder: (context, state) {
          final data = vm._data;

          if (data.isGuest) {
            return GuestProfileView(
              key: ValueKey('guest_${data.currentLanguageCode}'),
              vm: vm,
            );
          }

          return AccountProfileView(
            key: ValueKey('account_${data.currentLanguageCode}'),
            vm: vm,
          );
        },
      ),
    );
  }
}
