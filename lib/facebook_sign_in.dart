// facebook_sign_in.dart
//
// File with functions to communincate with native platform and define functions to use in Flutter code.

import 'dart:async';

import 'package:flutter/services.dart';

class FacebookSignIn {
    static const MethodChannel _channel =
        const MethodChannel('facebook_sign_in');

    /// Login with read permissions.
    /// 
    /// Logs the user in with a list of read permissions to provide.
    static Future<FacebookLoginResult> loginWithReadPermissions(List<String> permissions) async {
        final Map<String, dynamic> result = await _channel.invokeMethod("loginWithReadPermissions", <String, List<String>> {
            "permissions": permissions
        });
        return new FacebookLoginResult._(result);
    }

    /// Login with publish permissions.
    /// 
    /// Logs the user in with a list of publish permissions to provide.
    static Future<String> loginWithPublishPermissions(List<String> permissions) {
        return _channel.invokeMethod("loginWithPublishPermissions", <String, List<String>> {
            "permissions": permissions
        });
    }

    /// Logout user.
    static Future<String> logout() {
        return _channel.invokeMethod("logout");
    }

    static Future<bool> isLoggedIn() {
        return _channel.invokeMethod("isLoggedIn");
    }

    static Future<String> getToken() {
        return _channel.invokeMethod("getToken");
    }
}

/// The result when the Facebook login flow has completed.
///
/// The login methods always return an instance of this class, whether the
/// user logged in, cancelled or the login resulted in an error. To handle
/// the different possible scenarios, first see what the [status] is.
///
/// To see a comprehensive example on how to handle the different login
/// results, see the [FacebookLogin] class-level documentation.
class FacebookLoginResult {
  /// The status after a Facebook login flow has completed.
  ///
  /// This affects the [accessToken] and [errorMessage] variables and whether
  /// they're available or not. If the user cancelled the login flow, both
  /// [accessToken] and [errorMessage] are null.
  final FacebookLoginStatus status;

  /// The access token for using the Facebook APIs, obtained after the user has
  /// successfully logged in.
  ///
  /// Only available when the [status] equals [FacebookLoginStatus.loggedIn],
  /// otherwise null.
  final FacebookAccessToken accessToken;

  /// The error message when the log in flow completed with an error.
  ///
  /// Only available when the [status] equals [FacebookLoginStatus.error],
  /// otherwise null.
  final String errorMessage;

  FacebookLoginResult._(Map<String, dynamic> map)
      : status = _parseStatus(map['status']),
        accessToken = map['accessToken'] != null
            ? new FacebookAccessToken.fromMap(map['accessToken'])
            : null,
        errorMessage = map['errorMessage'];

  static FacebookLoginStatus _parseStatus(String status) {
    switch (status) {
      case 'loggedIn':
        return FacebookLoginStatus.loggedIn;
      case 'cancelledByUser':
        return FacebookLoginStatus.cancelledByUser;
      case 'error':
        return FacebookLoginStatus.error;
    }

    throw new StateError('Invalid status: $status');
  }
}

/// The status after a Facebook login flow has completed.
enum FacebookLoginStatus {
  /// The login was successful and the user is now logged in.
  loggedIn,

  /// The user cancelled the login flow, usually by closing the Facebook
  /// login dialog.
  cancelledByUser,

  /// The Facebook login completed with an error and the user couldn't log
  /// in for some reason.
  error,
}

/// The access token for using Facebook APIs.
///
/// Includes the token itself, along with useful metadata about it, such as the
/// associated user id, expiration date and permissions that the token contains.
class FacebookAccessToken {
  /// The access token returned by the Facebook login, which can be used to
  /// access Facebook APIs.
  final String token;

  /// The id for the user that is associated with this access token.
  final String userId;

  /// The date when this access token expires.
  final DateTime expires;

  /// The list of accepted permissions associated with this access token.
  ///
  /// These are the permissions that were requested with last login, and which
  /// the user approved. If permissions have changed since the last login, this
  /// list might be outdated.
  final List<String> permissions;

  /// The list of declined permissions associated with this access token.
  ///
  /// These are the permissions that were requested, but the user didn't
  /// approve. Similarly to [permissions], this list might be outdated if these
  /// permissions have changed since the last login.
  final List<String> declinedPermissions;

  /// Constructs a new access token instance from a [Map].
  ///
  /// This is used mostly internally by this library, but could be useful if
  /// storing the token locally by using the [toMap] method.
  FacebookAccessToken.fromMap(Map<String, dynamic> map)
      : token = map['token'],
        userId = map['userId'],
        expires = new DateTime.fromMillisecondsSinceEpoch(
          map['expires'],
          isUtc: true,
        ),
        permissions = map['permissions'],
        declinedPermissions = map['declinedPermissions'];

  /// Transforms this access token to a [Map].
  ///
  /// This could be useful for encoding this access token as JSON and then
  /// storing it locally.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'userId': userId,
      'expires': expires.millisecondsSinceEpoch,
      'permissions': permissions,
      'declinedPermissions': declinedPermissions,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FacebookAccessToken &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          userId == other.userId &&
          expires == other.expires &&
          permissions == other.permissions &&
          declinedPermissions == other.declinedPermissions;

  @override
  int get hashCode =>
      token.hashCode ^
      userId.hashCode ^
      expires.hashCode ^
      permissions.hashCode ^
      declinedPermissions.hashCode;
}