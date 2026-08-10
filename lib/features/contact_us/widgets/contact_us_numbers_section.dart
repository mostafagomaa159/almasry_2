part of '../contact_us_imports.dart';

class ContactUsNumbersSection extends StatelessWidget {
  const ContactUsNumbersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.contactUsNumbersTitle.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        14.verticalSpace,
        ...AppContact.phones.map(
          (phone) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              children: [
                Icon(
                  Icons.smartphone_outlined,
                  size: 20.sp,
                  color: AppColors.textSecondary,
                ),
                10.horizontalSpace,
                Text(
                  phone,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
