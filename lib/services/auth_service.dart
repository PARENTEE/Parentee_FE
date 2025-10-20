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
          serverClientId:
              "227513971253-77ksvgng2njpa2pltshnp9fdm47bvrbm.apps.googleusercontent.com");
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
        return await ApiService.signInWithGoogle(
            account.email, account.displayName.toString());
      }
      return ApiResponse(
          success: false, message: 'Thoát trong lúc đăng nhập Goole!');
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


// import 'package:dio/dio.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:parentee_fe/features/auth/models/api_response.dart';
// import 'package:parentee_fe/services/api_client.dart';

// class AuthService {
//   // --- Dependencies ---
//   final ApiClient _apiClient;
//   final GoogleSignIn _googleSignIn;

//   // --- Constructor for Dependency Injection ---
//   // This allows us to inject dependencies, making the class testable.
//   // It defaults to using the ApiClient singleton and a standard GoogleSignIn instance.
//   AuthService({
//     ApiClient? apiClient,
//     GoogleSignIn? googleSignIn,
//   })  : _apiClient = apiClient ?? ApiClient(),
//         _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

//   // ------------------------------------------
//   // 🔹 Email & Password Authentication
//   // ------------------------------------------

//   /// Logs in a user with their email and password.
//   Future<ApiResponse> loginWithEmail(String email, String password) async {
//     try {
//       final response = await _apiClient.dio.post(
//         'auth/login', // Your backend endpoint
//         data: {'email': email, 'password': password},
//       );
//       // Assumes your API wraps the actual response data in a 'data' key
//       return ApiResponse(success: true, data: response.data['data']);
//     } on DioException catch (e) {
//       return _handleDioError(e);
//     } catch (e) {
//       return ApiResponse(success: false, message: 'An unexpected error occurred: $e');
//     }
//   }

//   // ------------------------------------------
//   // 🔹 Google Authentication
//   // ------------------------------------------

//   /// Initiates the Google Sign-In flow and then authenticates with your backend.
//   Future<ApiResponse> signInWithGoogle() async {
//     try {
//       // 1. Authenticate with Google to get the user's account details.
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       // If the user cancels the sign-in flow, googleUser will be null.
//       if (googleUser == null) {
//         return ApiResponse(success: false, message: 'Google Sign-In was cancelled.');
//       }

//       // 2. Send Google user info to your backend to get your app's token.
//       return await _signInToBackendWithGoogle(googleUser.email, googleUser.displayName);
//     } catch (error) {
//       print('An unexpected error occurred during Google Sign-In: $error');
//       return ApiResponse(success: false, message: 'A Google Sign-In error occurred.');
//     }
//   }

//   /// Attempts to sign in the user silently without showing a UI.
//   /// Returns a GoogleSignInAccount if successful, otherwise null.
//   Future<GoogleSignInAccount?> attemptSilentSignIn() async {
//     try {
//       // The signInSilently method is the modern way to do this.
//       return await _googleSignIn.signIn();
//     } catch (error) {
//       print('Silent sign-in failed: $error');
//       return null;
//     }
//   }

//   /// Signs the user out of both Google and your application.
//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       // Here you would also clear any locally stored user tokens or session data
//       // for your own app.
//     } catch (error) {
//       print('Error signing out: $error');
//     }
//   }

//   // ------------------------------------------
//   // 🔹 Private Helper Methods
//   // ------------------------------------------

//   /// Private method to call your backend's Google sign-in endpoint.
//   Future<ApiResponse> _signInToBackendWithGoogle(String email, String? displayName) async {
//     try {
//       final response = await _apiClient.dio.post(
//         'auth/google-signin', // <-- REPLACE with your actual backend endpoint
//         data: {'email': email, 'displayName': displayName},
//       );
//       return ApiResponse(success: true, data: response.data['data']);
//     } on DioException catch (e) {
//       return _handleDioError(e);
//     }
//   }

//   /// Handles Dio-specific errors and converts them to a user-friendly ApiResponse.
//   ApiResponse _handleDioError(DioException e) {
//     String message = 'An unknown error occurred.';

//     if (e.type == DioExceptionType.badResponse) {
//       final responseData = e.response?.data;
//       if (responseData is Map<String, dynamic>) {
//         message = responseData['reason'] ?? responseData['message'] ?? 'Invalid request.';
//       } else {
//         message = 'Request failed with status: ${e.response?.statusCode}.';
//       }
//     } else if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
//       message = 'Could not connect to the server. Please check your internet connection.';
//     }
    
//     print('AuthService DIO ERROR: $message');
//     return ApiResponse(success: false, message: message);
//   }
// }