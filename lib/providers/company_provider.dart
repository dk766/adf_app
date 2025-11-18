import 'package:flutter/foundation.dart';
import '../models/company.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class CompanyProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  List<Company> _companies = [];
  Company? _selectedCompany;
  bool _isLoading = false;
  String? _error;

  List<Company> get companies => _companies;
  Company? get selectedCompany => _selectedCompany;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCompanies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _companies = await _apiService.getCompanies();

      // Try to restore previously selected company
      final savedCif = _storageService.getSelectedCompanyCif();
      if (savedCif != null) {
        _selectedCompany = _companies.firstWhere(
          (c) => c.cif == savedCif,
          orElse: () => _companies.isNotEmpty ? _companies.first : throw Exception('No companies'),
        );
      } else if (_companies.isNotEmpty) {
        _selectedCompany = _companies.first;
        await _storageService.saveSelectedCompanyCif(_selectedCompany!.cif);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectCompany(Company company) async {
    _selectedCompany = company;
    await _storageService.saveSelectedCompanyCif(company.cif);
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
