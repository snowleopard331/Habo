import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:habo/constants.dart';
import 'package:habo/generated/l10n.dart';

bool platformSupportsNotifications() => Platform.isAndroid || Platform.isIOS;

void initializeNotifications() {
  AwesomeNotifications().initialize(
    'resource://raw/res_app_icon',
    [
      NotificationChannel(
          channelKey: 'app_notifications_habo',
          channelName: 'App notifications',
          channelDescription:
              'Notification channel for application notifications',
          defaultColor: HaboColors.primary,
          importance: NotificationImportance.Max,
          criticalAlerts: true),
      NotificationChannel(
          channelKey: 'habit_notifications_habo',
          channelName: 'Habit notifications',
          channelDescription: 'Notification channel for habit notifications',
          defaultColor: HaboColors.primary,
          importance: NotificationImportance.Max,
          criticalAlerts: true)
    ],
  );
}

void resetAppNotificationIfMissing(TimeOfDay timeOfDay) async {
  AwesomeNotifications().listScheduledNotifications().then((notifications) {
    // 遍历通知列表
    for (var not in notifications) {
      // 如果通知的内容的id为0，则返回
      if (not.content?.id == 0) {
        return;
      }
    }
    setAppNotification(timeOfDay);
  });
}

void setAppNotification(TimeOfDay timeOfDay) async {
  _setupDailyNotification(0, timeOfDay, 'Habo',
      S.current.doNotForgetToCheckYourHabits, 'app_notifications_habo');
}

void setHabitNotification(
    int id, TimeOfDay timeOfDay, String title, String desc) {
  _setupDailyNotification(
      id, timeOfDay, title, desc, 'habit_notifications_habo');
}

void disableHabitNotification(int id) {
  if (platformSupportsNotifications()) {
    AwesomeNotifications().cancel(id);
  }
}

void disableAppNotification() {
  AwesomeNotifications().cancel(0);
}

// 这是一个异步函数，用于设置每日通知
// id：通知的唯一标识符。
// timeOfDay：通知触发的时间。
// title：通知的标题。
// desc：通知的描述内容。
// channel：通知渠道的键值
Future<void> _setupDailyNotification(int id, TimeOfDay timeOfDay, String title,
    String desc, String channel) async {
  // 平台支持检查
  if (platformSupportsNotifications()) {
    // 获取本地时区标识符
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    // 创建通知内容
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: channel,
        title: title,
        body: desc,
        wakeUpScreen: true,
        criticalAlert: true,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar(
          hour: timeOfDay.hour,
          minute: timeOfDay.minute,
          second: 0,
          millisecond: 0,
          repeats: true,
          preciseAlarm: true,
          timeZone: localTimeZone),
    );
  }
}
