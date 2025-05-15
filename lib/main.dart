import 'package:adhtp_general_analysis/src/navigator_sevices.dart';
import 'package:adhtp_general_analysis/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

final TextTheme _appTextTheme = Typography.englishLike2021.apply();
final MaterialTheme appCustomTheme = MaterialTheme(_appTextTheme);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appCustomTheme.light(),
      darkTheme: appCustomTheme.dark(),
      themeMode: ThemeMode.system,
      home: const NavigatorServices(),
      builder: (context, child) {
        final Brightness platformBrightness = MediaQuery.platformBrightnessOf(
          context,
        );
        final bool highContrast = MediaQuery.highContrastOf(context);
        ThemeData activeTheme;
        if (platformBrightness == Brightness.dark) {
          if (highContrast) {
            activeTheme = appCustomTheme.darkHighContrast();
          } else {
            activeTheme = appCustomTheme.dark();
          }
        } else {
          if (highContrast) {
            activeTheme = appCustomTheme.lightHighContrast();
          } else {
            activeTheme = appCustomTheme.light();
          }
        }
        return Theme(data: activeTheme, child: child!);
      },
    );
  }
}
