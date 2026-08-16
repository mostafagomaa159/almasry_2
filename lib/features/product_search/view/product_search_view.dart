part of '../product_search_imports.dart';

class ProductSearchView extends StatefulWidget {
  const ProductSearchView({super.key});

  @override
  State<ProductSearchView> createState() => _ProductSearchViewState();
}

class _ProductSearchViewState extends State<ProductSearchView> {
  final ProductSearchViewModel vm = ProductSearchViewModel();

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ProductSearchFloat(vm: vm),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ProductSearchAppBar(vm: vm),
            12.verticalSpace,
            Expanded(child: ProductSearchBody(vm: vm)),
          ],
        ),
      ),
    );
  }
}
