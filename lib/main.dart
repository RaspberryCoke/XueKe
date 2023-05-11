import 'package:tomato_clock/logic/GlobalData.dart';
import 'package:tomato_clock/db/NotificationFilterDB.dart';
import 'package:tomato_clock/db/WhitePackageDB.dart';
import 'package:tomato_clock/logic/login_logic.dart';
import 'package:tomato_clock/logic/main_logic.dart';
import 'package:tomato_clock/login/registration_page.dart';
import 'package:tomato_clock/page/setting_page/SettingPage.dart';
import 'package:tomato_clock/page/constant.dart';
import 'package:tomato_clock/page/login.dart';
import 'package:tomato_clock/page/mine_setting_page.dart';
import 'package:tomato_clock/page/splash_page.dart';
import 'package:tomato_clock/page/start_white_app/StartWhiteApp.dart';
import 'package:tomato_clock/page/table_events_page.dart';
import 'package:tomato_clock/page/test_page.dart';
import 'package:tomato_clock/page/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomato_clock/page/lock_page/lock_page.dart';
import 'package:tomato_clock/page/home_page.dart';
import 'package:tomato_clock/page/supervise_controller.dart';
import 'package:tomato_clock/page/white_app_page/white_app_page.dart';
import 'colors.dart';
import 'package:tomato_clock/page/person_page.dart';
import 'model/cut_corners_border.dart';
import 'page/todo_detail_page.dart';
import 'package:device_apps/device_apps.dart';
import 'package:tomato_clock/page/white_notification_page/notification_filter_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

void main() async {
  print("------------------main start-----------------------");
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  MainLogic.instance.init(sharedPreferences);
  LoginLogic.instance.init();
  initWhiteApp();
  initNotificationFilter();
//debug
//   String the_path = join(await getDatabasesPath(), 'notification_filter.db');
  //
  // final file = File(the_path);
  //
  // if (file.existsSync()) {
  //   file.deleteSync();
  //   print('文件已成功删除');
  // } else {
  //   print('找不到要删除的文件');
  // }
  runApp(MyApp());
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: kShrinePink400,
      secondary: kShrineErrorRed,
      //error: kShrineErrorRed,
    ),
    scaffoldBackgroundColor: kShrineSurfaceWhite,
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: kShrinePurple,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: CutCornersBorder(),
      focusedBorder: CutCornersBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: kShrinePurple,
        ),
      ),
      floatingLabelStyle: TextStyle(
        color: kShrinePurple,
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
      case AppLifecycleState.resumed:{
          // if (SuperviseController.isSupervised) {
          //   debugPrint("resumed stopSupervise");
          //   SuperviseController.setToBackground();
          // }
          break;
        }

      case AppLifecycleState.inactive:{
          // if (SuperviseController.isSupervised) {
          //   debugPrint("inactive startSupervise");
          //   SuperviseController.setToForeground();
          // }
          break;
        }

      case AppLifecycleState.paused:{
          // if (SuperviseController.isSupervised) {
          //   debugPrint("paused startSupervise");
          //   //替换掉这个
          //   SuperviseController.setToForeground();
          // }
          break;
        }
//APP结束时调用. 类似于Android的onDestroy
      case AppLifecycleState.detached:{
          // if (SuperviseController.isSupervised) {
          //   debugPrint("detached startSupervise");
          //   //替换掉这个
          //   SuperviseController.setToForeground();
          // }
          break;
        }
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
          '/lock_page': (context) => LockPage(),
          '/setting_page': (context) => SettingPage(),
          '/test_page': (context) => TestPage(),
          '/white_app_page': (context) => WhiteAppPage(),
          '/start_white_app': (context) => StartWhiteAppPage(),
          '/notification_page': (context) => NotificationFilterPage(),
          '/personPage':(context)=>PersonPage(),
          '/changeInfoPage':(context)=>MineSettingPage(),
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
          //此处
          const Locale('zh', 'CH'),
          const Locale('en', 'US'),
        ],
        onGenerateRoute: (settings) {
          Widget widget;
          Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>?;
          switch (settings.name) {
            case Constant.main:
              widget = SplashPage();
              break;
            case Constant.login:
              widget = Login();
              break;
            case Constant.register:
              widget = RegistrationPage();
              break;
            case Constant.homePage:
              widget = HomePage();
              break;
            case Constant.todoDetailPage:
              widget = TodoDetailPage(args: args);
              break;
            case Constant.todoPage:
              widget = const TodoPage();
              break;
            case Constant.changeInfoPage:
              widget = const MineSettingPage();
              break;
            case Constant.personPage:
              widget = PersonPage();
              break;
            default:
              widget = TableEventsPage();
          }

          return MaterialPageRoute(builder: (context) {
            return widget;
          });
        },
      ),
    );
  }
}

Future<void> initWhiteApp() async {
  await DeviceApps.getInstalledApplications().then((value) {
    for (var app in value) {
      GlobalData.whiteAppsMap[app.appName] = false;
      GlobalData.whitePackagesMap[app.packageName] = false;
      GlobalData.appNameToPackageName[app.appName] = app.packageName;
      GlobalData.packageNameToAppName[app.packageName] = app.appName;
    }
  });

  GlobalData.appNameToPackageName["学刻"] = "com.hebut.tomato_clock";
  GlobalData.packageNameToAppName["com.hebut.tomato_clock"] = "学刻";
  GlobalData.appNameToPackageName["系统UI"] = "com.android.systemui";
  GlobalData.packageNameToAppName["com.android.systemui"] = "系统UI";

  //获取白名单
  List<Map<String, dynamic>> res = await WhitePackageDB().query();
  res.forEach((element) {
    debugPrint(element.toString());
  });

  for (var app in res) {
    //在whiteAppsMap中设置为true
    GlobalData.whitePackagesMap[app[WhitePackageDB.COLUMN_PACKAGE_NAME]] = true;
    GlobalData.whiteAppsMap[app[WhitePackageDB.COLUMN_APP_NAME]] = true;
  }

  GlobalData.whiteAppsMap["学刻"] = true;
  GlobalData.whiteAppsMap["系统UI"] = true;
  GlobalData.whitePackagesMap['com.hebut.tomato_clock'] = true;
  GlobalData.whitePackagesMap["com.android.systemui"] = true;

  // GlobalData.whiteAppsMap.forEach((key, value) {
  //   debugPrint(key + " : " + value.toString());
  // });
  await SuperviseController.packageChange();
}

Future<void> initNotificationFilter() async {
  await DeviceApps.getInstalledApplications().then((value) {
    for (var app in value) {
      GlobalData.packageWhetherFilter[app.packageName] = false;
    }
  });

  List<Map<String, dynamic>> res = await NotificationFilterDB().query();

  for (var item in res) {
    //在whiteAppsMap中设置为true
    GlobalData.packageWhetherFilter[item['PackageName']] = true;
    GlobalData.packageFilterString[item['PackageName']] =
        item['FilterString'] == null ? "" : item['FilterString'];
  }
  GlobalData.packageWhetherFilter.remove("com.hebut.tomato_clock");
  GlobalData.packageFilterString.remove("com.hebut.tomato_clock");

  SuperviseController.notificationChange();
  // //debug
  // GlobalData.whiteAppsMap.forEach((key, value) {
  //   debugPrint(key+" : "+value.toString());
  // });
  // bool res2= await SuperviseController.packageChange();
  // debugPrint("res2 : "+res2.toString());
}
