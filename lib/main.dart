import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/auth/presentation/view/login_screen.dart';
import 'features/auth/presentation/view_model/auth_cubit.dart';

void main() {
  runApp(const AlmasryApp());
}

class AlmasryApp extends StatelessWidget {
  const AlmasryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return BlocProvider(
          create: (_) => AuthCubit(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'Arial',
            ),
            home: const LoginScreen(),
          ),
        );
      },
    );
  }
}
