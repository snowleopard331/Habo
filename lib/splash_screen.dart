import 'package:flutter/material.dart';
import 'package:habo/navigation/routes.dart';

class SplashScreen extends StatefulWidget {
  // 返回一个MaterialPage对象
  static MaterialPage page() {
    // MaterialPage 是Flutter中用于定义页面路由的一个类。它实现了Material Design风格的页面切换效果。MaterialPage通常用于Navigator中，用于管理应用中的页面堆栈
    return MaterialPage(
      name: Routes.splashPath,
      // key属性用于给页面指定一个唯一的键值，用于在页面堆栈中唯一标识这个页面。ValueKey是一个键类型，它接受一个值作为参数。在这里，ValueKey的值是Routes.splashPath，确保每个页面都有一个唯一的键值
      key: ValueKey(Routes.splashPath),
      // child属性用于指定页面的内容。在这里，const SplashScreen()是一个常量构造函数，表示创建一个SplashScreen的实例。SplashScreen通常是一个启动屏幕，用于在应用启动时显示一些初始化信息或动画
      child: const SplashScreen(),
    );
  }

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// 启动屏幕，用于管理 SplashScreen 的状态
class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    // Scaffold 是一个常用的布局结构，它实现了基本的 Material Design 布局结构。在这里，它作为页面的主体结构
    return Scaffold(
      // Center 是一个布局组件，它将其子组件居中显示。在这里，它用于将 Column 组件居中显示在屏幕上
      body: Center(
        // Column 是一个垂直布局组件，它将子组件按垂直方向排列。在这里，它包含两个子组件：一个 Image.asset 和一个 Text
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon.png',
              width: 72,
            ),
            Text(
              'Habo',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}
