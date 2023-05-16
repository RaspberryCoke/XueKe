import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tomato_clock/colors.dart';
import 'package:tomato_clock/components/HistoryCard.dart';
import 'package:tomato_clock/db/HistoryDB.dart';
class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);
  @override
  HistoryPageState createState() => HistoryPageState();
}
class HistoryPageState extends State<HistoryPage> {


  @override
  initState() {
    debugPrint("HistoryPageState initState");
    super.initState();
  }
  @override
  void dispose() {
    debugPrint("HistoryPageState dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
            padding: EdgeInsets.only(top: 5,left: 10, right: 10,bottom: 5),
            child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: kShrinePink300,
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: BoxConstraints(
                  minHeight: 45,
                  maxHeight: 45,
                  minWidth: 130,
                  maxWidth: 130,
                ),
                child: Center(
                    child: Text(
                      '历史',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    )))),
        //backgroundColor: Colors.white,
      ),
      body: MyListView(),

    );
  }
}


class MyListView extends StatefulWidget {
  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  int _pageSize=10;
  final _scrollController = ScrollController();
  List<History> _dataList = [];
  int _currentPage=0;
  bool _havemore=true;

  bool _isLoading= false;
  List<Color> _colors=[//12
    Color(0xffB3BACB),
    Color(0xffA7A3B3),
    Color(0xff9C8EF4),
    Color(0xff87A3FF),
    Color(0xff6E91EC),
    Color(0xff37C6AB),
    Color(0xff4DD470),
    Color(0xff66C95B),
    Color(0xffFFBE62),
    Color(0xffFF8C59),
    Color(0xffF86D60),
    Color(0xffFB6382),
  ];


  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.7) {
        _loadData();
      }
    });
  }

  Future<void> _loadData() async {
    // 避免重复加载数据
    if (_isLoading) {
      return;
    }
    if(!_havemore){
      return;
    }
    setState(() {
      _isLoading = true;
    });
    // 查询数据库中的数据


    final List<Map<String, dynamic>> the_data =
      await HistoryDB().load_data(_pageSize, _currentPage * _pageSize,);
    // 将数据添加到列表中

    setState(() {
      int _get_num=the_data.length;
      if(_get_num<_pageSize){
        _havemore=false;
      }
      for(int i=0;i<_get_num;i++){
        _dataList.add(History.fromMap(the_data[i]));
      }
      _currentPage++;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _dataList.length,
      itemBuilder: (context, index) {
        return HistoryCard(title:_dataList[index].title,
            content:_dataList[index].content,
            time:_dataList[index].time,
            starttime:_dataList[index].starttime,
            backgroundColor: _colors[index%12],
            succeed: _dataList[index].success);
      },
    );
  }


}
