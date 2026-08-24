part of '../brands_imports.dart';

/// Scroll-to-top button, shown once you are far enough down the grid that
/// getting back would otherwise be a long swipe. Its label is the total number
/// of brands the query matched.
class BrandsFloat extends StatelessWidget {
  const BrandsFloat({super.key, required this.vm});

  final BrandsViewModel vm;

  static const int _minimumRow = 15;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._showFAB,
      builder: (context, showState) {
        return BlocBuilder<GenericCubit<int>, GenericState<int>>(
          bloc: vm._currentIndex,
          builder: (context, indexState) {
            final bool isVisible =
                showState.data && indexState.data > _minimumRow;

            return AnimatedSwitcher(
              duration: AppDurations.floatToggle,
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: isVisible
                  ? _ScrollToTopButton(vm: vm)
                  : const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}

class _ScrollToTopButton extends StatelessWidget {
  const _ScrollToTopButton({required this.vm});

  final BrandsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('brands_scroll_to_top'),
      height: 35.h,
      child: BlocBuilder<GenericCubit<int>, GenericState<int>>(
        bloc: vm._totalItemsCubit,
        builder: (context, state) {
          return FloatingActionButton.extended(
            onPressed: vm._scrollToTop,
            backgroundColor: AppColors.textPrimary.withValues(alpha: 0.6),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.r),
            ),
            icon: const Icon(
              Icons.keyboard_double_arrow_up,
              color: AppColors.white,
              size: 16,
            ),
            label: Text(
              state.data.toString(),
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w900,
                fontSize: 10.sp,
              ),
            ),
          );
        },
      ),
    );
  }
}
