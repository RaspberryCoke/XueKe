import 'package:tomato_clock/logic/login_logic.dart';
import 'package:tomato_clock/logic/main_logic.dart';
import 'package:tomato_clock/login/registration_page.dart';
import 'package:tomato_clock/page/constant.dart';
import 'package:tomato_clock/page/login.dart';
import 'package:tomato_clock/page/splash_page.dart';
import 'package:tomato_clock/page/table_events_page.dart';
import 'package:tomato_clock/page/todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tomato_clock/page/lock_page/lock_page.dart';
import 'package:tomato_clock/page/home_page.dart';
import 'colors.dart';
import 'model/cut_corners_border.dart';
import 'page/todo_detail_page.dart';
import 'package:tomato_clock/page/lock_page/go_to_back_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  MainLogic.instance.init(sharedPreferences);
  LoginLogic.instance.init();
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

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainLogic>(create: (_) => MainLogic.instance),
      ],
      child: MaterialApp(
        routes: {
          '/lock_page': (context) => LockPage(),
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
/*            case Constant.settingPage:
              widget = const SettingPage();
              break;*/
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























/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home:
      HomePage()//ScaffoldRoute(),
    );
  }
}


class ScaffoldRoute extends StatefulWidget {
  @override
  _ScaffoldRouteState createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  List tabs = ["新闻", "历史", "图片"];
  List list = [
    TemplatePage(),
    LockPage(),
    TemplatePage(),
  ];
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    // 释放资源
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar:  _selectedIndex==1?null:AppBar( //导航栏
        title: Text("App Name"),
        actions: <Widget>[ //导航栏右侧菜单
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
      ),
      drawer: MyDrawer(), //抽屉
      bottomNavigationBar:_selectedIndex==1?null:BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Business'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'School'),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),

      body: list[_selectedIndex],
      );

  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}


class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Wendux",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add account'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Manage accounts'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
