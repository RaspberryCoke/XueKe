import 'package:flutter/material.dart';
import 'package:tomato_clock/db/NotificationFilterDB.dart';
import 'package:tomato_clock/logic/GlobalData.dart';
import '../Notification_filter_keyword_page/notification_filter_keyword_page.dart';
import '../supervise_controller.dart';

class NotificationFilterPage extends StatefulWidget {
  const NotificationFilterPage({Key? key}) : super(key: key);
  @override
  NotificationFilterState createState() {return NotificationFilterState();}
}

class NotificationFilterState extends State<NotificationFilterPage> {
  List<MySwitchListTile> lists=[];
  bool needGetPermmision=false;
  @override
  initState(){
    debugPrint("NotificationFilterPage initState");
    super.initState();
    GlobalData.packageWhetherFilter.forEach((key, value) {
        lists.add(
            MySwitchListTile(
              title: GlobalData.packageNameToAppName[key]!,
              activeColor: Colors.blue,
              value: value,
            ));
      }
    );

    //这是一个异步函数，当获取结果之后，刷新页面。
    SuperviseController.checkPermission_notification().then((value) => {setState(() {
      needGetPermmision=value;
    })  });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        actions: <Widget>[

          needGetPermmision?TextButton(
              onPressed: (){SuperviseController.getPermission_notification();},
              child: Text('获取权限',style: TextStyle(color: Colors.white),)):Text('')],
        title: Text("通知过滤"),
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

  @override
  void dispose() {
    debugPrint("NotificationFilterPage dispose");
    super.dispose();
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
      subtitle: switch_value?Text("开启监督时将被限制",style: TextStyle(color: Colors.red,fontSize: 15)):null,
      secondary: switch_value?ElevatedButton(child: Text("设置",style: TextStyle(color: Colors.white),),
        onPressed: (){
          //跳转到设置页面
          Navigator.push(
              context,
              MaterialPageRoute (
                builder: (BuildContext context) => NotificationFilterKeywordPage(AppName: title,)
          ),);
        return;
    },):null,
      activeColor: activeColor,
      value: switch_value,
      onChanged: (value) {
        setState((){
          switch_value = value;
          String pkname=GlobalData.appNameToPackageName[title]!;
          if(value==false) {
            GlobalData.packageFilterString.remove(pkname);
            GlobalData.packageWhetherFilter[pkname]=false;
            NotificationFilterDB().deleteAppName(title);
            SuperviseController.notificationChange();
          }else{
            GlobalData.packageFilterString[pkname]='';
            GlobalData.packageWhetherFilter[pkname]=true;
            NotificationFilterDB().insert(title,pkname,true,'');
            SuperviseController.notificationChange();
          }
          debugPrint("GlobalData.packageWhetherFilter全部被阻塞的包：");
          GlobalData.packageWhetherFilter.forEach((key, value) {
            if(value==true)
              debugPrint("pkName:"+key+"--->Filter:"+GlobalData.packageFilterString[key]!);
          });
          //数据库更新操作
        });
      },
    );
  }
}
