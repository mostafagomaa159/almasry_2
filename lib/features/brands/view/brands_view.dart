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
    return Scaffold(
      backgroundColor: AppColors.surfaceScaffold,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BrandsFloat(vm: vm),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            CustomAppBar(title: LocaleKeys.brandsTitle.tr(), onBack: vm._back),

            BrandsSearchField(vm: vm),

            BrandsList(vm: vm),
          ],
        ),
      ),
    );
  }
}
