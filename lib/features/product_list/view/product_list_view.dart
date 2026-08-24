part of '../product_list_imports.dart';

class ProductListView extends StatefulWidget {
  final String title;
  final String categoryId;
  final bool isBrand;

  const ProductListView({
    super.key,
    required this.title,
    required this.categoryId,
    this.isBrand = false,
  });

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final ProductListViewModel vm = ProductListViewModel();

  @override
  void initState() {
    super.initState();
    vm._init(
      title: widget.title,
      categoryId: widget.categoryId,
      isBrand: widget.isBrand,
    );
  }

  @override
  void dispose() {
    vm._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppTitleAppBar(
        title: vm._title,
        onBack: vm._goBack,
        titleStyle: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
      body: _ProductListBody(vm: vm),
    );
  }
}
