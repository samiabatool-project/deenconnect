import 'package:flutter/material.dart';
import 'package:deen_connect/core/theme/app_theme.dart';
import 'package:deen_connect/features/splash/splash_screen.dart';
import 'package:flutter/services.dart';

class DeenConnectApp extends StatelessWidget {
  const DeenConnectApp({super.key});

  

  @override
  Widget build(BuildContext context) {
    // System UI Configuration
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(255, 51, 40, 25),
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'DeenConnect',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
