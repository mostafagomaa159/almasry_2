part of '../profile_imports.dart';

class ProfileArgs {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final bool isGuest;
  final String source;
  final String? gender;
  final String? birthDate;
  final String? hasPregnancy;
  final String? chronicDisease;
  final String? diseaseType;

  const ProfileArgs({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.isGuest = false,
    this.gender,
    this.birthDate,
    this.hasPregnancy,
    this.chronicDisease,
    this.diseaseType,
    required this.source,
  });
}

class ProfileView extends StatefulWidget {
  final ProfileArgs? args;

  const ProfileView({
    super.key,
    this.args,
  });

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
  void dispose() {
    viewModel.dispose();
    super.dispose();
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
