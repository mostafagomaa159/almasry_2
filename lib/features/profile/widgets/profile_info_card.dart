import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF17375E),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              color: const Color(0xFF2A2A2A),
              fontWeight: FontWeight.w500,
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
      padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 16.h),
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
                  label: LocaleKeys.profilePhoneLabel.tr(),
                  value: phone,
                ),
                _buildInfoRow(
                  label: LocaleKeys.profileGenderLabel.tr(),
                  value: gender,
                ),
                _buildInfoRow(
                  label: LocaleKeys.profileBirthDateLabel.tr(),
                  value: birthDate,
                ),
                _buildInfoRow(
                  label: LocaleKeys.profilePregnancyLabel.tr(),
                  value: hasPregnancy,
                ),
                _buildInfoRow(
                  label: LocaleKeys.profileChronicDiseaseLabel.tr(),
                  value: chronicDisease,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
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
