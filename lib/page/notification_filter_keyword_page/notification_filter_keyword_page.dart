import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tomato_clock/db/NotificationFilterDB.dart';
import 'package:tomato_clock/debug.dart';

import 'package:tomato_clock/page/supervise_controller.dart';

import '../../logic/main_logic.dart';

class NotificationFilterKeywordPage extends StatefulWidget {
  String AppName;

  NotificationFilterKeywordPage({Key? key, required this.AppName})
      : super(key: key);

  @override
  NotificationFilterKeywordPageState createState() {
    return NotificationFilterKeywordPageState(this.AppName);
  }
}

class NotificationFilterKeywordPageState
    extends State<NotificationFilterKeywordPage> {
  String inputText = '';
  TextEditingController control = TextEditingController(text: '');
  late String AppName;
  late String PackageName;
  List<ListTile> listOfTiles = [];
  List<String> filterStringList = [];

  NotificationFilterKeywordPageState(String _name) {
    debugPrint('NotificationFilterKeywordPageState');

    AppName = _name;
    infoprint("AppName: $AppName");

    PackageName = MainLogic.appNameToPackageName[AppName]!;
    infoprint(PackageName);
    filterStringList = NotificationFilterDB.convertStringToList(MainLogic
        .packageFilterString[MainLogic.appNameToPackageName[AppName]!]!);
    int len = filterStringList.length;
    for (int i = 0; i < len; i++) filterStringList.remove('');
    for (int i = 0; i < filterStringList.length; i++)infoprint(filterStringList[i]);
    if (filterStringList.length == 1 && filterStringList[0] == '') {
      filterStringList = [];
      return;
    }
    for (int i = 0; i < filterStringList.length; i++) {
      listOfTiles.add(ListTile(
        title: Text(filterStringList[i]),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            String str = filterStringList[i];
            print("onPressed");
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('确定要删除吗？'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('取消')),
                      TextButton(
                          onPressed: () {
                            //先删除filterStringList中的元素
                            if (filterStringList.contains(str)) {
                              filterStringList.remove(str);
                            }
                            //再更新packageFilterString
                            MainLogic.packageFilterString[PackageName] =
                                NotificationFilterDB.convertListToString(
                                    filterStringList);
                            //在更新数据库
                            NotificationFilterDB().update_filter_string(AppName,
                                MainLogic.packageFilterString[PackageName]!);
                            SuperviseController.notificationChange();
                            //再删除listOfTiles中的元素
                            for (var value in listOfTiles) {
                              if (value.title.toString() ==
                                  Text(str).toString()) {
                                listOfTiles.remove(value);
                                break;
                              }
                            }
                            //先弹出dialog，再弹出所有的关键词页面，再重新构建。
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      NotificationFilterKeywordPage(
                                        AppName: AppName,
                                      )),
                            );
                          },
                          child: Text('确定')),
                    ],
                  );
                });
          },
        ),
      ));
    }
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.AppName),
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
        body: ListView(children: listOfTiles),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Container(
                        constraints: BoxConstraints(
                            minWidth: 400,
                            maxWidth: 400,
                            minHeight: 500,
                            maxHeight: 700),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.white),
                        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                        child:
                        //Column(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                        ListView(
                          children: <Widget>[
                            Text(
                              "输入关键词，当通知中含有\n"
                              "关键词时会正常通知。\n",
                              style: TextStyle(
                                fontFamily: 'wanghongziti',
                                fontSize: 19,
                                color: Colors.red,
                              ),

                            ),
                            Text(
                              "如：张三、计算机2班等\n"
                              "每次只输入一个关键词\n",
                              style: TextStyle(
                                fontFamily: 'wanghongziti',
                                fontSize: 17,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "注意：关键词是精确匹配，\n"
                              "要求每一个字符均匹配\n符号区分中英",
                              style: TextStyle(
                                fontFamily: 'wanghongziti',
                                fontSize: 17,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      width: 200,
                                      height: 100,
                                      child: TextField(
                                    autofocus: true,
                                    maxLength: 15,
                                    maxLines: 1,
                                    controller: control,
                                    decoration: const InputDecoration(
                                      labelText: "输入关键词",
                                      hintText: "输入关键词",
                                      prefixIcon: Icon(Icons.search),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                      ),
                                    ),
                                    onChanged: (text) {
                                      inputText = text;
                                    },
                                  )),
                                  Container(
                                    constraints: BoxConstraints(
                                      minWidth: 50,
                                      maxWidth: 50,
                                      minHeight: 100,
                                      maxHeight: 100,
                                    ),
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 55),
                                    child:ElevatedButton(

                                      style: ButtonStyle(
                                          elevation: MaterialStateProperty.all<double>(3),
                                        backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),

                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.green,

                                      ),
                                      onPressed: () {
                                        if (inputText == '') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text("输入的关键词不能为空")));
                                          control.text = '';
                                          inputText = '';
                                          return;
                                        }
                                        bool repeat = false;
                                        for (int i = 0;
                                        i < filterStringList.length;
                                        i++) {
                                          if (inputText == filterStringList[i]) {
                                            repeat = true;
                                            break;
                                          }
                                        }
                                        if (repeat) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                              content: Text("输入的关键词已存在")));
                                          return;
                                        }
                                        //正确的输入
                                        filterStringList.add(inputText);
                                        listOfTiles.add(ListTile(
                                          title: Text(inputText),
                                          trailing: IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              //在filterStringList中删除一项
                                              for (int i = 0;
                                              i < filterStringList.length;
                                              i++) {
                                                if (inputText ==
                                                    filterStringList[i]) {
                                                  filterStringList.remove(
                                                      filterStringList[i]);
                                                  break;
                                                }
                                              }
                                              //更新MainLogic中的packageFilterString
                                              MainLogic.packageFilterString[
                                              PackageName] =
                                                  NotificationFilterDB
                                                      .convertListToString(
                                                      filterStringList);
                                              //更新数据库
                                              NotificationFilterDB()
                                                  .update_filter_string(
                                                  AppName,
                                                  MainLogic
                                                      .packageFilterString[
                                                  PackageName]!);
                                              SuperviseController.notificationChange();
                                              //删除listOfTiles中的一项
                                              for (var value in listOfTiles) {
                                                if (value.title.toString() ==
                                                    Text(inputText).toString()) {
                                                  listOfTiles.remove(value);
                                                  break;
                                                }
                                              }
                                              //先弹出dialog，再弹出所有的关键词页面，再重新构建。
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                    context) =>
                                                        NotificationFilterKeywordPage(
                                                          AppName: AppName,
                                                        )),
                                              );
                                            },
                                          ),
                                        ));

                                        String toUpdateString =
                                        NotificationFilterDB
                                            .convertListToString(
                                            filterStringList);
                                        MainLogic.packageFilterString[
                                        PackageName] = toUpdateString;
                                        NotificationFilterDB()
                                            .update_filter_string(
                                            AppName, toUpdateString);
                                        SuperviseController.notificationChange();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  NotificationFilterKeywordPage(
                                                    AppName: AppName,
                                                  )),
                                        );
                                      },
                                    ) ,
                                  )

                                ]),

                          ],
                        ),
                      ),
                    );
                  });
            }));
  }
}
