import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uni_links3/uni_links.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  late Auth0 auth0;
  Credentials? credentials;
  final _storage = FlutterSecureStorage();

  AuthService._internal() {
    auth0 = Auth0(
      dotenv.env['AUTH0_DOMAIN']!,
      dotenv.env['AUTH0_CLIENT_ID']!,
    );
  }

  Future<bool> checkAuthStatus() async {
    final storedAccessToken = await _storage.read(key: 'access_token');
    if (storedAccessToken != null) {
      try {
        // Validate token and refresh if needed
        final userInfo =
            await auth0.api.userProfile(accessToken: storedAccessToken);
        return true;
      } catch (e) {
        await _storage.delete(key: 'access_token');
        return false;
      }
    }
    return false;
  }

  Future<void> login() async {
    try {
      credentials = await auth0.webAuthentication(scheme: "scheme").login(
        parameters: {
          'connection': 'EXCO-Okta-Dev',
          'audience': "https://exco-automation.afxm.local/",
          'scope': 'openid profile email offline_access',
        },
        redirectUrl:
            'scheme://id.uat.afreximbank.net/android/com.afreximbank.exco/callback',
      );

      print("========================================================");
      logInChunks(credentials?.accessToken ?? '');
      print("==================");
      logInChunks(credentials?.refreshToken ?? '');
      print("==================");
      logInChunks(credentials?.idToken ?? '');
      print("========================================================");

      // Store credentials securely
      await _storage.write(
        key: 'access_token',
        value: credentials?.accessToken,
      );

      if (credentials?.refreshToken != null) {
        await _storage.write(
          key: 'refresh_token',
          value: credentials?.refreshToken,
        );
      }

      print('Logged in successfully');
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await auth0.webAuthentication(scheme: "scheme").logout();

      // Clear stored credentials
      await _storage.deleteAll();
      credentials = null;

      print('Logged out successfully');
    } catch (e) {
      print('Logout error: $e');
      rethrow;
    }
  }

  void logInChunks(String message, {int chunkSize = 1024}) {
    for (int i = 0; i < message.length; i += chunkSize) {
      int end =
          (i + chunkSize < message.length) ? i + chunkSize : message.length;
      print(message.substring(i, end));
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // void initUniLinks() async {
  //   try {
  //     final initialLink = await getInitialLink();
  //     if (initialLink != null) {
  //       _handleDeepLink(initialLink);
  //     }
  //   } on PlatformException {
  //     // Handle exception
  //   }

  //   linkStream.listen((String? link) {
  //     if (link != null) {
  //       _handleDeepLink(link);
  //     }
  //   }, onError: (err) {
  //     // Handle error
  //   });
  // }

  // void _handleDeepLink(String link) {
  //   // Handle the deep link
  //   print(
  //       '===================&&&&&&&&&&&&&&&============Received deep link: $link');
  //   // Add your logic to handle the deep link
  // }

  bool get isAuthenticated => credentials != null;
}
