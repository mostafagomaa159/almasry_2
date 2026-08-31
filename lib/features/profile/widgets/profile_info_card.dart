part of '../profile_imports.dart';

class ProfileInfoCard extends StatelessWidget {
  final ProfileViewModel vm;

  const ProfileInfoCard({super.key, required this.vm});

  Widget _buildInfoRow({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15.sp,
                color: AppColors.textCharcoal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          8.horizontalSpace,
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.navyProfile,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<ProfileArgs>, GenericState<ProfileArgs>>(
      bloc: vm._currentProfileCubit,
      builder: (context, state) => _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    return CustomAppCard(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(18.w, 14.h, 18.w, 16.h),
      borderRadius: 22,
      shadowOpacity: 15 / 255,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                4.verticalSpace,
                Text(
                  vm._displayName(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navyProfile,
                  ),
                ),
                2.verticalSpace,
                Text(
                  vm._displayEmail(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textPlaceholder,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                18.verticalSpace,
                _buildInfoRow(
                  context: context,
                  label: LocaleKeys.profilePhoneLabel.tr(),
                  value: vm._displayPhone(),
                ),
                _buildInfoRow(
                  context: context,
                  label: LocaleKeys.profileGenderLabel.tr(),
                  value: vm._displayGender(),
                ),
                _buildInfoRow(
                  context: context,
                  label: LocaleKeys.profileBirthDateLabel.tr(),
                  value: vm._displayBirthDate(),
                ),
                _buildInfoRow(
                  context: context,
                  label: LocaleKeys.profilePregnancyLabel.tr(),
                  value: vm._displayPregnancy(),
                ),
                _buildInfoRow(
                  context: context,
                  label: LocaleKeys.profileChronicDiseaseLabel.tr(),
                  value: vm._displayChronicDisease(),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            top: 0,
            start: 0,
            child: InkWell(
              onTap: vm._openEditProfile,
              borderRadius: BorderRadius.circular(18.r),
              child: Container(
                width: 34.w,
                height: 34.w,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceGrey,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: 17.sp,
                  color: AppColors.iconEdit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
