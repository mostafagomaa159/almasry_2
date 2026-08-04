part of '../product_list_imports.dart';

class _ProductListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final ProductListViewModel vm;

  const _ProductListAppBar({required this.vm});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: vm._goBack,
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
      ),
      title: Text(
        vm._title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
