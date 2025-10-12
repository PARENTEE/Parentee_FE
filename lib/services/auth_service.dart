import 'package:google_sign_in/google_sign_in.dart';
import 'package:parentee_fe/features/auth/models/api_response.dart';
import 'package:parentee_fe/services/api_service.dart';

class AuthService {
  static final _googleSignIn = GoogleSignIn.instance;
  static bool _isGoogleSignInInitialized = false;

  AuthService() {
    _initializeGoogleSignIn();
  }

  static Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: "227513971253-77ksvgng2njpa2pltshnp9fdm47bvrbm.apps.googleusercontent.com"
      );
      _isGoogleSignInInitialized = true;
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  /// Always check Google sign in initialization before use
  static Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  static Future<ApiResponse> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    try {
      // authenticate() throws exceptions instead of returning null
      final GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: ['email'], // Specify required scopes
      );
      // Get current account
      if (account != null) {
        // Sign in to BE to get token
        return await ApiService.signInWithGoogle(account.email, account.displayName.toString());
      }
      return ApiResponse(success: false, message: 'Thoát trong lúc đăng nhập Goole!');
    } on GoogleSignInException catch (e) {
      print(
        'Google Sign In error: code: ${e.code.name} description:${e.description} details:${e.details}',
      );
      rethrow;
    } catch (error) {
      print('Unexpected Google Sign-In error: $error');
      rethrow;
    }
  }

  static Future<GoogleSignInAccount?> attemptSilentSignIn() async {
    await _ensureGoogleSignInInitialized();

    try {
      // attemptLightweightAuthentication can return Future or immediate result
      final result = _googleSignIn.attemptLightweightAuthentication();

      // Handle both sync and async returns
      if (result is Future<GoogleSignInAccount?>) {
        return await result;
      } else {
        return result as GoogleSignInAccount?;
      }
    } catch (error) {
      print('Silent sign-in failed: $error');
      return null;
    }
  }

  static GoogleSignInAuthentication getAuthTokens(GoogleSignInAccount account) {
    // authentication is now synchronous
    return account.authentication;
  }

  static Future<String?> getAccessTokenForScopes(List<String> scopes) async {
    await _ensureGoogleSignInInitialized();

    try {
      final authClient = _googleSignIn.authorizationClient;

      // Try to get existing authorization
      var authorization = await authClient.authorizationForScopes(scopes);

      authorization ??= await authClient.authorizeScopes(scopes);

      return authorization?.accessToken;
    } catch (error) {
      print('Failed to get access token for scopes: $error');
      return null;
    }
  }
}
