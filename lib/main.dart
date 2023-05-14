import 'package:tomato_clock/db/NotificationFilterDB.dart';
import 'package:tomato_clock/db/WhitePackageDB.dart';
import 'package:tomato_clock/debug.dart';
import 'package:tomato_clock/logic/main_logic.dart';
import 'package:tomato_clock/page/qq_login_page/qq_login_page.dart';
import 'package:tomato_clock/page/setting_page/SettingPage.dart';
import 'package:tomato_clock/page/splash_page.dart';
import 'package:tomato_clock/page/start_white_app/StartWhiteApp.dart';
import 'package:tomato_clock/page/test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tomato_clock/page/lock_page/lock_page.dart';
import 'package:tomato_clock/page/home_page.dart';
import 'package:tomato_clock/page/supervise_controller.dart';
import 'package:tomato_clock/page/white_app_page/white_app_page.dart';
import 'colors.dart';
import 'db/TodoDB.dart';
import 'db/UserInfo.dart';
import 'package:device_apps/device_apps.dart';
import 'package:tomato_clock/page/white_notification_page/notification_filter_page.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  print("------------------main start-----------------------");
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  // MainLogic.instance.init(sharedPreferences);
  // LoginLogic.instance.init();
  //初始化用户信息
  initUserInfo();
  //初始化待办事项数据库
  initTodoList();
  //初始化白名单软件列表
  initWhiteApp();
  //初始化通知过滤列表
  initNotificationFilter();
  runApp(MyApp());
}

void initTodoList() async{
  List<Map<String, dynamic>>res=await TodoDB().query();
  if(res.length==0)return;
  for(var value in res){
    MainLogic.todoList.add(Todo(value['id'],value['title'],value['time'],value['content']));
  }
  MainLogic.refreshNotifier.value=MainLogic.todoList;
}

Future<bool> initUserInfo()async {
  //注意：这里默认从数据库取出来的数据都是完整的，正确的。
  List<Map<String, dynamic>> query_res=await UserInfoDB().query();
  if(query_res.length==0)return false;
  Map<String,dynamic> r=query_res[0];
  MainLogic.userInfo=UserInfo(r['uid'], r['name'], r['gender'], r['picture']);
  return true;
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(

    colorScheme: base.colorScheme.copyWith(
      primary: kShrinePink300,
      secondary: kShrineErrorRed,
      //error: kShrineErrorRed,
    ),
    scaffoldBackgroundColor: kShrinePink50,
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: kShrinePurple,
    ),

  //   bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //   selectedItemColor:kShrinePink400,
  //   unselectedItemColor: Colors.grey,
  //   backgroundColor:Colors.transparent,//kShrinePink50,
  // ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: EdgeInsets.all(16.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    print("------------------_MyAppState initState-----------------------");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    print("------------------_MyAppState dispose-----------------------");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("------------------_MyAppState didChangeAppLifecycleState-----------------------");
    print("------------------_MyAppState didChangeAppLifecycleState-------state:${state}-----------");
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:{break;}
      case AppLifecycleState.inactive:{break;}
      case AppLifecycleState.paused:{break;}
//APP结束时调用. 类似于Android的onDestroy
      case AppLifecycleState.detached:{break;}
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainLogic>(create: (_) => MainLogic.instance),
      ],
      child: MaterialApp(
        routes: {
          '/': (context) => SplashPage(),
          '/lock_page': (context) => LockPage(),
          '/setting_page': (context) => SettingPage(),
          '/test_page': (context) => TestPage(),
          '/white_app_page': (context) => WhiteAppPage(),
          '/start_white_app': (context) => StartWhiteAppPage(),
          '/notification_page': (context) => NotificationFilterPage(),
          '/QQLoginPageState':(context)=>QQLoginPage(),
          '/home_page':(context)=>HomePage(),
        },
        theme: _buildShrineTheme(),
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
      ),
    );
  }
}

Future<void> initWhiteApp() async {
  await DeviceApps.getInstalledApplications().then((value) {
    for (var app in value) {
      MainLogic.whiteAppsMap[app.appName] = false;
      MainLogic.whitePackagesMap[app.packageName] = false;
      MainLogic.appNameToPackageName[app.appName] = app.packageName;
      MainLogic.packageNameToAppName[app.packageName] = app.appName;
    }
  });

  MainLogic.appNameToPackageName["学刻"] = "com.hebut.tomato_clock";
  MainLogic.packageNameToAppName["com.hebut.tomato_clock"] = "学刻";
  MainLogic.appNameToPackageName["系统UI"] = "com.android.systemui";
  MainLogic.packageNameToAppName["com.android.systemui"] = "系统UI";

  //获取白名单
  List<Map<String, dynamic>> res = await WhitePackageDB().query();
  res.forEach((element) {
    debugPrint(element.toString());
  });

  for (var app in res) {
    //在whiteAppsMap中设置为true
    MainLogic.whitePackagesMap[app[WhitePackageDB.COLUMN_PACKAGE_NAME]] = true;
    MainLogic.whiteAppsMap[app[WhitePackageDB.COLUMN_APP_NAME]] = true;
  }

  MainLogic.whiteAppsMap["学刻"] = true;
  MainLogic.whiteAppsMap["系统UI"] = true;
  MainLogic.whitePackagesMap['com.hebut.tomato_clock'] = true;
  MainLogic.whitePackagesMap["com.android.systemui"] = true;

  await SuperviseController.packageChange();
}

Future<void> initNotificationFilter() async {
  await DeviceApps.getInstalledApplications().then((value) {
    for (var app in value) {
      MainLogic.packageWhetherFilter[app.packageName] = false;
    }
  });

  List<Map<String, dynamic>> res = await NotificationFilterDB().query();

  for (var item in res) {
    //在whiteAppsMap中设置为true
    MainLogic.packageWhetherFilter[item['PackageName']] = true;
    MainLogic.packageFilterString[item['PackageName']] =
        item['Filter'] == null ? "" : item['Filter'];
  }
  MainLogic.packageWhetherFilter.remove("com.hebut.tomato_clock");
  MainLogic.packageFilterString.remove("com.hebut.tomato_clock");

  SuperviseController.notificationChange();
  //debug
  MainLogic.packageFilterString.forEach((key, value) {
    infoprint(key+" : "+value.toString());
  });
}
