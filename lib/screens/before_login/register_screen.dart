import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:isrprojectnew/providers/auth_provider.dart';
import 'package:isrprojectnew/screens/before_login/home.dart';
import 'package:isrprojectnew/screens/before_login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const RegisterScreen());

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register_screen';

  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isDarkMode = true;
  bool isMenuOpen = false;
  String? selectedJobTitle;

  void toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  void toggleMenu() {
    setState(() => isMenuOpen = !isMenuOpen);
  }

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final grayColor = isDarkMode ? const Color(0xff818188) : const Color(0xff8D8D94);
    final notcolor = isDarkMode ? const Color(0xff232326) : const Color(0xffF6F6F7);

    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
                              color: grayColor,
                              onPressed: toggleTheme,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: notcolor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, LoginScreen.routeName);
                                },
                                icon: const Icon(Icons.person, color: Colors.pink),
                                label: Text("Login", style: TextStyle(color: textColor)),
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

                  // Registration Form
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
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                
                                // Email Field
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Email',
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextFormField(
                                        controller: _emailController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Email is required';
                                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                            return 'Enter a valid email';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: notcolor,
                                          hintStyle: TextStyle(color: grayColor),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                        ),
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Username Field
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Username',
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextFormField(
                                        controller: _usernameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Username is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: notcolor,
                                          hintStyle: TextStyle(color: grayColor),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                        ),
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // First Name Field
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'First Name',
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextFormField(
                                        controller: _firstNameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'First name is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: notcolor,
                                          hintStyle: TextStyle(color: grayColor),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                        ),
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Last Name Field
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Last Name',
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextFormField(
                                        controller: _lastNameController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Last name is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: notcolor,
                                          hintStyle: TextStyle(color: grayColor),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                        ),
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Job Title Dropdown
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Job title',
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      DropdownButtonFormField<String>(
                                        value: selectedJobTitle,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: notcolor,
                                          hintText: 'Select a job title',
                                          hintStyle: TextStyle(color: grayColor),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                        ),
                                        items: const [
                                          DropdownMenuItem(value: 'Backend Developer', child: Text('Backend Developer')),
                                          DropdownMenuItem(value: 'Frontend Developer', child: Text('Frontend Developer')),
                                          DropdownMenuItem(value: 'AI Developer', child: Text('AI Developer')),
                                          DropdownMenuItem(value: 'MachineLearning Developer', child: Text('MachineLearning Developer')),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedJobTitle = value;
                                          });
                                        },
                                        dropdownColor: isDarkMode ? Colors.grey[900] : Colors.white,
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                
                                // Password Field
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Password *',
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      TextFormField(
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
                                          filled: true,
                                          fillColor: notcolor,
                                          hintStyle: TextStyle(color: grayColor),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: const BorderSide(color: Colors.transparent),
                                          ),
                                        ),
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                
                                // Sign Up Button
                                SizedBox(
                                  width: 300,
                                  child: ElevatedButton(
                                    onPressed: () async {
  if (_formKey.currentState!.validate()) {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.register(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        username: _usernameController.text,
        jobTitle: selectedJobTitle ?? 'Backend Developer',
        email: _emailController.text,
        password: _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please login.')),
      );
      Navigator.pushNamed(context, LoginScreen.routeName);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }
},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Powered by footer
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
              
              // Menu Drawer
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
                            title: Text('Home', style: TextStyle(color: textColor)),
                            onTap: () {
                              Navigator.pushNamed(context, Home.routeName);
                            },
                          ),
                          ListTile(
                            title: Text('Login', style: TextStyle(color: textColor)),
                            onTap: () {
                              Navigator.pushNamed(context, LoginScreen.routeName);
                            },
                          ),
                          ListTile(
                            title: Text('Register', style: TextStyle(color: textColor)),
                            onTap: toggleMenu,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}