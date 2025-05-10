import 'package:flutter/material.dart';
import 'package:isrprojectnew/providers/auth_provider.dart';
import 'package:isrprojectnew/providers/jobs_provider.dart';
import 'package:isrprojectnew/providers/token_provider.dart';  // استيراد TokenProvider
import 'package:isrprojectnew/screens/after_login/homeafterlogin.dart';
import 'package:isrprojectnew/screens/after_login/internships.dart';
import 'package:isrprojectnew/screens/after_login/profile.dart';
import 'package:isrprojectnew/screens/before_login/home.dart';
import 'package:isrprojectnew/screens/before_login/login_screen.dart';
import 'package:isrprojectnew/screens/before_login/register_screen.dart';
import 'package:isrprojectnew/screens/before_login/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => JobsProvider()),
        ChangeNotifierProvider(create: (_) => TokenProvider()),  // إضافة TokenProvider هنا
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<AuthProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IRS Internship',
      themeMode: ThemeMode.dark,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        Home.routeName: (_) => const Home(),
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        Homeafterlogin.routeName: (_) => const Homeafterlogin(),
        ProfileScreen.routeName: (_) => const ProfileScreen(),
        InternshipsScreen.routeName: (_) => const InternshipsScreen(),
      },
    );
  }
}
