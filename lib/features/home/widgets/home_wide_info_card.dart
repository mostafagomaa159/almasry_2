part of '../home_imports.dart';

class WideInfoCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isNetworkImage;
  final Color backgroundColor;

  const WideInfoCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.isNetworkImage = false,
    this.backgroundColor = AppColors.goldTint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170.w,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.navyCard,
                height: 1.3,
              ),
            ),
          ),
          10.horizontalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: SizedBox(
              width: 58.w,
              height: 58.h,
              child: isNetworkImage
                  ? CustomAppNetworkImage(
                      url: imagePath,
                      placeholder: Container(
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 20.sp,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    )
                  : Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }
}
