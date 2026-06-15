part of '../product_list_imports.dart';
class ProductListArgs {
  final String title;
  final String categoryId;

  const ProductListArgs({
    required this.title,
    required this.categoryId,
  });
}

class ProductListView extends StatefulWidget {
  final String title;
  final String categoryId;

  const ProductListView({
    super.key,
    required this.title,
    required this.categoryId,
  });

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  late final ProductListViewModel _viewModel;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _viewModel = ProductListViewModel()
      ..init(title: widget.title, categoryId: widget.categoryId);

    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final currentOffset = _scrollController.position.pixels;
    final maxOffset = _scrollController.position.maxScrollExtent;

    if (currentOffset >= maxOffset - 200) {
      _viewModel.loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          widget.title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: _ProductListBody(
        scrollController: _scrollController,
        viewModel: _viewModel,
      ),
    );
  }
}
