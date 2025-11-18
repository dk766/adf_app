import 'package:flutter/foundation.dart';
import '../models/auth_token.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  AuthStatus _status = AuthStatus.initial;
  String? _error;
  String? _username;

  AuthStatus get status => _status;
  String? get error => _error;
  String? get username => _username;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final isLoggedIn = await _storageService.isLoggedIn();
    if (isLoggedIn) {
      _username = _storageService.getUsername();
      _status = AuthStatus.authenticated;
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _status = AuthStatus.loading;
    _error = null;
    notifyListeners();

    try {
      final AuthToken authToken = await _apiService.login(username, password);
      await _storageService.saveToken(authToken.token);
      await _storageService.saveUsername(username);

      _username = username;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    _username = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
