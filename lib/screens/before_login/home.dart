
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:isrprojectnew/screens/before_login/login_screen.dart';
import 'package:isrprojectnew/screens/before_login/register_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  static const String routeName = 'home_screen';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  bool isDarkMode = true;
  bool isMenuOpen = false;

  void toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  void toggleMenu() {
    setState(() => isMenuOpen = !isMenuOpen);
  }

  Future<void> openLinkedIn() async {
    const url = 'https://www.linkedin.com';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final grayColor = isDarkMode ? const Color(0xff818188) : const Color(0xff8D8D94);
    final notcolor = isDarkMode ? const Color(0xff232326) : const Color(0xffF6F6F7);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // IRS Logo + Text
                    Row(
                      children: [
                        Icon(Icons.change_history, color: textColor, size: 30),
                        const SizedBox(width: 8),
                        Text('IRS', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 30)),
                      ],
                    ),
                    // Icons
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.dataset_linked_outlined, color: grayColor),
                          onPressed: openLinkedIn,
                          tooltip: 'LinkedIn',
                        ),
                        IconButton(
                          icon: Icon(
                            isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                            color: grayColor,
                          ),
                          onPressed: toggleTheme,
                          tooltip: 'Toggle Theme',
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: notcolor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.person_outline, size: 22, color: Colors.pink),
                                const SizedBox(width: 4),
                                Text('Login', style: TextStyle(color: textColor)),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isMenuOpen ? Icons.close : Icons.menu,
                            color: grayColor,
                          ),
                          onPressed: toggleMenu,
                          tooltip: 'Menu',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Sample main text
              Text.rich(
                TextSpan(
                  text: 'Get Most ',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
                  children: const [
                    TextSpan(
                      text: 'Suitable ',
                      style: TextStyle(color: Colors.purple),
                    ),
                    TextSpan(text: 'Internship'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text('Get hired with ease!', style: TextStyle(color: textColor)),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text('Powered by Ex-Fresher', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),

          // Dropdown Menu - Below AppBar
          if (isMenuOpen)
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.transparent : Colors.transparent,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Home', style: TextStyle(color: textColor)),
                        onTap: () {
                          toggleMenu();
                        },
                      ),
                      ListTile(
                        title: Text('Login', style: TextStyle(color: textColor)),
                        onTap: () {
                          toggleMenu();
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                      ),
                      ListTile(
                        title: Text('Register', style: TextStyle(color: textColor)),
                        onTap: () {
                          toggleMenu();
                          Navigator.pushNamed(context, RegisterScreen.routeName);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
