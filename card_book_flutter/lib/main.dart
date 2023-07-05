import 'package:card_book_flutter/home/home_page.dart';
import 'package:card_book_flutter/static_function.dart';
import 'package:card_book_flutter/tool/hide_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ///鎖直向
  SystemChrome.setPreferredOrientations([
    // Orientations
    // DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  // Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  StaticFunction.prefs = prefs;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp

  ({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return HideKeyboard(
              child: MaterialApp(
                title: 'Card Book',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                home:  HomeScreen(),
              ));
        });
  }
}
