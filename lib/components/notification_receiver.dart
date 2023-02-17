import 'dart:async';

import 'package:cgef/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationReceiver extends ConsumerStatefulWidget {
  const NotificationReceiver({Key? key}) : super(key: key);

  @override
  createState() => _NotificationReceiverState();
}

class _NotificationReceiverState extends ConsumerState<NotificationReceiver> {
  String? cachedText;

  @override
  Widget build(BuildContext context) {
    var notification = ref.watch(notificationProvider);
    if (notification != null) {
      if (cachedText != notification) {
        cachedText = notification;
      }
    }

    return AnimatedOpacity(
      opacity: notification?.isNotEmpty ?? false ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: Text(notification ?? cachedText ?? ''),
    );
  }
}
