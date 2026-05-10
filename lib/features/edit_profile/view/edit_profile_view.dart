import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/features/edit_profile/edit_profile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController birthDateController;
  late final TextEditingController diseaseTypeController;

  @override
  void initState() {
    super.initState();
    final state = context.read<EditProfileCubit>().state;

    firstNameController = TextEditingController(text: state.firstName);
    lastNameController = TextEditingController(text: state.lastName);
    emailController = TextEditingController(text: state.email);
    phoneController = TextEditingController(text: state.phone);
    birthDateController = TextEditingController(text: state.birthDate);
    diseaseTypeController = TextEditingController(text: state.diseaseType);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthDateController.dispose();
    diseaseTypeController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate() async {
    final cubit = context.read<EditProfileCubit>();
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
      cubit.updateBirthDate(formatted);
    }
  }

  List<DropdownMenuItem<String>> _yesNoItems(BuildContext context) {
    return [
      DropdownMenuItem(
        value: 'yes',
        child: Text(LocaleKeys.yes.tr()),
      ),
      DropdownMenuItem(
        value: 'no',
        child: Text(LocaleKeys.no.tr()),
      ),
    ];
  }

  List<DropdownMenuItem<String>> _genderItems(BuildContext context) {
    return [
      DropdownMenuItem(
        value: 'male',
        child: Text(LocaleKeys.male.tr()),
      ),
      DropdownMenuItem(
        value: 'female',
        child: Text(LocaleKeys.female.tr()),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<EditProfileCubit, EditProfileState>(
      listener: (context, state) {
        if (state.saveSuccess) {
          context.pop(
            EditProfileArgs(
              firstName: state.firstName,
              lastName: state.lastName,
              email: state.email,
              phone: state.phone,
              gender: state.gender,
              birthDate: state.birthDate,
              hasPregnancy: state.hasPregnancy,
              chronicDisease: state.chronicDisease,
              diseaseType: state.diseaseType,
            ),
          );
        }
      },


      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F2F2),
          body: SafeArea(
            child: Column(
              children: [
                EditProfileHeader(
                  onBackTap: () => context.pop(),
                ),
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

                                onChanged: (value) {
                                  context
                                      .read<EditProfileCubit>()
                                      .updateLastName(value);
                                },
                              ),
                            ),
                            SizedBox(width: 34.w),
                            Expanded(
                              child: EditProfileTextField(
                                label: LocaleKeys.firstName.tr(),
                                hintText: LocaleKeys.firstName.tr(),
                                controller: firstNameController,
                                textAlign: TextAlign.end,

                                onChanged: (value) {
                                  context
                                      .read<EditProfileCubit>()
                                      .updateFirstName(value);
                                },
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

                          onChanged: (value) {
                            context.read<EditProfileCubit>().updateEmail(value);
                          },
                        ),
                        EditProfileTextField(
                          label: LocaleKeys.profilePhoneLabel.tr(),
                          hintText: LocaleKeys.profilePhoneLabel.tr(),
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          textAlign: TextAlign.end,

                          onChanged: (value) {
                            context.read<EditProfileCubit>().updatePhone(value);
                          },
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
                          value: state.gender.isEmpty ? null : state.gender,
                          items: _genderItems(context),
                          onChanged: (value) {
                            context
                                .read<EditProfileCubit>()
                                .updateGender(value ?? '');
                          },
                        ),
                        EditProfileDropdownField(
                          label: LocaleKeys.profilePregnancyLabel.tr(),
                          hintText: LocaleKeys.choose.tr(),
                          value: state.hasPregnancy.isEmpty
                              ? null
                              : state.hasPregnancy,
                          items: _yesNoItems(context),
                          onChanged: (value) {
                            context
                                .read<EditProfileCubit>()
                                .updateHasPregnancy(value ?? '');
                          },
                        ),
                        EditProfileDropdownField(
                          label: LocaleKeys.profileChronicDiseaseLabel.tr(),
                          hintText: LocaleKeys.choose.tr(),
                          value: state.chronicDisease.isEmpty
                              ? null
                              : state.chronicDisease,
                          items: _yesNoItems(context),
                          onChanged: (value) {
                            context
                                .read<EditProfileCubit>()
                                .updateChronicDisease(value ?? '');
                          },
                        ),
                        EditProfileTextField(
                          label: LocaleKeys.diseaseType.tr(),
                          hintText: '',
                          controller: diseaseTypeController,
                          textAlign: TextAlign.end,

                          onChanged: (value) {
                            context
                                .read<EditProfileCubit>()
                                .updateDiseaseType(value);
                          },
                        ),
                        SizedBox(height: 26.h),
                        Center(
                          child: EditProfileSaveButton(
                            title: LocaleKeys.save.tr(),
                            isLoading: state.isSaving,
                            onTap: () {
                              context.read<EditProfileCubit>().saveProfile();
                            },
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
    );
  }
}
