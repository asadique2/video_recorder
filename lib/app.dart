import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_rc/modules/home/home_binding.dart';
import 'package:video_rc/modules/home/home_view.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          scaffoldBackgroundColor: Colors.white),
      initialBinding: HomeBinding(),
      home: const HomeView(),
    );
  }
}
