part of '../profile_imports.dart';


class ProfileInfoCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String birthDate;
  final String hasPregnancy;
  final String chronicDisease;
  final VoidCallback onEditTap;

  const ProfileInfoCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.birthDate,
    required this.hasPregnancy,
    required this.chronicDisease,
    required this.onEditTap,
  });

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
                color: const Color(0xFF2A2A2A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF17375E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(18.w, 14.h, 18.w, 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 4.h),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF17375E),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF9A9A9A),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 18.h),
                _buildInfoRow(
                  context: context,
                  label: LocaleKeys.profilePhoneLabel.tr(),
                  value: phone,
                ),
                _buildInfoRow(
                  context: context,
                  label: LocaleKeys.profileGenderLabel.tr(),
                  value: gender.tr(),
                ),
                _buildInfoRow(
                  context: context,
                  label: LocaleKeys.profileBirthDateLabel.tr(),
                  value: birthDate.tr(),
                ),
                _buildInfoRow(
                  context: context,
                  label: LocaleKeys.profilePregnancyLabel.tr(),
                  value: hasPregnancy.tr(),
                ),
                _buildInfoRow(
                  context: context,
                  label: LocaleKeys.profileChronicDiseaseLabel.tr(),
                  value: chronicDisease.tr(),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            top: 0,
            start: 0,
            child: InkWell(
              onTap: onEditTap,
              borderRadius: BorderRadius.circular(18.r),
              child: Container(
                width: 34.w,
                height: 34.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: 17.sp,
                  color: const Color(0xFF8A8A8A),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
