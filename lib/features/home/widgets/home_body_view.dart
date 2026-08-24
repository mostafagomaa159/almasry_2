part of '../home_imports.dart';

class HomeBodyView extends StatelessWidget {
  final HomeViewModel vm;

  const HomeBodyView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<HomeModel>, GenericState<HomeModel>>(
      bloc: vm._homeCubit,
      builder: (context, state) {
        final data = vm._data;

        if (data.isLoading) {
          return const CustomAppLoadingView();
        }

        if (data.errorMessage != null && data.errorMessage!.isNotEmpty) {
          return CustomAppErrorView(message: data.errorMessage!);
        }

        return HomeSuccessContent(vm: vm);
      },
    );
  }
}
