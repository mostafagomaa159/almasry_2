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
    return BlocProvider<GenericCubit<EditProfileModel>>.value(
      value: vm._editProfileCubit,
      child:
          BlocConsumer<
            GenericCubit<EditProfileModel>,
            GenericState<EditProfileModel>
          >(
            listener: (context, state) => vm._onStateChanged(state.data),
            builder: (context, state) {
              return Scaffold(
                backgroundColor: const Color(0xFFF2F2F2),
                body: SafeArea(
                  child: Column(
                    children: [
                      EditProfileHeader(onBackTap: vm._goBack),
                      Expanded(child: EditProfileForm(vm: vm)),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
