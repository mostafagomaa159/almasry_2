part of '../contact_us_imports.dart';

class ContactUsBody extends StatelessWidget {
  final ContactUsViewModel vm;

  const ContactUsBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContactUsForm(vm: vm),

          20.verticalSpace,

          Text(
            LocaleKeys.contactUsNote.tr(),
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),

          24.verticalSpace,

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.w),
            child: BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
              bloc: vm._loadingCubit,
              builder: (context, state) {
                return AppButton(
                  title: LocaleKeys.contactUsSubmit.tr(),
                  isLoading: state.data,
                  onPressed: () => _onSubmitPressed(context),
                );
              },
            ),
          ),

          28.verticalSpace,

          const ContactUsNumbersSection(),
        ],
      ),
    );
  }

  Future<void> _onSubmitPressed(BuildContext context) async {
    await vm._submit();

    if (!context.mounted) return;

    _showResult(context);
  }

  void _showResult(BuildContext context) {
    final SubmitContactFormResponse? response = vm._responseCubit.state.data;

    if (response == null) return;

    final bool isSuccess = response.status;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: isSuccess
              ? const Color(0xFF34A853)
              : AppColors.primaryRed,
          content: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                size: 24.sp,
                color: AppColors.white,
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  isSuccess
                      ? LocaleKeys.contactUsSuccess.tr()
                      : LocaleKeys.contactUsFailed.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
