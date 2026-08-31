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
    return BlocProvider<GenericCubit<String>>.value(
      value: vm._languageCodeCubit,
      child: BlocBuilder<GenericCubit<String>, GenericState<String>>(
        builder: (context, state) {
          final String languageCode = vm._languageCode();

          if (vm._isGuest) {
            return GuestProfileView(
              key: ValueKey('guest_$languageCode'),
              vm: vm,
            );
          }

          return AccountProfileView(
            key: ValueKey('account_$languageCode'),
            vm: vm,
          );
        },
      ),
    );
  }
}
