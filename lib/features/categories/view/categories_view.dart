part of '../categories_imports.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final CategoriesViewModel vm = CategoriesViewModel();

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
      color: AppColors.surfaceScaffold,
      child: SafeArea(
        child: Column(
          children: [
            AppBar(
              title: Text(LocaleKeys.categories.tr()),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            Expanded(child: CategoriesBody(vm: vm)),
          ],
        ),
      ),
    );
  }
}
