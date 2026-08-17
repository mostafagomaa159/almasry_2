part of '../edit_profile_imports.dart';

class EditProfileForm extends StatelessWidget {
  final EditProfileViewModel vm;

  const EditProfileForm({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final data = vm._data;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        children: [
          22.verticalSpace,
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Text(
              LocaleKeys.editAccount.tr(),
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.navyProfile,
              ),
            ),
          ),
          24.verticalSpace,
          Row(
            children: [
              Expanded(
                child: EditProfileTextField(
                  label: LocaleKeys.lastName.tr(),
                  hintText: LocaleKeys.lastName.tr(),
                  controller: vm._lastNameController,
                  textAlign: TextAlign.end,
                  onChanged: vm._updateLastName,
                ),
              ),
              34.horizontalSpace,
              Expanded(
                child: EditProfileTextField(
                  label: LocaleKeys.firstName.tr(),
                  hintText: LocaleKeys.firstName.tr(),
                  controller: vm._firstNameController,
                  textAlign: TextAlign.end,
                  onChanged: vm._updateFirstName,
                ),
              ),
            ],
          ),
          EditProfileTextField(
            label: LocaleKeys.email.tr(),
            hintText: LocaleKeys.email.tr(),
            controller: vm._emailController,
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.end,
            onChanged: vm._updateEmail,
          ),
          EditProfileTextField(
            label: LocaleKeys.profilePhoneLabel.tr(),
            hintText: LocaleKeys.profilePhoneLabel.tr(),
            controller: vm._phoneController,
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.end,
            onChanged: vm._updatePhone,
          ),
          EditProfileTextField(
            label: LocaleKeys.profileBirthDateLabel.tr(),
            hintText: LocaleKeys.birthDateHint.tr(),
            controller: vm._birthDateController,
            readOnly: true,
            textAlign: TextAlign.end,
            onTap: () => vm._selectBirthDate(context),
            onChanged: (_) {},
          ),
          EditProfileDropdownField(
            label: LocaleKeys.profileGenderLabel.tr(),
            hintText: LocaleKeys.choose.tr(),
            value: data.gender.isEmpty ? null : data.gender,
            items: vm._genderItems(),
            onChanged: (value) {
              vm._updateGender(value ?? '');
            },
          ),
          EditProfileDropdownField(
            label: LocaleKeys.profilePregnancyLabel.tr(),
            hintText: LocaleKeys.choose.tr(),
            value: data.hasPregnancy.isEmpty ? null : data.hasPregnancy,
            items: vm._yesNoItems(),
            onChanged: (value) {
              vm._updateHasPregnancy(value ?? '');
            },
          ),
          EditProfileDropdownField(
            label: LocaleKeys.profileChronicDiseaseLabel.tr(),
            hintText: LocaleKeys.choose.tr(),
            value: data.chronicDisease.isEmpty ? null : data.chronicDisease,
            items: vm._yesNoItems(),
            onChanged: (value) {
              vm._updateChronicDisease(value ?? '');
            },
          ),
          EditProfileTextField(
            label: LocaleKeys.diseaseType.tr(),
            hintText: '',
            controller: vm._diseaseTypeController,
            textAlign: TextAlign.end,
            onChanged: vm._updateDiseaseType,
          ),
          26.verticalSpace,
          Center(
            child: CustomAppButton(
              title: LocaleKeys.save.tr(),
              isLoading: data.isSaving,
              onPressed: vm._saveProfile,
              width: 206.w,
              height: 49.h,
              backgroundColor: AppColors.redSave,
              borderColor: AppColors.redSave,
              borderRadius: 12,
              fontSize: 19,
              elevation: 4,
            ),
          ),
          30.verticalSpace,
        ],
      ),
    );
  }
}
