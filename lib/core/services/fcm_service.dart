import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:m2health/const.dart';
import 'package:m2health/route/app_routes.dart';
import 'package:m2health/route/navigator_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FcmService {
  final Dio _dio;
  final SharedPreferences _prefs;

  FcmService(this._dio, this._prefs);

  Future<void> init() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) return;

    await _registerToken();

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_navigateToAppointment);

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _navigateToAppointment(initialMessage);
    }
  }

  Future<void> registerTokenIfLoggedIn() async {
    await _registerToken();
  }

  Future<void> _registerToken() async {
    final authToken = _prefs.getString(Const.TOKEN);
    if (authToken == null) return;

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken == null) return;

    final platform = Platform.isAndroid ? 'android' : 'ios';

    try {
      await _dio.post(
        Const.API_DEVICE_TOKENS,
        data: {'token': fcmToken, 'platform': platform},
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );
    } catch (e) {
      // Token registration failure is non-critical; notifications will still work
      // until the next successful registration
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(notification.body ?? ''),
          ],
        ),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => _navigateToAppointment(message),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _navigateToAppointment(RemoteMessage message) {
    final appointmentIdStr = message.data['appointmentId'];
    if (appointmentIdStr == null) return;

    final appointmentId = int.tryParse(appointmentIdStr);
    if (appointmentId == null) return;

    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    context.push(AppRoutes.appointmentDetail, extra: appointmentId);
  }
}
