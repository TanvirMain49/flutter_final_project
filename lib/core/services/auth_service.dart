import 'package:supabase_flutter/supabase_flutter.dart';


class AuthService {
  static final _supabase = Supabase.instance.client;


  Future<AuthResponse> signUpWithEmailAndPassword(String email, String password) async {
    return await _supabase.auth.signUp( email: email,password: password);
  }

  Future<AuthResponse> signInWithEmailAndPassword( String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  void signOut() async {
    await _supabase.auth.signOut();
  }

  // CURRENT USER
  User? get currentUser => _supabase.auth.currentUser;
}