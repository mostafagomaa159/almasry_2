part of '../address_form_imports.dart';

class AddressFormGovernmentField extends StatelessWidget {
  final AddressFormViewModel vm;

  const AddressFormGovernmentField({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          LocaleKeys.addressFormGovernment.tr(),
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBlue,
          ),
        ),

        BlocBuilder<GenericCubit<ListRegions>, GenericState<ListRegions>>(
          bloc: vm._regionsCubit,
          builder: (BuildContext context, GenericState<ListRegions> state) {
            if (state.data.isEmpty && vm._errorMessage.isNotEmpty) {
              return _RegionsError(vm: vm, message: vm._errorMessage);
            }

            return _AddressFormRegionsDropdown(vm: vm, regions: state.data);
          },
        ),
      ],
    );
  }
}

class _AddressFormRegionsDropdown extends StatelessWidget {
  final AddressFormViewModel vm;
  final ListRegions regions;

  const _AddressFormRegionsDropdown({required this.vm, required this.regions});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<int?>, GenericState<int?>>(
      bloc: vm._selectedRegionCubit,
      builder: (BuildContext context, GenericState<int?> selectedState) {
        return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
          bloc: vm._regionsLoadingCubit,
          builder: (BuildContext context, GenericState<bool> loadingState) {
            return DropdownButtonFormField<int>(
              initialValue: selectedState.data,
              validator: vm._validateRegion,
              isExpanded: true,
              icon: loadingState.data
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryRed,
                      ),
                    )
                  : const Icon(Icons.keyboard_arrow_down),
              hint: Text(
                LocaleKeys.choose.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFB5B5B5),
                ),
              ),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4B4B4B),
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFDCDCDC)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.darkBlue),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryRed),
                ),
                focusedErrorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryRed),
                ),
                errorStyle: TextStyle(fontSize: 12.sp),
              ),
              items: <DropdownMenuItem<int>>[
                for (final RegionModel region in regions)
                  DropdownMenuItem<int>(
                    value: region.id,
                    child: Text(
                      region.displayName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: regions.isEmpty ? null : vm._selectRegion,
            );
          },
        );
      },
    );
  }
}

class _RegionsError extends StatelessWidget {
  final AddressFormViewModel vm;
  final String message;

  const _RegionsError({required this.vm, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              message.isEmpty ? LocaleKeys.somethingWentWrong.tr() : message,
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ),

          TextButton(
            onPressed: () => vm._retryRegions(context),
            child: Text(
              LocaleKeys.retry.tr(),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
