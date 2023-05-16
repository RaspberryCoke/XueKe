import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:tomato_clock/colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tomato_clock/db/HistoryDB.dart';
import 'package:tomato_clock/debug.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  DataPageState createState() => DataPageState();
}

class DataPageState extends State<DataPage> {
  List<Data> chartData = [];
  List<Data> chartData_month = [];



  List<DateTime> _selectedDates = [];
  DateTime _startDate=DateTime.now().subtract(Duration(days: 1));
  DateTime _endDate=DateTime.now();
  DateTime _oldestDateTime = DateTime(1999, 1, 1);

  @override
  initState() {
    HistoryDB().findOldestDateTime().then((value) {
      setState(() {
        _oldestDateTime = value;
        infoprint(_oldestDateTime.toString());
      });
    });
    debugPrint("DataPage initState");
    super.initState();
  }

  @override
  void dispose() {
    debugPrint("DataPage dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kShrinePink50,

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
                      '待办任务',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                    )))),
        //backgroundColor: Colors.white,
      ),
      body: Container(
        color: kShrinePink50,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
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
                    color: kShrinePink100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: BoxConstraints(
                    minHeight: 50,
                    maxHeight: 50,
                    minWidth: double.infinity,
                    maxWidth: double.infinity,
                  ),
                  child: ListTile(
                    selected: true,
                    leading: Container(
                      width: 37,
                      child: Icon(
                        Icons.date_range_rounded,
                        size: 28,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(
                      "挑选一段日期以展示",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      //Navigator.pushNamed(context, '/white_app_page');
                    },
                    trailing: Text(
                      "",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )),

            SizedBox(
              height: 30,
            ),

            SizedBox(
              height: 30,
            ),

            //以下是date picker
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
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
                    color: Color(0xffFFCDD2).withAlpha(210),
                    //Colors.white60,//kShrinePink100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: BoxConstraints(
                    minHeight: 300,
                    maxHeight: 300,
                    minWidth: double.infinity,
                    maxWidth: double.infinity,
                  ),
                  child: SfDateRangePicker(
                    rangeSelectionColor:kShrinePink300,
                    selectionColor: Colors.red, // 选中单个日期的颜色
                    maxDate: DateTime.now(),
                    minDate: _oldestDateTime,
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    initialSelectedRange: PickerDateRange(
                        _endDate,
                        _endDate),
                  ),
                )),

            SizedBox(
              height: 40,
            ),

            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff00ff00).withAlpha(35), //Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      minHeight: 300,
                      maxHeight: 300,
                      minWidth: double.infinity,
                      maxWidth: double.infinity,
                    ),
                    child: SfCartesianChart(
                      //borderColor: Colors.blueAccent,

                      primaryXAxis: DateTimeAxis(
                        borderColor: Colors.grey[700],
                        enableAutoIntervalOnZooming: false,
                        intervalType: DateTimeIntervalType.days,
                        // 设置间隔类型为天
                        interval: 1,
                        // 设置间隔为1天

                        visibleMaximum: _endDate,
                        // 设置显示的最大日期
                        visibleMinimum: _startDate,
                        // 设置显示的最小日期
                        majorGridLines: MajorGridLines(
                            width: 1, color: Colors.grey.shade300),
                        majorTickLines: MajorTickLines(color: kShrinePink400),
                        //labelRotation: 45, // 旋转标签, 如果需要可以调整
                      ),

                      primaryYAxis: NumericAxis(
                        // 设置Y轴的最大值和最小值
                        minimum: 0,
                        //maximum: 40,
                        interval: 5,
                        // 设置Y轴的网格线
                        majorGridLines: MajorGridLines(width: 0),
                        majorTickLines: MajorTickLines(color: kShrinePink400),
                      ),
                      zoomPanBehavior: ZoomPanBehavior(
                        enablePinching: true,
                        //enableDoubleTapZooming: true,
                        enablePanning: true,
                        //enableSelectionZooming: true,
                      ),
                      series: <SplineSeries<Data, DateTime>>[
                        SplineSeries<Data, DateTime>(

                          animationDuration: 3000,
                          dataSource: chartData,
                          xValueMapper: (Data data, _) => data.time,
                          yValueMapper: (Data data, _) => data.value,
                          markerSettings: MarkerSettings(
                            isVisible: true, // 显示标记
                          ),
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true, // 显示数据标签
                          ),
                          color: Colors.orangeAccent,
                        )
                      ],
                    ))),

            SizedBox(
              height: 30,
            ),

            SizedBox(
              height: 60,
            ),



          ],
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      final startDate = args.value.startDate;
      final endDate = args.value.endDate;

      // Check if both start date and end date are not null
      if (startDate != null && endDate != null) {
        setState(() {
          _startDate = startDate;
          _endDate = endDate;
          _generateDateList();
          infoprint("_startDate: $_startDate");
          infoprint("_endDate: $_endDate");
          updateChartData();
        });

      }
      // Check if only start date is selected
      else if (startDate != null) {
        _generateDateList();
      }
    }
  }

  Future<void> updateChartData()async{
    chartData.clear();
    for(int i=0;i<_selectedDates.length;i++){
       int value=await HistoryDB().queryDataByDate(_selectedDates[i]);
        if(value!=null){
          chartData.add(Data(_selectedDates[i], value));
          infoprint("value: $value");
        }

    }
    chartData.forEach((element) {
      infoprint("element: ${element.time} ${element.value}");
    });

    setState(() {

    });
  }

  void _generateDateList() {
    _selectedDates.clear();
    if (_startDate == null) {
      return;
    }
    final end = _endDate ?? _startDate!;
    for (var date = _startDate!;
        date.isBefore(end) || date.isAtSameMomentAs(end);
        date = date.add(Duration(days: 1))) {
      _selectedDates.add(date);
    }

    setState(() {});
  }

  List<DateTime> _getDatesInRange(DateTime start, DateTime end) {
    List<DateTime> dates = [];
    for (var d = start;
        d.isBefore(end.add(Duration(days: 1)));
        d = d.add(Duration(days: 1))) {
      dates.add(d);
    }
    infoprint("_getDatesInRange : ${dates.length}");
    return dates;
  }
}

class Data {
  final DateTime time;
  final int value;

  Data(this.time, this.value);
}
