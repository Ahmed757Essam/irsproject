import 'package:flutter/material.dart';
import 'package:isrprojectnew/api/api_service.dart';

class JobsProvider with ChangeNotifier {
  List<dynamic> _recommendedJobs = [];
  bool _isLoading = false;

  List<dynamic> get recommendedJobs => _recommendedJobs;
  bool get isLoading => _isLoading;

  // Load recommended jobs
  Future<void> loadRecommendedJobs() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _recommendedJobs = await ApiService.getRecommendedJobs();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Create job (admin only)
  Future<void> createJob({
    required String title,
    required String description,
    required String company,
    required String applyUrl,
  }) async {
    try {
      await ApiService.createJob(
        title: title,
        description: description,
        company: company,
        applyUrl: applyUrl,
      );
      await loadRecommendedJobs();
    } catch (e) {
      rethrow;
    }
  }
}