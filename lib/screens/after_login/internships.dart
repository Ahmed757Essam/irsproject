import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:isrprojectnew/providers/auth_provider.dart';
import 'package:isrprojectnew/screens/after_login/homeafterlogin.dart';
import 'package:isrprojectnew/screens/after_login/profile.dart';
import 'package:isrprojectnew/screens/before_login/home.dart';
import 'package:provider/provider.dart';
import 'package:isrprojectnew/providers/jobs_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class InternshipsScreen extends StatefulWidget {
  static const String routeName = 'internships_screen';

  const InternshipsScreen({super.key});

  @override
  State<InternshipsScreen> createState() => _InternshipsScreenState();
}

class _InternshipsScreenState extends State<InternshipsScreen> {
  bool isDarkMode = true;
  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadJobs();
    });
  }

  Future<void> _loadJobs() async {
    final jobsProvider = Provider.of<JobsProvider>(context, listen: false);
    if (jobsProvider.recommendedJobs.isEmpty) {
      await jobsProvider.loadRecommendedJobs();
    }
  }

  void toggleTheme() {
    setState(() => isDarkMode = !isDarkMode);
  }

  void toggleMenu() {
    setState(() => isMenuOpen = !isMenuOpen);
  }

  Future<void> _launchApplyUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch the apply URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobsProvider = Provider.of<JobsProvider>(context);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? Colors.black : Colors.white;
    final grayColor = isDarkMode ? const Color(0xff818188) : const Color(0xff8D8D94);
    final cardColor = isDarkMode ? const Color(0xff232326) : const Color(0xffF6F6F7);

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
                        Text('IRS',
                            style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 30)),
                      ],
                    ),
                    // Icons
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.dataset_linked_outlined, color: grayColor),
                          onPressed: () async {
                            const url = 'https://www.linkedin.com';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url),
                                  mode: LaunchMode.externalApplication);
                            }
                          },
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

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recommended for you',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),

              // Internships List
              Expanded(
                child: jobsProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : jobsProvider.recommendedJobs.isEmpty
                        ? Center(
                            child: Text(
                              'No recommended jobs found',
                              style: TextStyle(color: textColor),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadJobs,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: jobsProvider.recommendedJobs.length,
                              itemBuilder: (context, index) {
                                final job = jobsProvider.recommendedJobs[index];
                                return _buildInternshipCard(
                                  title: job['title'] ?? 'No title',
                                  type: 'Intern',
                                  company: job['company'] ?? 'No company',
                                  location: 'Remote', // Default location
                                  description: job['description'] ?? 'No description',
                                  applyUrl: job['applyUrl'],
                                );
                              },
                            ),
                          ),
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
                          Navigator.pushNamed(context, Homeafterlogin.routeName);
                        },
                      ),
                      ListTile(
                        title: Text('Profile', style: TextStyle(color: textColor)),
                        onTap: () {
                          Navigator.pushNamed(context, ProfileScreen.routeName);
                        },
                      ),
                      ListTile(
                        title:
                            Text('Internships', style: TextStyle(color: textColor)),
                        onTap: toggleMenu,
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
    );
  }

  Widget _buildInternshipCard({
    required String title,
    required String type,
    required String company,
    required String location,
    required String description,
    String? applyUrl,
  }) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor = isDarkMode ? const Color(0xff232326) : const Color(0xffF6F6F7);

    return Card(
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.work_outline, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '$type • $company, $location',
                      style: TextStyle(color: textColor.withOpacity(0.7)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'About $company',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description.length > 150
                  ? '${description.substring(0, 150)}...'
                  : description,
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (applyUrl != null && applyUrl.isNotEmpty)
                  ElevatedButton(
                    onPressed: () => _launchApplyUrl(applyUrl),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Apply Now', style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}