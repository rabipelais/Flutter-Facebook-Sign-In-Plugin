import 'dart:async';

import 'package:flutter/services.dart';

class FacebookSignIn {
    static const MethodChannel _channel =
        const MethodChannel('facebook_sign_in');

    static Future<String> login() {
        return _channel.invokeMethod("login");
    }


    // A list of permissions can be found here: 
    //  https://developers.facebook.com/docs/facebook-login/permissions#permissions

    static Future<String> loginWithReadPermissions(List<String> permissions) {
        return _channel.invokeMethod("loginWithReadPermissions", <String, List<String>> {
            "permissions": permissions
        });
    }

    static Future<String> loginWithPublishPermissions(List<String> permissions) {
        return _channel.invokeMethod("loginWithPublishPermissions", <String, List<String>> {
            "permissions": permissions
        });
    }

    static Future<String> logout() {
        return _channel.invokeMethod("logout");
    }
}