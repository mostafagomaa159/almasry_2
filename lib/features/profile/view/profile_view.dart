part of '../profile_imports.dart';

class ProfileView extends StatefulWidget {
  final ProfileArgs? args;

  const ProfileView({super.key, this.args});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = ProfileViewModel(args: widget.args);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GenericCubit<ProfileData>>.value(
      value: viewModel.profileCubit,
      child: BlocBuilder<GenericCubit<ProfileData>, GenericState<ProfileData>>(
        builder: (context, state) {
          final data = state.data;

          if (data.isGuest) {
            return GuestProfileView(
              key: ValueKey('guest_${data.currentLanguageCode}'),
              args: widget.args,
              viewModel: viewModel,
            );
          }

          return AccountProfileView(
            key: ValueKey('account_${data.currentLanguageCode}'),
            args: widget.args,
            viewModel: viewModel,
          );
        },
      ),
    );

  }
}
