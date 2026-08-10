part of '../home_imports.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSearchField(hintText: LocaleKeys.homeSearch.tr());
  }
}
