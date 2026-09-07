import 'package:flutter/foundation.dart';
import '../models/user_role.dart';

class AuthProvider extends ChangeNotifier {
  UserRole _selectedRole = UserRole.patient;
  bool _isLoading = false;
  String? _errorMessage;

  UserRole get selectedRole => _selectedRole;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: replace this with a real call to your FastAPI backend, e.g.
      // final response = await http.post(
      //   Uri.parse('http://<your-backend-ip>:8000/login'),
      //   body: {
      //     'email': email,
      //     'password': password,
      //     'role': _selectedRole.name,
      //   },
      // );
      // if (response.statusCode != 200) {
      //   _errorMessage = 'Invalid email or password';
      //   return false;
      // }

      await Future.delayed(const Duration(seconds: 1)); // simulated network call

      if (email.isEmpty || password.isEmpty) {
        _errorMessage = 'Please enter both email and password';
        return false;
      }
      return true; // simulated success
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
//Log Out method
void logout() {
  _errorMessage = null;
  _isLoading = false;
  notifyListeners();
}
}