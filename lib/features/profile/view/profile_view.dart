part of '../profile_imports.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileArgs? args;

  const ProfileScreen({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(args: args)..initialize(context),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isGuest) {
            return GuestProfileView(
              key: ValueKey('guest_${state.currentLanguageCode}'),
              args: args,
            );
          }

          return AccountProfileView(
            key: ValueKey('account_${state.currentLanguageCode}'),
            args: args,
          );
        },
      ),
    );
  }
}
