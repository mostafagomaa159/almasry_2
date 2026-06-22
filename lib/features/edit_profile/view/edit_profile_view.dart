part of '../edit_profile_imports.dart';



class EditProfileView extends StatefulWidget {
  final EditProfileArgs? args;

  const EditProfileView({
    super.key,
    this.args,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final EditProfileViewModel viewModel;

  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController birthDateController;
  late final TextEditingController diseaseTypeController;

  @override
  void initState() {
    super.initState();

    viewModel = EditProfileViewModel();
    viewModel.initialize(widget.args);

    final data = viewModel.editProfileCubit.state.data;

    firstNameController = TextEditingController(text: data.firstName);
    lastNameController = TextEditingController(text: data.lastName);
    emailController = TextEditingController(text: data.email);
    phoneController = TextEditingController(text: data.phone);
    birthDateController = TextEditingController(text: data.birthDate);
    diseaseTypeController = TextEditingController(text: data.diseaseType);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthDateController.dispose();
    diseaseTypeController.dispose();
    viewModel.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1940),
      lastDate: now,
    );

    if (picked != null) {
      final String formatted =
          '${picked.day.toString().padLeft(2, '0')}/'
          '${picked.month.toString().padLeft(2, '0')}/'
          '${picked.year}';

      birthDateController.text = formatted;
      viewModel.updateBirthDate(formatted);
    }
  }

  List<DropdownMenuItem<String>> _yesNoItems(BuildContext context) {
    return [
      DropdownMenuItem(value: 'yes', child: Text(LocaleKeys.yes.tr())),
      DropdownMenuItem(value: 'no', child: Text(LocaleKeys.no.tr())),
    ];
  }

  List<DropdownMenuItem<String>> _genderItems(BuildContext context) {
    return [
      DropdownMenuItem(value: 'male', child: Text(LocaleKeys.male.tr())),
      DropdownMenuItem(value: 'female', child: Text(LocaleKeys.female.tr())),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GenericCubit<EditProfileModel>>.value(
      value: viewModel.editProfileCubit,
      child: BlocConsumer<
          GenericCubit<EditProfileModel>,
          GenericState<EditProfileModel>>(
        listener: (context, state) {
          final data = state.data;

          if (data.saveSuccess) {
            context.pop(
              EditProfileArgs(
                firstName: data.firstName,
                lastName: data.lastName,
                email: data.email,
                phone: data.phone,
                gender: data.gender,
                birthDate: data.birthDate,
                hasPregnancy: data.hasPregnancy,
                chronicDisease: data.chronicDisease,
                diseaseType: data.diseaseType,
              ),
            );
          }
        },
        builder: (context, state) {
          final data = state.data;

          return Scaffold(
            backgroundColor: const Color(0xFFF2F2F2),
            body: SafeArea(
              child: Column(
                children: [
                  EditProfileHeader(onBackTap: () => context.pop()),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Column(
                        children: [
                          SizedBox(height: 22.h),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Text(
                              LocaleKeys.editAccount.tr(),
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF17375E),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              Expanded(
                                child: EditProfileTextField(
                                  label: LocaleKeys.lastName.tr(),
                                  hintText: LocaleKeys.lastName.tr(),
                                  controller: lastNameController,
                                  textAlign: TextAlign.end,
                                  onChanged: viewModel.updateLastName,
                                ),
                              ),
                              SizedBox(width: 34.w),
                              Expanded(
                                child: EditProfileTextField(
                                  label: LocaleKeys.firstName.tr(),
                                  hintText: LocaleKeys.firstName.tr(),
                                  controller: firstNameController,
                                  textAlign: TextAlign.end,
                                  onChanged: viewModel.updateFirstName,
                                ),
                              ),
                            ],
                          ),
                          EditProfileTextField(
                            label: LocaleKeys.email.tr(),
                            hintText: LocaleKeys.email.tr(),
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.end,
                            onChanged: viewModel.updateEmail,
                          ),
                          EditProfileTextField(
                            label: LocaleKeys.profilePhoneLabel.tr(),
                            hintText: LocaleKeys.profilePhoneLabel.tr(),
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.end,
                            onChanged: viewModel.updatePhone,
                          ),
                          EditProfileTextField(
                            label: LocaleKeys.profileBirthDateLabel.tr(),
                            hintText: 'dd/mm/yyyy',
                            controller: birthDateController,
                            readOnly: true,
                            textAlign: TextAlign.end,
                            onTap: _selectBirthDate,
                            onChanged: (_) {},
                          ),
                          EditProfileDropdownField(
                            label: LocaleKeys.profileGenderLabel.tr(),
                            hintText: LocaleKeys.choose.tr(),
                            value: data.gender.isEmpty ? null : data.gender,
                            items: _genderItems(context),
                            onChanged: (value) {
                              viewModel.updateGender(value ?? '');
                            },
                          ),
                          EditProfileDropdownField(
                            label: LocaleKeys.profilePregnancyLabel.tr(),
                            hintText: LocaleKeys.choose.tr(),
                            value: data.hasPregnancy.isEmpty
                                ? null
                                : data.hasPregnancy,
                            items: _yesNoItems(context),
                            onChanged: (value) {
                              viewModel.updateHasPregnancy(value ?? '');
                            },
                          ),
                          EditProfileDropdownField(
                            label: LocaleKeys.profileChronicDiseaseLabel.tr(),
                            hintText: LocaleKeys.choose.tr(),
                            value: data.chronicDisease.isEmpty
                                ? null
                                : data.chronicDisease,
                            items: _yesNoItems(context),
                            onChanged: (value) {
                              viewModel.updateChronicDisease(value ?? '');
                            },
                          ),
                          EditProfileTextField(
                            label: LocaleKeys.diseaseType.tr(),
                            hintText: '',
                            controller: diseaseTypeController,
                            textAlign: TextAlign.end,
                            onChanged: viewModel.updateDiseaseType,
                          ),
                          SizedBox(height: 26.h),
                          Center(
                            child: EditProfileSaveButton(
                              title: LocaleKeys.save.tr(),
                              isLoading: data.isSaving,
                              onTap: viewModel.saveProfile,
                            ),
                          ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
