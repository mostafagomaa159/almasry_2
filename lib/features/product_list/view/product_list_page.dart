part of '../product_list_imports.dart';

class ProductListPage extends StatelessWidget {
  final String title;
  final String categoryId;

  const ProductListPage({
    super.key,
    required this.title,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductListCubit>()
        ..loadProducts(
          title: title,
          categoryId: categoryId,
        ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        body: const _ProductListBody(),
      ),
    );
  }
}
