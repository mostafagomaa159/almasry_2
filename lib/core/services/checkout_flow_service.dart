import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/constants/app_durations.dart';
import 'package:flutter/material.dart';

class CheckoutFlowService {
  static const int cartStep = 0;
  static const int shippingStep = 1;
  static const int paymentStep = 2;
  static const int reviewStep = 3;

  final GenericCubit<int> stepCubit = GenericCubit<int>(cartStep);

  String selectedAddressId = '';

  PageController? _pageController;

  int get step => stepCubit.state.data;

  bool get isCheckingOut => step > cartStep;

  void attach(PageController controller) {
    _pageController = controller;
    selectedAddressId = '';

    if (step == cartStep) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController != controller) return;

      stepCubit.onUpdateData(cartStep);
    });
  }

  void detach(PageController controller) {
    if (_pageController != controller) return;

    _pageController = null;
    selectedAddressId = '';

    if (step == cartStep) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController != null) return;

      stepCubit.onUpdateData(cartStep);
    });
  }

  void syncStep(int index) {
    if (index == step) return;

    stepCubit.onUpdateData(index);
  }

  Future<void> next() => _animateTo(step + 1);

  Future<void> previous() => _animateTo(step - 1);

  void reset() {
    selectedAddressId = '';

    stepCubit.onUpdateData(cartStep);

    final PageController? controller = _pageController;

    if (controller == null || !controller.hasClients) return;

    controller.jumpToPage(cartStep);
  }

  Future<void> _animateTo(int index) async {
    final int target = index.clamp(cartStep, reviewStep);

    if (target == step) return;

    stepCubit.onUpdateData(target);

    final PageController? controller = _pageController;

    if (controller == null || !controller.hasClients) return;

    await controller.animateToPage(
      target,
      duration: AppDurations.page,
      curve: Curves.easeInOut,
    );
  }
}
