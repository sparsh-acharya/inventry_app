import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventry_app/features/user/presentation/bloc/user_bloc.dart';

class NotificationServices {
  Future<void> initNotifications(BuildContext context) async {
    final messaging = FirebaseMessaging.instance;

    // Request permission from the user
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    // If permission is granted, dispatch the event to get and save the token
    if (settings.authorizationStatus == AuthorizationStatus.authorized || settings.authorizationStatus == AuthorizationStatus.provisional ) {
      context.read<UserBloc>().add(RequestFCMTokenEvent());
    }else{
      AppSettings.openAppSettings();
    }
  }
}
