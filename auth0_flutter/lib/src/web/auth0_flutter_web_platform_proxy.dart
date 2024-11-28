import 'dart:js_util';
import 'js_interop.dart';

class Auth0FlutterWebClientProxy {
  final Auth0Client client;

  Auth0FlutterWebClientProxy({required this.client});

  Future<void> loginWithRedirect(final RedirectLoginOptions options) async {
    try {
      await promiseToFuture(client.loginWithRedirect(options));
    } catch (e) {
      print('@@@@@@@@@@Error in loginWithRedirect: $e');
    }
  }

  Future<void> loginWithPopup(
      [final PopupLoginOptions? options,
      final PopupConfigOptions? config]) async {
    try {
      await promiseToFuture(client.loginWithPopup(options, config));
    } catch (e) {
      print('@@@@@@@@@@Error in loginWithPopup: $e');
    }
  }

  Future<void> checkSession() async {
    try {
      await promiseToFuture(client.checkSession());
    } catch (e) {
      print('@@@@@@@@@@Error in checkSession: $e');
    }
  }

  Future<WebCredentials> getTokenSilently(
      [final GetTokenSilentlyOptions? options]) async {
    try {
      return await promiseToFuture(client.getTokenSilently(options));
    } catch (e) {
      print('@@@@@@@@@@Error in getTokenSilently: $e');
      rethrow;
    }
  }

  Future<void> handleRedirectCallback() async {
    try {
      await promiseToFuture(client.handleRedirectCallback());
    } catch (e) {
      print('@@@@@@@@@@Error in handleRedirectCallback: $e');
    }
  }

  Future<bool> isAuthenticated() async {
    try {
      return await promiseToFuture(client.isAuthenticated());
    } catch (e) {
      print('@@@@@@@@@@Error in isAuthenticated: $e');
      rethrow;
    }
  }

  Future<void> logout(final LogoutOptions? options) async {
    try {
      await promiseToFuture(client.logout(options));
    } catch (e) {
      print('@@@@@@@@@@Error in logout: $e');
    }
  }
}
