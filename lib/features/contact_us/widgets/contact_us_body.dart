part of '../contact_us_imports.dart';

/// The scrolling form, the note under it, the submit button and the phone
/// numbers section.
class ContactUsBody extends StatelessWidget {
  final ContactUsViewModel vm;

  const ContactUsBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
      child: FadeInUp(
        duration: const Duration(milliseconds: 250),
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
                    onPressed: vm._submit,
                  );
                },
              ),
            ),

            28.verticalSpace,

            const ContactUsNumbersSection(),
          ],
        ),
      ),
    );
  }
}
