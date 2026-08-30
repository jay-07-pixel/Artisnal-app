import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_initializer.dart';

/// Sign-up and sign-in with a username and password.
///
/// Supabase Auth requires an email, so usernames map to an internal address:
/// `{username}@artisanlens.app`. Artisans only see their username in the UI.
class AuthService {
  AuthService({SupabaseClient? client}) : _client = client ?? supabaseClient;

  final SupabaseClient? _client;

  bool get isAvailable => _client != null;

  User? get currentUser => _client?.auth.currentUser;

  Stream<AuthState> get authStateChanges =>
      _client?.auth.onAuthStateChange ??
      Stream.value(const AuthState(AuthChangeEvent.signedOut, null));

  static String normalizeUsername(String raw) =>
      raw.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]'), '');

  static String emailForUsername(String username) =>
      '${normalizeUsername(username)}@artisanlens.app';

  static String? validateUsername(String raw) {
    final username = normalizeUsername(raw);
    if (username.length < 3) {
      return 'Username must be at least 3 letters or numbers.';
    }
    if (username.length > 32) {
      return 'Username must be 32 characters or fewer.';
    }
    return null;
  }

  static String? validatePassword(String raw) {
    if (raw.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  String? usernameFromUser(User? user) {
    if (user == null) return null;
    final meta = user.userMetadata?['username'] as String?;
    if (meta != null && meta.trim().isNotEmpty) return meta.trim();
    final email = user.email ?? '';
    if (email.endsWith('@artisanlens.app')) {
      return email.split('@').first;
    }
    return user.email;
  }

  Future<void> signUp({
    required String username,
    required String password,
  }) async {
    final client = _client;
    if (client == null) {
      throw const AuthException('Cloud sign-in is not configured on this build.');
    }

    final normalized = normalizeUsername(username);
    final usernameError = validateUsername(username);
    if (usernameError != null) throw AuthException(usernameError);
    final passwordError = validatePassword(password);
    if (passwordError != null) throw AuthException(passwordError);

    final response = await client.auth.signUp(
      email: emailForUsername(normalized),
      password: password,
      data: {
        'username': normalized,
        'display_name': normalized,
      },
    );

    if (response.user == null) {
      throw const AuthException('Could not create your account. Try again.');
    }
  }

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    final client = _client;
    if (client == null) {
      throw const AuthException('Cloud sign-in is not configured on this build.');
    }

    final normalized = normalizeUsername(username);
    if (validateUsername(username) != null) {
      throw const AuthException('Enter a valid username.');
    }

    await client.auth.signInWithPassword(
      email: emailForUsername(normalized),
      password: password,
    );
  }

  Future<void> signOut() async {
    final client = _client;
    if (client == null) return;
    await client.auth.signOut();
  }
}
