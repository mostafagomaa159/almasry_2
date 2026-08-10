part of '../contact_us_imports.dart';

class ContactUsBody extends StatelessWidget {
  final ContactUsViewModel vm;

  const ContactUsBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<ContactUsData>, GenericState<ContactUsData>>(
      bloc: vm._contactUsCubit,
      builder: (context, state) {
        final ContactUsData data = state.data;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.status == ContactUsStatus.success)
                ContactUsSuccessBanner(onClose: vm._dismissBanner),

              if (data.status == ContactUsStatus.error &&
                  data.errorMessage.isNotEmpty)
                _ContactUsErrorBanner(
                  message: data.errorMessage,
                  onClose: vm._dismissBanner,
                ),

              ContactUsForm(vm: vm, data: data),

              SizedBox(height: 20.h),

              Text(
                LocaleKeys.contactUsNote.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 24.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 26.w),
                child: AppButton(
                  title: LocaleKeys.contactUsSubmit.tr(),
                  isLoading: data.isSubmitting,
                  onPressed: vm._submit,
                ),
              ),

              SizedBox(height: 28.h),

              const ContactUsNumbersSection(),
            ],
          ),
        );
      },
    );
  }
}

class _ContactUsErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const _ContactUsErrorBanner({required this.message, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 26.sp,
            color: AppColors.primaryRed,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          InkWell(
            onTap: onClose,
            child: Icon(
              Icons.close,
              size: 22.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
