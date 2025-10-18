import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../utils/dummy_data.dart';

final authServiceProvider = ChangeNotifierProvider<AuthService>((ref) {
  return AuthService();
});

class AuthService extends ChangeNotifier {
  AuthService();

  UserModel? _currentUser;

  bool get isLoggedIn => _currentUser != null;
  UserModel? get currentUser => _currentUser;

  Future<UserModel> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _currentUser = DummyData.demoUser.copyWith(email: email);
    notifyListeners();
    return _currentUser!;
  }

  Future<UserModel> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    _currentUser = DummyData.demoUser.copyWith(
      email: email,
      displayName: name,
      isEmailVerified: false,
    );
    notifyListeners();
    return _currentUser!;
  }

  Future<void> sendEmailVerification() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  Future<void> markEmailVerified() async {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(isEmailVerified: true);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
}
