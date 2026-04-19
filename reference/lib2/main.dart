import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mayekawa/utils/csv_import_helper.dart';
import 'package:mayekawa/utils/storage_migration.dart';
import 'package:path_provider/path_provider.dart';
import 'pages/login_page.dart'; // 导入登录页面

import 'package:hive_flutter/hive_flutter.dart';

import 'package:provider/provider.dart';
import 'user_provider.dart';

import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //导入CSV数据到数据库
  //await importCsvToDatabase();

  await StorageMigration.migrate();

  final appSupportDir = await getApplicationSupportDirectory();
  Hive.init(appSupportDir.path);
  //await Hive.initFlutter();
  //runApp(const MyApp());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, //仅仅允许竖屏
  ]).then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // 设计图的尺寸
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ISHIDA Service Report Tool',
          theme: ThemeData(
            fontFamily: 'SFNS', //设置全局字体为SFNS
          ),
          navigatorObservers: [KeyboardDismissObserver()], // 在这里指定
          home: LoginPage(), // 设置登录页为主页
        );
      },
    );
  }
}

// 自定义 NavigatorObserver
class KeyboardDismissObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    FocusManager.instance.primaryFocus?.unfocus(); // 关闭键盘
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    FocusManager.instance.primaryFocus?.unfocus(); // 关闭键盘
    super.didPush(route, previousRoute);
  }
}
