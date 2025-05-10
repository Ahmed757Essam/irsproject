import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:isrprojectnew/providers/auth_provider.dart';
import 'package:isrprojectnew/providers/token_provider.dart';
import 'package:isrprojectnew/screens/after_login/homeafterlogin.dart';
import 'package:isrprojectnew/screens/before_login/home.dart';
import 'package:isrprojectnew/screens/before_login/register_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isDarkMode = true;
  bool isMenuOpen = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  void toggleMenu() {
    setState(() => isMenuOpen = !isMenuOpen);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final grayColor =
        isDarkMode ? const Color(0xff818188) : const Color(0xff8D8D94);
    final notcolor =
        isDarkMode ? const Color(0xff232326) : const Color(0xffF6F6F7);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.change_history, color: textColor),
                          const SizedBox(width: 6),
                          Text("IRS",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.link),
                            color: grayColor,
                            onPressed: () async {
                              const url = 'https://www.linkedin.com/';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(isDarkMode
                                ? Icons.wb_sunny
                                : Icons.nightlight_round),
                            color: grayColor,
                            onPressed: toggleTheme,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: notcolor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton.icon(
                              onPressed: () {},
                              icon:
                                  const Icon(Icons.person, color: Colors.pink),
                              label: Text("Login",
                                  style: TextStyle(color: textColor)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(isMenuOpen ? Icons.close : Icons.menu),
                            color: grayColor,
                            onPressed: toggleMenu,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 300,
                                child: TextFormField(
                                  controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email is required';
                                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(value)) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    filled: true,
                                    fillColor: notcolor,
                                    hintStyle: TextStyle(color: grayColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                  ),
                                  style: TextStyle(color: grayColor),
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: 300,
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required';
                                    } else if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    filled: true,
                                    fillColor: notcolor,
                                    hintStyle: TextStyle(color: grayColor),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: 300,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        await Provider.of<AuthProvider>(context, listen: false).login(
                                          context,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );
                                        Navigator.pushNamed(context, Homeafterlogin.routeName);
                                      } catch (e) {
                                        // Clean up the error message by removing "Exception: " prefixes
                                        String errorMessage = e.toString().replaceAll('Exception: ', '');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Login failed: $errorMessage')),
                                        );
                                      }
                                    }
                                  }
                                  ,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: notcolor,
                                  ),
                                  child: Text("Login",
                                      style: TextStyle(color: textColor)),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RegisterScreen.routeName);
                                },
                                child: const Text(
                                    "Don't have an account? Register",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text("Forgot Password?",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text.rich(
                    TextSpan(
                      text: 'Powered by ',
                      style: TextStyle(color: textColor),
                      children: const [
                        TextSpan(
                          text: 'Ex-Fresher',
                          style: TextStyle(color: Colors.blue),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (isMenuOpen)
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                bottom: 0,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Column(
                      children: [
                        ListTile(
                          title:
                              Text('Home', style: TextStyle(color: textColor)),
                          onTap: () {
                            Navigator.pushNamed(context, Home.routeName);
                          },
                        ),
                        ListTile(
                          title:
                              Text('Login', style: TextStyle(color: textColor)),
                          onTap: toggleMenu,
                        ),
                        ListTile(
                          title: Text('Register',
                              style: TextStyle(color: textColor)),
                          onTap: () {
                            Navigator.pushNamed(
                                context, RegisterScreen.routeName);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
