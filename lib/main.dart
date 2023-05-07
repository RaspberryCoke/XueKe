import 'package:flutter_accessibility_service/flutter_accessibility_service.dart';
import 'package:tomato_clock/logic/GlobalData.dart';
import 'package:tomato_clock/logic/PackageDB.dart';
import 'package:tomato_clock/logic/login_logic.dart';
import 'package:tomato_clock/logic/main_logic.dart';
import 'package:tomato_clock/login/registration_page.dart';
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
import 'package:tomato_clock/page/setting_page/SettingPage.dart';
import 'page/todo_detail_page.dart';
import 'package:device_apps/device_apps.dart';
import 'package:sqflite/sqflite.dart';


void main() async {
  print("------------------main start-----------------------");
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  MainLogic.instance.init(sharedPreferences);
  LoginLogic.instance.init();
  initWhiteApp();

  final bool status = await FlutterAccessibilityService.isAccessibilityPermissionEnabled();
  if (status) {
    print('Accessibility permission is granted.');
  } else {
    print('Accessibility permission is not granted.');
    final bool res = await FlutterAccessibilityService.requestAccessibilityPermission();
  }

  chackAndGetPermission();

  FlutterAccessibilityService.accessStream.listen((event) {
    print(event.eventType);
    print(event.packageName);
    print(event.actionType);
    print(event.windowType);
  });


  runApp(MyApp());
}

Future<bool> chackAndGetPermission()async
{
  bool res=false;
  bool status = await FlutterAccessibilityService.isAccessibilityPermissionEnabled();
  if (status) {
    print('Accessibility permission is granted.');
    return true;
  } else {
    print('Accessibility permission is not granted.');
    await FlutterAccessibilityService.requestAccessibilityPermission();
  }
  return (await FlutterAccessibilityService.isAccessibilityPermissionEnabled());
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

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
    switch (state)
    {
      case AppLifecycleState.resumed:
      {
        if(SuperviseController.isSupervised){
          debugPrint("resumed stopSupervise");
          SuperviseController.setToBackground();
        }
        break;
      }
//处在不活动状态，无法处理用户响应。界面退到后台或弹出对话框情况下， 即失去了焦点但仍可以执行drawframe回调 类似于Android的onPause
      case AppLifecycleState.inactive:
      {
        if(SuperviseController.isSupervised){
          debugPrint("inactive startSupervise");
          SuperviseController.setToForeground();
        }
        break;
      }
//不可见并不能响应用户的输入，但是在后台继续活动中。应用挂起，比如退到后台，失去了焦点且不会收到drawframe回调. 类似于Android的onStop
      case AppLifecycleState.paused:
      {
        if(SuperviseController.isSupervised){
          debugPrint("paused startSupervise");
          SuperviseController.setToForeground();
        }
        break;
      }
//APP结束时调用. 类似于Android的onDestroy
      case AppLifecycleState.detached:
      {
        if(SuperviseController.isSupervised){
          debugPrint("detached startSupervise");
          SuperviseController.setToForeground();
        }
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
            case Constant.settingPage:
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

Future<void> initWhiteApp()async
{
  await DeviceApps.getInstalledApplications().then((value)
  {
    for(var app in value)
    {
      GlobalData.whiteAppsMap[app.appName] = false;
      GlobalData.whitePackagesMap[app.packageName] = false;
      GlobalData.appNameToPackageName[app.appName] = app.packageName;
      GlobalData.PackageNameToappName[app.packageName] = app.appName;
    }
  });

  GlobalData.appNameToPackageName["学刻"] = "com.hebut.tomato_clock";
  GlobalData.PackageNameToappName["com.hebut.tomato_clock"] = "学刻";

  //获取白名单
  List<Map<String,dynamic>> res = await PackageDB().query();
  res.forEach((element) {
    debugPrint(element.toString());
  });

  for(var app in res)
  {//在whiteAppsMap中设置为true
    GlobalData.whitePackagesMap[app[PackageDB.COLUMN_PACKAGE_NAME]] = true;
    GlobalData.whiteAppsMap[app[PackageDB.COLUMN_APP_NAME]] = true;
  }

  GlobalData.whiteAppsMap["学刻"]=true;
  GlobalData.whitePackagesMap['com.hebut.tomato_clock'] = true;

  //debug
  debugPrintStack();
  GlobalData.whiteAppsMap.forEach((key, value) {
    debugPrint(key+" : "+value.toString());
  });
  bool res2= await SuperviseController.packageChange();
  debugPrint("res2 : "+res2.toString());
}
