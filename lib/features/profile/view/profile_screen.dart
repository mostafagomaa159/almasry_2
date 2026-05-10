import 'package:almasry_2/features/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
