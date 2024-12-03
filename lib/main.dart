import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habo/habits/habits_manager.dart';
import 'package:habo/navigation/app_router.dart';
import 'package:habo/navigation/app_state_manager.dart';
import 'package:habo/notifications.dart';
import 'package:habo/settings/settings_manager.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';
import 'package:habo/generated/l10n.dart';

void main() {
  addLicenses();
  runApp(
    const Habo(),
  );
}

// 定义一个名为Habo的StatefulWidget类
class Habo extends StatefulWidget {
  // 构造函数，传入一个可选的key参数
  const Habo({super.key});

  // 创建一个State对象
  @override
  State<Habo> createState() => _HaboState();
}

class _HaboState extends State<Habo> {
  // 创建一个AppStateManger实例
  final _appStateManager = AppStateManager();
  // 创建一个SettingsManager实例
  final _settingsManager = SettingsManager();
  // 创建一个HabitsManager实例
  final _habitManager = HabitsManager();
  // 声明一个AppRouter类型的变量，并使用late关键字表示该变量将在稍后初始化
  late AppRouter _appRouter;

  @override
  void initState() {
    // 判断当前平台是否为Linux或MacOS
    if (Platform.isLinux || Platform.isMacOS) {
      setWindowMinSize(const Size(320, 320));
      setWindowMaxSize(Size.infinite);
    }
    // 初始化设置管理器
    _settingsManager.initialize();
    // 初始化习惯管理器
    _habitManager.initialize();
    // 判断平台是否支持通知
    if (platformSupportsNotifications()) {
      // 初始化通知
      initializeNotifications();
    }
    // 禁用运行时字体获取
    GoogleFonts.config.allowRuntimeFetching = false;
    // 创建AppRouter实例
    _appRouter = AppRouter(
      // 传入appStateManager
      appStateManager: _appStateManager,
      // 传入settingsManager
      settingsManager: _settingsManager,
      // 传入habitsManager
      habitsManager: _habitManager,
    );
    // 调用父类的构造函数
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
// 设置系统状态栏样式
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          // 设置状态栏颜色为透明
          statusBarColor: Colors.transparent,
          // 设置状态栏亮度为亮
          statusBarBrightness: Brightness.light),
    );
    // 设置应用在设备上的首选方向为竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        // 创建一个ChangeNotifierProvider，用于管理App的状态
        ChangeNotifierProvider(
          create: (context) => _appStateManager,
        ),
        // 创建一个ChangeNotifierProvider，用于管理设置
        ChangeNotifierProvider(
          create: (context) => _settingsManager,
        ),
        // 创建一个ChangeNotifierProvider，用于管理_habitManager
        ChangeNotifierProvider(
          // 在create回调中返回_habitManager
          create: (context) => _habitManager,
        ),
      ],
      child: Consumer<SettingsManager>(builder: (context, counter, _) {
        // 返回一个MaterialApp，设置标题为'Habo'
        return MaterialApp(
          title: 'Habo',
          // 设置本地化代理
          localizationsDelegates: const [
            // 设置S代理
            S.delegate,
            // 设置GlobalMaterialLocalizations代理
            GlobalMaterialLocalizations.delegate,
            // 设置GlobalWidgetsLocalizations代理
            GlobalWidgetsLocalizations.delegate,
            // 设置GlobalCupertinoLocalizations代理
            GlobalCupertinoLocalizations.delegate,
          ],
          // 支持的语言
          supportedLocales: S.delegate.supportedLocales,
          // 获取HabitsManager中的scaffoldKey
          scaffoldMessengerKey:
              Provider.of<HabitsManager>(context).getScaffoldKey,
          theme: Provider.of<SettingsManager>(context).getLight,
          darkTheme: Provider.of<SettingsManager>(context).getDark,
          // 设置应用程序的主页为Router，RouterDelegate为_appRouter，BackButtonDispatcher为RootBackButtonDispatcher
          home: Router(
            routerDelegate: _appRouter,
            backButtonDispatcher: RootBackButtonDispatcher(),
          ),
        );
      }),
    );
  }
}

void addLicenses() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
}
