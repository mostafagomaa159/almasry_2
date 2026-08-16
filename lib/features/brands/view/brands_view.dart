part of '../brands_imports.dart';

class BrandsView extends StatefulWidget {
  const BrandsView({super.key});

  @override
  State<BrandsView> createState() => _BrandsViewState();
}

class _BrandsViewState extends State<BrandsView> {
  final BrandsViewModel vm = BrandsViewModel();

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
      backgroundColor: const Color(0xFFF8F8F8),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BrandsFloat(vm: vm),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            CustomAppBar(title: LocaleKeys.brandsTitle.tr(), onBack: vm._back),

            Padding(
              padding: EdgeInsets.all(20.r),
              child: BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
                bloc: vm._clearSearchCubit,
                builder: (context, state) {
                  return AppSearchField(
                    controller: vm._searchController,
                    hintText: LocaleKeys.brandsSearchHint.tr(),
                    showClear: state.data,
                    onClear: vm._clearSearch,
                    onChanged: vm._onSearchChanged,
                    onSubmitted: vm._brandsSearch,
                  );
                },
              ),
            ),

            BrandsList(vm: vm),
          ],
        ),
      ),
    );
  }
}
