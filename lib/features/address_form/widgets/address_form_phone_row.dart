part of '../address_form_imports.dart';

class AddressFormPhoneRow extends StatelessWidget {
  final AddressFormViewModel vm;

  const AddressFormPhoneRow({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.surfacePlaceholder,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: <Widget>[
              Text('🇪🇬', style: TextStyle(fontSize: 20.sp)),

              8.horizontalSpace,

              Text(
                AddressModel.defaultCountryDialCode,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textFieldInput,
                ),
              ),
            ],
          ),
        ),

        16.horizontalSpace,

        Expanded(
          child: AddressFormField(
            label: LocaleKeys.phoneNumber.tr(),
            hintText: LocaleKeys.phoneNumber.tr(),
            controller: vm._phoneController,
            validator: vm._validatePhone,
            keyboardType: TextInputType.phone,
          ),
        ),
      ],
    );
  }
}
