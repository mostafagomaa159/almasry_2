part of '../home_imports.dart';

class HomeBodyView extends StatelessWidget {
  final HomeViewModel vm;

  const HomeBodyView({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenericCubit<bool>, GenericState<bool>>(
      bloc: vm._loadingCubit,
      builder: (context, loadingState) {
        if (loadingState.data) {
          return const CustomAppLoadingView();
        }

        if (vm._errorMessage.isNotEmpty) {
          return CustomAppErrorView(message: vm._errorMessage);
        }

        return BlocBuilder<
          GenericCubit<_HomeStructure?>,
          GenericState<_HomeStructure?>
        >(
          bloc: vm._structureCubit,
          builder: (context, state) => HomeSuccessContent(vm: vm),
        );
      },
    );
  }
}
