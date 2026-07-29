import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  String? _userRole;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get userRole => _userRole;
  User? get user => _supabase.auth.currentUser;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;
      if (session != null) {
        await _fetchUserRole(session.user.id);
      } else {
        _status = AuthStatus.unauthenticated;
        _userRole = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchUserRole(String userId) async {
    try {
      final data = await _supabase
          .from('users')
          .select('role')
          .eq('id', userId)
          .single();
      _userRole = data['role'] as String?;
      _status = AuthStatus.authenticated;
    } catch (e) {
      _errorMessage = 'Failed to fetch user role: $e';
      _status = AuthStatus.error;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.message;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
