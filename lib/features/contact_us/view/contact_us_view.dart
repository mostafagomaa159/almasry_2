part of '../contact_us_imports.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final ContactUsViewModel vm = ContactUsViewModel();

  @override
  void initState() {
    super.initState();
    vm._init();
  }

  @override
  void dispose() {
    vm._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            CustomAppBar(
              title: LocaleKeys.contactUsTitle.tr(),
              onBack: vm._back,
            ),
            Expanded(child: ContactUsBody(vm: vm)),
          ],
        ),
      ),
    );
  }
}
