import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tomato_clock/logic/GlobalData.dart';

import '../../logic/PackageDB.dart';

class WhiteAppPage extends StatefulWidget {
  const WhiteAppPage({Key? key}) : super(key: key);
  @override
  WhiteAppState createState()
  {
    return WhiteAppState();
  }
}

class WhiteAppState extends State<WhiteAppPage> {
  List<MySwitchListTile> lists=[];
  @override
  initState(){
    super.initState();
    GlobalData.whiteAppsMap.forEach((key, value) {
      lists.add(
          MySwitchListTile(
            title: key,
            activeColor: Colors.blue,
            value: value,
          ));
    }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          GlobalData.whiteAppsMap[title]=value;
          debugPrint(GlobalData.whiteAppsMap[title].toString()+" is set to "+value.toString());
          if(value) turnTrue();
          else turnFalse();
          //数据库更新操作
        });
      },
    );
  }

  Future<void> turnTrue() async{
    debugPrint("insert "+title);
    int res=await PackageDB().insert(title);
    if(res>=0)debugPrint("insert success");
    PackageDB().query().then((value) => debugPrint("all allowed apps: "+value.toString()));
  }

  Future<void> turnFalse() async{
    debugPrint("delete "+title);
    int res=await PackageDB().delete(title);
    if(res>=0)debugPrint("delete success");
    PackageDB().query().then((value) => debugPrint("all allowed apps: "+value.toString()));
  }

}
