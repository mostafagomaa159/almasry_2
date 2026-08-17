part of '../product_search_imports.dart';

/// What the screen shows before the first search: the prompt, and the queries
/// the user has run before. Each row re-runs its query; the trailing cross
/// forgets it.
class ProductSearchRecentSearches extends StatelessWidget {
  final ProductSearchViewModel vm;

  const ProductSearchRecentSearches({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<List<String>>, GenericState<List<String>>>(
      bloc: vm._recentSearchesCubit,
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Text(
              LocaleKeys.productSearchPrompt.tr(),
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),

            18.verticalSpace,

            ...state.data.map(
              (query) => _RecentSearchTile(vm: vm, query: query),
            ),
          ],
        );
      },
    );
  }
}

class _RecentSearchTile extends StatelessWidget {
  final ProductSearchViewModel vm;
  final String query;

  const _RecentSearchTile({required this.vm, required this.query});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: () => vm._onRecentSearchTap(query),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Icon(Icons.history, size: 22.sp, color: AppColors.textSecondary),

              12.horizontalSpace,

              Expanded(
                child: Text(
                  query,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              8.horizontalSpace,

              InkWell(
                onTap: () => vm._removeRecentSearch(query),
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.close,
                    size: 22.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
