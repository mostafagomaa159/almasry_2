part of '../address_form_imports.dart';

/// The scrolling form: names, phone, location, unit details, governorate, and
/// the save button.
class AddressFormBody extends StatelessWidget {
  final AddressFormViewModel vm;

  const AddressFormBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: vm._formKey,
      child: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: AddressFormField(
                  label: LocaleKeys.firstName.tr(),
                  hintText: LocaleKeys.firstName.tr(),
                  controller: vm._firstNameController,
                  validator: vm._validateName,
                ),
              ),

              20.horizontalSpace,

              Expanded(
                child: AddressFormField(
                  label: LocaleKeys.lastName.tr(),
                  hintText: LocaleKeys.lastName.tr(),
                  controller: vm._lastNameController,
                  validator: vm._validateName,
                ),
              ),
            ],
          ),

          28.verticalSpace,

          AddressFormPhoneRow(vm: vm),

          28.verticalSpace,

          Text(
            LocaleKeys.addressFormAddress.tr(),
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.darkBlue,
            ),
          ),

          14.verticalSpace,

          const AddressFormLocationPicker(),

          14.verticalSpace,

          AddressFormField(
            hintText: LocaleKeys.addressFormAddressHint.tr(),
            controller: vm._addressLineController,
            validator: vm._validateRequired,
            maxLines: 2,
          ),

          24.verticalSpace,

          AddressFormField(
            label: LocaleKeys.addressFormBuilding.tr(),
            hintText: LocaleKeys.addressFormBuildingHint.tr(),
            controller: vm._buildingController,
            validator: vm._validateRequired,
          ),

          24.verticalSpace,

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: AddressFormField(
                  label: LocaleKeys.addressFormFloor.tr(),
                  hintText: LocaleKeys.addressFormFloorHint.tr(),
                  controller: vm._floorController,
                  keyboardType: TextInputType.number,
                ),
              ),

              20.horizontalSpace,

              Expanded(
                child: AddressFormField(
                  label: LocaleKeys.addressFormApartment.tr(),
                  hintText: LocaleKeys.addressFormApartmentHint.tr(),
                  controller: vm._apartmentController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),

          24.verticalSpace,

          AddressFormField(
            label: LocaleKeys.addressFormMark.tr(),
            hintText: LocaleKeys.addressFormMarkHint.tr(),
            controller: vm._markController,
          ),

          24.verticalSpace,

          AddressFormGovernmentField(vm: vm),

          40.verticalSpace,

          BlocBuilder<
            GenericCubit<AddressFormData>,
            GenericState<AddressFormData>
          >(
            bloc: vm._formCubit,
            builder:
                (BuildContext context, GenericState<AddressFormData> state) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: CustomAppButton(
                      title: LocaleKeys.addressFormSave.tr(),
                      onPressed: vm._save,
                      isLoading: state.data.isSaving,
                      borderRadius: 12,
                    ),
                  );
                },
          ),
        ],
      ),
    );
  }
}
