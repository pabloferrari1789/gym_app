import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/spreadsheets.readonly',
      'https://www.googleapis.com/auth/drive.readonly',
    ],
  );
});

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<GoogleSignInAccount?>>(
  (ref) => AuthNotifier(ref.watch(googleSignInProvider)),
);

class AuthNotifier
    extends StateNotifier<AsyncValue<GoogleSignInAccount?>> {
  final GoogleSignIn _googleSignIn;

  AuthNotifier(this._googleSignIn) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final account = await _googleSignIn.signInSilently();
      state = AsyncValue.data(account);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signIn() async {
    state = const AsyncValue.loading();
    try {
      final account = await _googleSignIn.signIn();
      state = AsyncValue.data(account);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    state = const AsyncValue.data(null);
  }
}
