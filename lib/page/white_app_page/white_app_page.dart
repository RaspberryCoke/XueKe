import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../db/WhitePackageDB.dart';
import '../../logic/main_logic.dart';
import '../supervise_controller.dart';

class WhiteAppPage extends StatefulWidget {
  const WhiteAppPage({Key? key}) : super(key: key);
  @override
  WhiteAppState createState() {return WhiteAppState();}
}

class WhiteAppState extends State<WhiteAppPage> {
  bool needGetPermmision=false;
  List<MySwitchListTile> lists=[];
  @override
  initState(){
    debugPrint("WhiteAppPage initState");
    super.initState();
    MainLogic.whiteAppsMap.forEach((key, value) {
      lists.add(
          MySwitchListTile(
            title: key,
            activeColor: Colors.blue,
            value: value,
          ));
    }
    );

    //这是一个异步函数，当获取结果之后，刷新页面。
    SuperviseController.checkPermission_accessibility().then((value) => {setState(() {
      needGetPermmision=value;
    })  });

  }

  @override
  void dispose() {
    debugPrint("WhiteAppPage dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[

          needGetPermmision?TextButton(
              onPressed: (){SuperviseController.getPermission_accessibility();},
              child: Text('获取权限',style: TextStyle(color: Colors.white),)):Text('')],
        title: Text("白名单"),
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 33,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
      ),
      body: ListView(children: lists),
    );
  }
}

class MySwitchListTile extends StatefulWidget {
  String title='';
  Color activeColor=Colors.blue;
  bool value=false;
  MySwitchListTile({Key? key,required this.title,required this.activeColor,required this.value}) : super(key: key);
  @override
  _MySwitchListTileState createState() => _MySwitchListTileState(title:title,activeColor: activeColor,switch_value: value);
}

class _MySwitchListTileState extends State<MySwitchListTile> {
  _MySwitchListTileState({Key? key,required this.title,required this.activeColor,required this.switch_value});
  bool switch_value = false;
  String title='';
  Color activeColor=Colors.blue;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      activeColor: activeColor,
      value: switch_value,
      onChanged: (value) {
        setState((){
          switch_value = value;
          MainLogic.whiteAppsMap[title]=value;
          debugPrint(MainLogic.whiteAppsMap[title].toString()+" is set to "+value.toString());
          if(value) turnTrue();
          else turnFalse();
          //数据库更新操作
        });
      },
    );
  }

  Future<void> turnTrue() async{
    debugPrint("insert "+title);
    int res=await WhitePackageDB().insert(title,MainLogic.appNameToPackageName[title]!);
    MainLogic.whiteAppsMap[title]=true;
    MainLogic.whitePackagesMap[MainLogic.appNameToPackageName[title]!]=true;
    if(res>=0)debugPrint("insert success");
    WhitePackageDB().query().then((value) => debugPrint("all allowed apps(without main): "+value.toString()));
    SuperviseController.packageChange();
  }

  Future<void> turnFalse() async{
    debugPrint("delete "+title);
    int res=await WhitePackageDB().deleteAppName(title);
    MainLogic.whiteAppsMap[title]=false;
    MainLogic.whitePackagesMap[MainLogic.appNameToPackageName[title]!]=false;
    if(res>=0)debugPrint("delete success");
    WhitePackageDB().query().then((value) => debugPrint("all allowed apps(without main): "+value.toString()));
    SuperviseController.packageChange();
  }

}
