part of '../categories_imports.dart';

class CategoriesContentView extends StatelessWidget {
  final CategoriesViewModel vm;

  const CategoriesContentView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CategoriesSidebar(vm: vm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                CategoriesSearchField(vm: vm),
                const SizedBox(height: 12),
                Expanded(child: CategoriesChildrenSection(vm: vm)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
