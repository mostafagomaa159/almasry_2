import 'package:almasry_2/core/localization/locale_keys.dart';
import 'package:almasry_2/features/product_details/product_details.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsView extends StatelessWidget {
  final ProductDetailsArgs args;

  const ProductDetailsView({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (_) => ProductDetailsCubit(),
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F7F7),
            body: SafeArea(
              child: Column(
                children: [
                  ProductDetailsHeader(
                    title: args.title,
                    isArabic: isArabic,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductDetailsImageSection(
                            imagePath: args.imagePath,
                          ),
                          SizedBox(height: 18.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  args.title,
                                  style: TextStyle(
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF11385B),
                                    height: 1.35,
                                  ),
                                ),
                                SizedBox(height: 14.h),
                                Text(
                                  args.price,
                                  style: TextStyle(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2C2C2C),
                                  ),
                                ),
                                SizedBox(height: 28.h),
                                Text(
                                  LocaleKeys.productDetailsCategories.tr(),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2C2C2C),
                                  ),
                                ),
                                SizedBox(height: 14.h),
                                ProductDetailsCategoryChip(
                                  title: args.category,
                                ),
                                SizedBox(height: 36.h),
                                ProductDetailsDescriptionSection(
                                  description: args.description,
                                ),
                                SizedBox(height: 34.h),
                                ProductDetailsRatingSection(
                                  rating: args.rating,
                                ),
                                SizedBox(height: 34.h),
                                ProductDetailsBottomAction(
                                  quantity: state.quantity,
                                  onIncrementTap: () {
                                    context
                                        .read<ProductDetailsCubit>()
                                        .incrementQuantity();
                                  },
                                  onDecrementTap: () {
                                    context
                                        .read<ProductDetailsCubit>()
                                        .decrementQuantity();
                                  },
                                  onAddToBasketTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
