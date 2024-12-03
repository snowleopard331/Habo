import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:habo/constants.dart';
import 'package:habo/model/settings_data.dart';
import 'package:habo/notifications.dart';
import 'package:habo/themes.dart';
import 'package:just_audio/just_audio.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager extends ChangeNotifier {
  // 获取SharedPreferences实例
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // 初始化SettingsData
  SettingsData _settingsData = SettingsData();
  // 声明一个布尔类型的变量，用于判断是否已经初始化
  bool _isInitialized = false;

  // 创建一个音频播放器，用于播放检查声音
  final _checkPlayer = AudioPlayer(handleAudioSessionActivation: false);
  // 创建一个音频播放器，用于播放点击声音
  final _clickPlayer = AudioPlayer(handleAudioSessionActivation: false);

  void initialize() async {
    // 等待加载数据
    await loadData();
    _isInitialized = true;
    notifyListeners();
    _checkPlayer.setAsset('assets/sounds/check.wav');
    _clickPlayer.setAsset('assets/sounds/click.wav');
  }

  @override
  void dispose() {
    // 释放_checkPlayer资源
    _checkPlayer.dispose();
    // 释放_clickPlayer资源
    _clickPlayer.dispose();
    // 调用父类的dispose方法
    super.dispose();
  }

  // 重置应用程序通知
  resetAppNotification() {
    // 如果设置中显示每日通知
    if (_settingsData.showDailyNot) {
      // 如果缺少每日通知时间，则重置应用程序通知
      resetAppNotificationIfMissing(_settingsData.dailyNotTime);
    }
  }

  // 播放检查声音
  playCheckSound() {
    // 如果设置中开启了声音效果
    if (_settingsData.soundEffects) {
      // 设置播放器的开始和结束时间
      _checkPlayer.setClip(
          start: const Duration(seconds: 0), end: const Duration(seconds: 2));
      // 播放声音
      _checkPlayer.play();
    }
  }

  // 播放点击声音
  playClickSound() {
    // 如果设置中开启了声音效果
    if (_settingsData.soundEffects) {
      // 设置点击声音的播放范围
      _clickPlayer.setClip(
          start: const Duration(seconds: 0), end: const Duration(seconds: 2));
      // 播放点击声音
      _clickPlayer.play();
    }
  }

  // 异步保存数据
  void saveData() async {
    // 获取SharedPreferences实例
    final SharedPreferences prefs = await _prefs;
    // 将_settingsData转换为JSON字符串并保存到SharedPreferences中
    prefs.setString('habo_settings', jsonEncode(_settingsData));
  }

  // 异步加载数据
  Future<void> loadData() async {
    // 获取SharedPreferences实例
    final SharedPreferences prefs = await _prefs;
    // 获取habo_settings的值
    String? json = prefs.getString('habo_settings');
    // 如果habo_settings的值不为空
    if (json != null) {
      // 将json字符串解析为SettingsData对象
      _settingsData = SettingsData.fromJson(jsonDecode(json));
    }
  }

  // 获取深色主题
  ThemeData get getDark {
    // 根据设置数据中的主题类型，返回相应的主题
    switch (_settingsData.theme) {
      case Themes.device:
        // 如果主题类型为设备默认，则返回深色主题
        return HaboTheme.darkTheme;
      // 如果主题为亮色
      case Themes.light:
        // 返回亮色主题
        return HaboTheme.lightTheme;
      // 如果主题为暗色
      case Themes.dark:
        // 返回暗色主题
        return HaboTheme.darkTheme;
      // 如果主题为OLED
      case Themes.oled:
        // 返回OLED主题
        return HaboTheme.oledTheme;
      // 默认返回暗色主题
      default:
        return HaboTheme.darkTheme;
    }
  }

  ThemeData get getLight {
    switch (_settingsData.theme) {
      case Themes.device:
        return HaboTheme.lightTheme;
      case Themes.light:
        return HaboTheme.lightTheme;
      case Themes.dark:
        return HaboTheme.darkTheme;
      case Themes.oled:
        return HaboTheme.oledTheme;
      default:
        return HaboTheme.lightTheme;
    }
  }

  Themes get getThemeString {
    return _settingsData.theme;
  }

  StartingDayOfWeek get getWeekStartEnum {
    return _settingsData.weekStart;
  }

  TimeOfDay get getDailyNot {
    return _settingsData.dailyNotTime;
  }

  bool get getShowDailyNot {
    return _settingsData.showDailyNot;
  }

  bool get getSoundEffects {
    return _settingsData.soundEffects;
  }

  bool get getShowMonthName {
    return _settingsData.showMonthName;
  }

  bool get getSeenOnboarding {
    return _settingsData.seenOnboarding;
  }

  Color get checkColor {
    return _settingsData.checkColor;
  }

  Color get failColor {
    return _settingsData.failColor;
  }

  Color get skipColor {
    return _settingsData.skipColor;
  }

  bool get isInitialized {
    return _isInitialized;
  }

  set setTheme(Themes value) {
    _settingsData.theme = value;
    saveData();
    notifyListeners();
  }

  set setWeekStart(StartingDayOfWeek value) {
    _settingsData.weekStart = value;
    saveData();
    notifyListeners();
  }

  set setDailyNot(TimeOfDay notTime) {
    _settingsData.dailyNotTime = notTime;
    setAppNotification(notTime);
    saveData();
    notifyListeners();
  }

  set setShowDailyNot(bool value) {
    _settingsData.showDailyNot = value;
    if (value) {
      setAppNotification(_settingsData.dailyNotTime);
    } else {
      disableAppNotification();
    }
    saveData();
    notifyListeners();
  }

  set setSoundEffects(bool value) {
    _settingsData.soundEffects = value;
    saveData();
    notifyListeners();
  }

  set setShowMonthName(bool value) {
    _settingsData.showMonthName = value;
    saveData();
    notifyListeners();
  }

  set setSeenOnboarding(bool value) {
    _settingsData.seenOnboarding = value;
    saveData();
    notifyListeners();
  }

  set checkColor(Color value) {
    _settingsData.checkColor = value;
    saveData();
    notifyListeners();
  }

  set failColor(Color value) {
    _settingsData.failColor = value;
    saveData();
    notifyListeners();
  }

  set skipColor(Color value) {
    _settingsData.skipColor = value;
    saveData();
    notifyListeners();
  }
}
