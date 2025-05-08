import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:isrprojectnew/screens/after_login/homeafterlogin.dart';
import 'package:isrprojectnew/screens/after_login/internships.dart';
import 'package:isrprojectnew/screens/before_login/home.dart';
import 'package:provider/provider.dart';
import 'package:isrprojectnew/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'profile_screen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = true;
  bool isMenuOpen = false;
  bool _isLoading = false;

  String? _cvFilePath;
  String? _cvFileName;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.loadUserProfile();
      final profile = authProvider.userProfile;
      if (profile != null && mounted) {
        setState(() {
          _emailController.text = profile['email'] ?? '';
          _usernameController.text = profile['username'] ?? '';
          _firstNameController.text = profile['firstName'] ?? '';
          _lastNameController.text = profile['lastName'] ?? '';
          _jobTitleController.text = profile['jobTitle'] ?? '';
          _cvFileName = profile['resumeUrl'] != null ? 'Resume uploaded' : null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickCVFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && mounted) {
        setState(() {
          _cvFilePath = result.files.single.path;
          _cvFileName = result.files.single.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  void toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  void toggleMenu() {
    setState(() => isMenuOpen = !isMenuOpen);
  }

  bool _validateForm() {
    if (_emailController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final grayColor = isDarkMode ? const Color(0xff818188) : const Color(0xff8D8D94);
    final notcolor = isDarkMode ? const Color(0xff232326) : const Color(0xffF6F6F7);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // AppBar with icons
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

                // Profile Form
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    'Profile',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Email Field
                                  _buildFormField(
                                    label: 'Email',
                                    controller: _emailController,
                                    isRequired: true,
                                  ),
                                  const SizedBox(height: 16),

                                  // Username Field
                                  _buildFormField(
                                    label: 'Username',
                                    controller: _usernameController,
                                    isRequired: true,
                                  ),
                                  const SizedBox(height: 16),

                                  // First Name Field
                                  _buildFormField(
                                    label: 'First Name',
                                    controller: _firstNameController,
                                    isRequired: true,
                                  ),
                                  const SizedBox(height: 16),

                                  // Last Name Field
                                  _buildFormField(
                                    label: 'Last Name',
                                    controller: _lastNameController,
                                    isRequired: true,
                                  ),
                                  const SizedBox(height: 16),

                                  // Job Title Field
                                  _buildFormField(
                                    label: 'Job Title',
                                    controller: _jobTitleController,
                                    isRequired: false,
                                  ),
                                  const SizedBox(height: 16),

                                  // Resume Upload
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Resume / CV',
                                        style: TextStyle(
                                          color: textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: _pickCVFile,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          decoration: BoxDecoration(
                                            color: notcolor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _cvFileName ?? 'No file selected',
                                                style: TextStyle(color: textColor),
                                              ),
                                              const Icon(Icons.attach_file),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      if (_cvFileName != null)
                                        Text(
                                          'Selected: $_cvFileName',
                                          style: const TextStyle(
                                              color: Colors.green, fontSize: 12),
                                        ),
                                    ],
                                  ),

                                  const SizedBox(height: 32),

                                  // Update Profile Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_validateForm()) {
                                          setState(() => _isLoading = true);
                                          try {
                                            final authProvider =
                                                Provider.of<AuthProvider>(context,
                                                    listen: false);
                                            await authProvider.updateProfile(
                                              firstName: _firstNameController.text,
                                              lastName: _lastNameController.text,
                                              email: _emailController.text,
                                              username: _usernameController.text,
                                              resumeFile: _cvFilePath,
                                            );
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        'Profile updated successfully')),
                                              );
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                                ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Failed to update profile: $e')),
                                              );
                                            }
                                          } finally {
                                            if (mounted) {
                                              setState(() => _isLoading = false);
                                            }
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text(
                                              "Update Profile",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),

            // Menu Overlay
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
                            Navigator.pushNamed(context, Homeafterlogin.routeName);
                          },
                        ),
                        ListTile(
                          title: Text('Profile', style: TextStyle(color: textColor)),
                          onTap: toggleMenu,
                        ),
                        ListTile(
                          title:
                              Text('Internships', style: TextStyle(color: textColor)),
                          onTap: () {
                            Navigator.pushNamed(
                                context, InternshipsScreen.routeName);
                          },
                        ),
                        ListTile(
                          title: const Text('Logout',
                              style: TextStyle(color: Colors.red)),
                          onTap: () async {
                            final authProvider = Provider.of<AuthProvider>(context,
                                listen: false);
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
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required bool isRequired,
  }) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final notcolor = isDarkMode ? const Color(0xff232326) : const Color(0xffF6F6F7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: notcolor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(color: textColor),
        ),
      ],
    );
  }
}