import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:isrprojectnew/providers/auth_provider.dart';
import 'package:isrprojectnew/screens/after_login/internships.dart';
import 'package:isrprojectnew/screens/after_login/profile.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:isrprojectnew/screens/before_login/home.dart';

class Homeafterlogin extends StatelessWidget {
  static const String routeName = 'home_Screenafterlogin';

  const Homeafterlogin({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                        title: Text('Profile', style: TextStyle(color: textColor)),
                        onTap: () {
                        Navigator.pushNamed(context, ProfileScreen.routeName);

                        },
                      ),
                      ListTile(
                        title: Text('Internships', style: TextStyle(color: textColor)),
                        onTap: () {
                        Navigator.pushNamed(context, InternshipsScreen.routeName);
                        },
                      ),
                      ListTile(
                        title: const Text('Logout', style: TextStyle(color: Colors.red)),
                        onTap: () async {
                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.logout();
                        toggleMenu();
                        Navigator.pushNamedAndRemoveUntil(
                        context,
                        Home.routeName,
                        (route) => false,
                        );
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