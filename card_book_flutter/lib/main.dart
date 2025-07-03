import 'package:card_book_flutter/counter/counter_page.dart';
import 'package:card_book_flutter/static_function.dart';
import 'package:card_book_flutter/tool/hide_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'generated/l10n.dart';

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
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp

  ({super.key});

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
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  FlutterQuillLocalizations.delegate
                ],
                supportedLocales: S.delegate.supportedLocales,
                title: 'CountDeck',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(
                      seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                home:  CounterPage( parentId: "0",title: "",),
              ));
        });
  }
}
