part of '../home_imports.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final int cartCount;

  const HomeBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.cartCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';

    final items = [
      _NavBarItemData(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: isArabic ? 'الرئيسية' : 'Home',
      ),
      _NavBarItemData(
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        label: isArabic ? 'الأقسام' : 'Categories',
      ),

      _NavBarItemData(
        icon: Icons.shopping_cart_outlined,
        activeIcon: Icons.shopping_cart_rounded,
        label: isArabic ? 'السلة' : 'Cart',
        badgeCount: cartCount,
      ),
      _NavBarItemData(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: isArabic ? 'الملف الشخصي' : 'Profile',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: const Color(0xFFF0F0F0),
            width: 1.w,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        top: 8.h,
        bottom: 10.h + MediaQuery.of(context).padding.bottom * 0.2,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(
            items.length,
                (index) => _HomeBottomNavItem(
              data: items[index],
              isSelected: selectedIndex == index,
              onTap: () => onTap(index),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeBottomNavItem extends StatelessWidget {
  final _NavBarItemData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _HomeBottomNavItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = AppColors.primaryRed;
    const Color inactiveColor = Color(0xFFC6C6C6);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isSelected ? data.activeIcon : data.icon,
                    size: 24.sp,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
                  if ((data.badgeCount ?? 0) > 0)
                    Positioned(
                      top: -6.h,
                      right: -10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.h,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16.w,
                          minHeight: 16.h,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1F1F1F),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${data.badgeCount}',
                          style: TextStyle(
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                data.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int? badgeCount;

  const _NavBarItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeCount,
  });
}
