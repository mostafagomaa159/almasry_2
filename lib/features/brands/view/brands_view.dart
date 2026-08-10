part of '../brands_imports.dart';

class BrandsView extends StatefulWidget {
  const BrandsView({super.key});

  @override
  State<BrandsView> createState() => _BrandsViewState();
}

class _BrandsViewState extends State<BrandsView> {
  final BrandsViewModel vm = BrandsViewModel();

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
    return Container(
      color: const Color(0xFFF8F8F8),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            AppPageHeader(
              title: LocaleKeys.brandsTitle.tr(),
              onBack: vm._back,
            ),
            SizedBox(height: 18.h),
            BrandsSearchField(vm: vm),
            SizedBox(height: 18.h),
            Expanded(child: BrandsBody(vm: vm)),
          ],
        ),
      ),
    );
  }
}
