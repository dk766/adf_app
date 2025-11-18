import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Secure storage for sensitive data
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConfig.keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConfig.keyToken);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: AppConfig.keyToken);
  }

  // Regular storage for non-sensitive data
  Future<void> saveBaseUrl(String url) async {
    await _prefs?.setString(AppConfig.keyBaseUrl, url);
  }

  String getBaseUrl() {
    return _prefs?.getString(AppConfig.keyBaseUrl) ?? AppConfig.defaultBaseUrl;
  }

  Future<void> saveUsername(String username) async {
    await _prefs?.setString(AppConfig.keyUsername, username);
  }

  String? getUsername() {
    return _prefs?.getString(AppConfig.keyUsername);
  }

  Future<void> saveSelectedCompanyCif(String cif) async {
    await _prefs?.setString(AppConfig.keySelectedCompanyCif, cif);
  }

  String? getSelectedCompanyCif() {
    return _prefs?.getString(AppConfig.keySelectedCompanyCif);
  }

  Future<void> saveUserLogo(String path) async {
    await _prefs?.setString(AppConfig.keyUserLogo, path);
  }

  String? getUserLogo() {
    return _prefs?.getString(AppConfig.keyUserLogo);
  }

  Future<void> saveUserInfo(String info) async {
    await _prefs?.setString(AppConfig.keyUserInfo, info);
  }

  String? getUserInfo() {
    return _prefs?.getString(AppConfig.keyUserInfo);
  }

  // Clear all data (logout)
  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    await _prefs?.clear();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
