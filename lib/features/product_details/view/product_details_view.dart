part of '../product_details_imports.dart';

class ProductDetailsView extends StatefulWidget {
  final ProductDetailsArgs args;

  const ProductDetailsView({super.key, required this.args});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final ProductDetailsViewModel vm = ProductDetailsViewModel();

  @override
  void initState() {
    super.initState();
    vm._init(args: widget.args);
  }

  @override
  void dispose() {
    vm._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceMuted,
      body: SafeArea(
        child: Column(
          children: [
            ProductDetailsHeader(
              title: LocaleKeys.productDetailsTitle.tr(),
              onBack: vm._back,
            ),

            Expanded(child: ProductDetailsBody(vm: vm)),
          ],
        ),
      ),
    );
  }
}
