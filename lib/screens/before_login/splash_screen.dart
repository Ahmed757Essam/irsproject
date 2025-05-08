import 'package:flutter/material.dart';
import 'package:isrprojectnew/screens/before_login/home.dart';
// import 'package:isrprogect/screens/login_screen/login_screen.dart';
// import 'package:isrprogect/helper/app_colors.dart';


class SplashScreen extends StatefulWidget {
  static const String routeName = 'Splash_Screen';
  
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashScreen> {
  
  @override
  void initState() {
    
    super.initState();
    Future.delayed(const Duration(seconds:2),(){
      
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, Home.routeName);

    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: const Scaffold(
        backgroundColor: Colors.black,
        body: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SafeArea(        
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    Center(
                      child: Align(
                        child: Text(
                          'IRS',
                          textAlign: TextAlign.center,
                          style:TextStyle (
                                fontFamily: 'Inter Tight',
                                color: Colors.white,
                                fontSize: 57,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    ),
                   ] ,
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
