part of '../address_form_imports.dart';

/// The "Government" governorate picker.
///
/// A dropdown rather than the design's plain text line, on purpose: Magento
/// rejects an address whose region it cannot resolve ("regionId is required"),
/// so the value has to come from its own list — a typed governorate name
/// cannot be turned into a `region_id`.
class AddressFormGovernmentField extends StatelessWidget {
  final AddressFormViewModel vm;

  const AddressFormGovernmentField({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      GenericCubit<AddressFormData>,
      GenericState<AddressFormData>
    >(
      bloc: vm._formCubit,
      builder: (BuildContext context, GenericState<AddressFormData> state) {
        final AddressFormData data = state.data;

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

            if (data.status == RegionsStatus.error)
              _RegionsError(vm: vm, message: data.errorMessage)
            else
              DropdownButtonFormField<int>(
                initialValue: data.selectedRegionId,
                validator: vm._validateRegion,
                isExpanded: true,
                icon: data.status == RegionsStatus.loading
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
                  for (final RegionModel region in data.regions)
                    DropdownMenuItem<int>(
                      value: region.id,
                      child: Text(
                        region.displayName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: data.regions.isEmpty ? null : vm._selectRegion,
              ),
          ],
        );
      },
    );
  }
}

/// The list is not optional, so a failed fetch gets its own retry rather than
/// leaving an empty dropdown the user cannot get past.
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
