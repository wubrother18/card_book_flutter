import 'package:card_book_flutter/counter/counter_page.dart';
import 'package:card_book_flutter/home/home_page.dart';
import 'package:card_book_flutter/static_function.dart';
import 'package:card_book_flutter/tool/hide_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  ///鎖直向
  SystemChrome.setPreferredOrientations([
    // Orientations
    // DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  StaticFunction.prefs = prefs;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp

  ({super.key});

  Future<void> initPrefs() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    StaticFunction.prefs = prefs;
  }
    // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // initPrefs();
    FlutterNativeSplash.remove();
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
                home:  const CounterPage( parentId: "0",title: "主要分類",),
              ));
        });
  }
}
