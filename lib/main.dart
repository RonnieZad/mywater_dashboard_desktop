import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mywater_dashboard_revamp/v1/screens/auth.dart';
import 'package:mywater_dashboard_revamp/v1/screens/dashboard.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:fluent_ui/fluent_ui.dart' as fluent;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    await windowManager.ensureInitialized();

    await WindowManager.instance.setTitle("My Water");

    await WindowManager.instance.setFullScreen(true);
  }

  await GetStorage.init();
  runApp(
    Phoenix(child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1280, 890),
      builder: (c, w) => GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild!.unfocus();
          }
        },
        child: fluent.FluentApp(
          title: 'MyWater Dashboard',
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          // color: baseColor,
          darkTheme: fluent.FluentThemeData(
            brightness: Brightness.light,
            // accentColor: fluent.Colors.blue,
            visualDensity: VisualDensity.standard,
            focusTheme: fluent.FocusThemeData(
              glowFactor: fluent.is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          theme: fluent.FluentThemeData(
            // accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: fluent.FocusThemeData(
              glowFactor: fluent.is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
          locale: const Locale('en', 'US'),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/auth':
                return MaterialPageRoute(builder: (_) => const AuthScreen());
              case '/dashboard':
                return MaterialPageRoute(builder: (_) => const Dashboard());
              default:
                return MaterialPageRoute(
                    builder: (_) => Scaffold(
                          body: Center(
                              child: Text(
                                  'No route defined for ${settings.name}')),
                        ));
            }
          },
          initialRoute:
              GetStorage().read('token') == null ? '/auth' : '/dashboard',
          builder: (context, child) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: fluent.NavigationPaneTheme(
                data: fluent.NavigationPaneThemeData(
                    labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
                    backgroundColor: null),
                child: Material(child: child!),
              ),
            );
          },
        ),
      ),
    );
  }
}
