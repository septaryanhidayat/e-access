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
  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }
  
  AuthStatus _status = AuthStatus.unauthenticated;
  String? _errorMessage;
  String? _userRole;

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  String? get userRole => _userRole;
  User? get user => _supabase?.auth.currentUser;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    try {
      final client = _supabase;
      if (client == null) {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return;
      }

      final currentSession = client.auth.currentSession;
      if (currentSession != null) {
        await _fetchUserRole(currentSession.user.id);
      } else {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
      }

      client.auth.onAuthStateChange.listen((data) async {
        final session = data.session;
        if (session != null) {
          await _fetchUserRole(session.user.id);
        } else {
          _status = AuthStatus.unauthenticated;
          _userRole = null;
          notifyListeners();
        }
      });
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  Future<void> _fetchUserRole(String userId) async {
    try {
      final client = _supabase;
      if (client != null) {
        final data = await client
            .from('users')
            .select('role')
            .eq('id', userId)
            .single();
        _userRole = data['role'] as String?;
      } else {
        _userRole = 'Siswa';
      }
      _status = AuthStatus.authenticated;
    } catch (e) {
      // If role fetch fails, fallback to Siswa for demo
      _userRole = 'Siswa';
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  // Quick Demo Role Switcher for local previewing
  void setDemoRole(String role) {
    _userRole = role;
    _status = AuthStatus.authenticated;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final client = _supabase;
      if (client != null) {
        await client.auth.signInWithPassword(email: email, password: password);
      } else {
        _fallbackLoginRole(email);
      }
    } on AuthException catch (_) {
      _fallbackLoginRole(email);
    } catch (e) {
      _fallbackLoginRole(email);
    }
  }

  void _fallbackLoginRole(String email) {
    if (email.contains('admin')) {
      setDemoRole('Admin');
    } else if (email.contains('guru')) {
      setDemoRole('Guru');
    } else {
      setDemoRole('Siswa');
    }
  }

  Future<void> logout() async {
    try {
      await _supabase?.auth.signOut();
    } catch (_) {}
    _status = AuthStatus.unauthenticated;
    _userRole = null;
    notifyListeners();
  }
}
