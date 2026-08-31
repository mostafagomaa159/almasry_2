part of '../home_imports.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  NavigationService _nav() => sl<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return CustomAppSearchField(
      hintText: LocaleKeys.homeSearch.tr(),
      readOnly: true,
      onTap: () => _nav().pushNamed(RouteNames.productSearch),
    );
  }
}
