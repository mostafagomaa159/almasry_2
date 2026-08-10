part of '../brands_imports.dart';

class BrandsBody extends StatelessWidget {
  final BrandsViewModel vm;

  const BrandsBody({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<BrandsData>, GenericState<BrandsData>>(
      bloc: vm._brandsCubit,
      builder: (context, state) {
        final BrandsData data = state.data;

        switch (data.status) {
          case BrandsStatus.initial:
          case BrandsStatus.loading:
            return const BrandsLoadingView();

          case BrandsStatus.error:
            return BrandsErrorView(vm: vm, message: data.errorMessage);

          case BrandsStatus.success:
            if (data.brands.isEmpty) {
              return Center(
                child: Text(
                  LocaleKeys.brandsEmpty.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }

            return BrandsGrid(vm: vm, data: data);
        }
      },
    );
  }
}
