// part of '../home_imports.dart';
//
// class HomeServicesSection extends StatelessWidget {
//   final List<HomeServiceModel> items;
//
//   const HomeServicesSection({super.key, required this.items});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10.w),
//       child: GridView.builder(
//         itemCount: items.length,
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 12.w,
//           mainAxisSpacing: 12.h,
//           childAspectRatio: 0.82,
//         ),
//         itemBuilder: (context, index) {
//           final item = items[index];
//           return ServiceCard(
//             iconPath: item.iconPath,
//             title: item.titleKey.tr(),
//             description: item.descriptionKey.tr(),
//           );
//         },
//       ),
//     );
//   }
// }
