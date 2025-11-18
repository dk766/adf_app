import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class SettingsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  String _baseUrl = '';
  String? _userLogo;
  String? _userInfo;

  String get baseUrl => _baseUrl;
  String? get userLogo => _userLogo;
  String? get userInfo => _userInfo;

  void loadSettings() {
    _baseUrl = _storageService.getBaseUrl();
    _userLogo = _storageService.getUserLogo();
    _userInfo = _storageService.getUserInfo();
    notifyListeners();
  }

  Future<void> updateBaseUrl(String newUrl) async {
    await _storageService.saveBaseUrl(newUrl);
    _baseUrl = newUrl;
    _apiService.updateBaseUrl(newUrl);
    notifyListeners();
  }

  Future<void> updateUserLogo(String logoPath) async {
    await _storageService.saveUserLogo(logoPath);
    _userLogo = logoPath;
    notifyListeners();
  }

  Future<void> updateUserInfo(String info) async {
    await _storageService.saveUserInfo(info);
    _userInfo = info;
    notifyListeners();
  }

  Future<void> clearUserLogo() async {
    await _storageService.saveUserLogo('');
    _userLogo = null;
    notifyListeners();
  }
}
