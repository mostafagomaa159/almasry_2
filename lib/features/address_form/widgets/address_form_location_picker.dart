part of '../address_form_imports.dart';

class AddressFormLocationPicker extends StatelessWidget {
  const AddressFormLocationPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 168.h,
      decoration: BoxDecoration(
        color: AppColors.surfaceMapPlaceholder,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.borderThumbnail),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.map_outlined, size: 40.sp, color: AppColors.textDisabled),

          10.verticalSpace,

          Text(
            LocaleKeys.addressFormPickOnMap.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPlaceholder,
            ),
          ),
        ],
      ),
    );
  }
}
