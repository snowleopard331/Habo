import 'package:flutter/material.dart';
import 'package:habo/model/habit_data.dart';

class AppStateManager extends ChangeNotifier {
  // 是否显示统计数据
  bool _statistics = false;
  // 是否显示设置
  bool _settings = false;
  // 是否显示引导页
  bool _onboarding = false;
  // 是否显示创建习惯
  bool _createHabit = false;
  // 编辑习惯的数据
  HabitData? _editHabit;

// 获取统计信息
  bool get getStatistics => _statistics;
// 获取设置信息
  bool get getSettings => _settings;
// 获取引导信息
  bool get getOnboarding => _onboarding;
// 获取创建习惯信息
  bool get getCreateHabit => _createHabit;
// 获取编辑习惯信息
  HabitData? get getEditHabit => _editHabit;

  void goStatistics(bool state) {
    _statistics = state;
    notifyListeners();
  }

  void goSettings(bool state) {
    _settings = state;
    notifyListeners();
  }

  void goOnboarding(bool state) {
    _onboarding = state;
    notifyListeners();
  }

  void goCreateHabit(bool state) {
    _createHabit = state;
    notifyListeners();
  }

  void goEditHabit(HabitData? state) {
    _editHabit = state;
    notifyListeners();
  }
}
