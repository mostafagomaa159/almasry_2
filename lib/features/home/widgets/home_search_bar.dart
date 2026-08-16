part of '../home_imports.dart';

/// Home's search box takes no input of its own — tapping it opens the search
/// screen, which is where the field the user actually types into lives.
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  NavigationService get _nav => sl<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return AppSearchField(
      hintText: LocaleKeys.homeSearch.tr(),
      readOnly: true,
      onTap: () => _nav.pushNamed(RouteNames.productSearch),
    );
  }
}
