import 'dart:io';

import 'package:tomato_clock/model/todo.dart';
import 'package:tomato_clock/page/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tomato_clock/logic/main_logic.dart';
import 'package:tomato_clock/res.dart';
import 'package:tomato_clock/utils/time_utils.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:fl_chart/fl_chart.dart';

/// 统计数据
class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class AppColors {//颜色
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}

class _DataPageState extends State<DataPage> {
  late final ValueNotifier<List<Todo>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late int date = DateTime.now().millisecondsSinceEpoch;
  late int curDate = DateTime.now().millisecondsSinceEpoch;
//显示年-月-日
  String get dateStr =>
      TimeUtils.getTime(DateTime.fromMillisecondsSinceEpoch(date));
  //显示月-日
  String get dateStr2 =>
      TimeUtils2.getTime2(DateTime.fromMillisecondsSinceEpoch(date));

  String get dateStr3 => TimeUtils2.getTime2(//昨天
      DateTime.fromMillisecondsSinceEpoch(date).add(Duration(days: -1)));
  String get dateStr4 => TimeUtils2.getTime2(//前天
      DateTime.fromMillisecondsSinceEpoch(date).add(Duration(days: -2)));
  String get dateStr5 => TimeUtils2.getTime2(
      DateTime.fromMillisecondsSinceEpoch(date).add(Duration(days: -3)));
  String get dateStr6 => TimeUtils2.getTime2(
      DateTime.fromMillisecondsSinceEpoch(date).add(Duration(days: -4)));
  String get dateStr7 => TimeUtils2.getTime2(
      DateTime.fromMillisecondsSinceEpoch(date).add(Duration(days: -5)));
  String get dateStr8 => TimeUtils2.getTime2(
      DateTime.fromMillisecondsSinceEpoch(date).add(Duration(days: -6)));

  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    //底栏
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('$dateStr8', style: style);
        break;
      case 2:
        text = Text('           $dateStr7           ', style: style);
        break;
      case 3:
        text = Text('           $dateStr6           ', style: style);
        break;
      case 4:
        text = Text('           $dateStr5           ', style: style);
        break;
      case 5:
        text = Text('           $dateStr4           ', style: style);
        break;
      case 6:
        text = Text('           $dateStr3           ', style: style);
        break;
      case 7:
        text = Text('  $dateStr2   ', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );

    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 25,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 8,
      minY: 0,
      maxY: 8,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 0),
            FlSpot(1, 5),
            FlSpot(2, 5),
            FlSpot(3, 3.1),
            FlSpot(4, 4.2),
            FlSpot(5, 3),
            FlSpot(6, 3),
            FlSpot(7, 4),
            FlSpot(8, 0),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

/*  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }*/

/*  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = MainLogic.instance.getEventsForDay(selectedDay);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return
/*    Stack(
      children: [
        Positioned.fill(
          child:Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                tileMode: TileMode.mirror,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xfffafafa), Color(0xffd9b5b5)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),*/

      Scaffold(
        backgroundColor: Color(0xd0f6f6f3),
        // backgroundColor: Color(0xd0f1f1c1),
        appBar: AppBar(
          //backgroundColor: Colors.transparent,
          title: const Text(
            '统计数据',
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),

        body: Container(
          margin: const EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
/*                    TableCalendar<Todo>(
                      locale: 'zh_CN',
                      firstDay: kFirstDay,
                      lastDay: kLastDay,
                      headerVisible: false,

                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      rangeStartDay: _rangeStart,
                      rangeEndDay: _rangeEnd,
                      calendarFormat: _calendarFormat,
                      rangeSelectionMode: _rangeSelectionMode,
                      eventLoader: MainLogic.instance.getAllTodos,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarStyle: CalendarStyle(
                        // Use `CalendarStyle` to customize the UI
                        outsideDaysVisible: false,
                        markersMaxCount: 1,
                        markerSize: 4,
                        todayDecoration: BoxDecoration(
                          color: Color(0xFF5789c2).withOpacity(.5),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: const BoxDecoration(
                          color: const Color(0xff4e7cad),
                          shape: BoxShape.circle,
                        ),
                        markerDecoration: const BoxDecoration(
                          color: Color(0xffdc154a),
                          shape: BoxShape.circle,
                        ),
                      ),
                      onDaySelected: _onDaySelected,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),*/

                Container(
                  margin: const EdgeInsets.only(right: 12, left: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    //  color: Color(0xff86ee79),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '累计专注',
                            style: TextStyle(
                              color: Color(0xFF3e6fa5),
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 5),
                          Image.asset(
                            Res.ic_action_bubble,
                            width: 15,
                            height: 15,
                            color: Color(0xFF3e6fa5),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '次数',
                                    style: TextStyle(
                                      color: Color(0xFF3e6fa5),
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                          '${MainLogic.instance.completeCount()}',
                                          style: TextStyle(
                                            color: Color(0xFF3e6fa5),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '时长',
                                  style: TextStyle(
                                    color: Color(0xFF3e6fa5),
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(height: 5),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                        '${MainLogic.instance.completeTodoTime()}',
                                        style: TextStyle(
                                          color: Color(0xFF3e6fa5),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '分钟',
                                        style: TextStyle(
                                          color: Color(0xFF3e6fa5),
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '日均时长',
                                    style: TextStyle(
                                      color: Color(0xFF3e6fa5),
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                          '${MainLogic.instance.averageTodoTime()}',
                                          style: TextStyle(
                                            color: Color(0xFF3e6fa5),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '分钟',
                                          style: TextStyle(
                                            color: Color(0xFF3e6fa5),
                                            fontSize: 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 12, left: 12, top: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    //     color: Color(0xff86ee79),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '当日专注   $dateStr',
                            style: TextStyle(
                              color: Color(0xFF3e6fa5),
                              fontSize: 14,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                date = DateTime.fromMillisecondsSinceEpoch(date)
                                    .add(Duration(days: -1))
                                    .millisecondsSinceEpoch;
                              });
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 14,
                              color: Color(0xFF3e6fa5),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (date >= curDate) {
                                  return;
                                }
                                date = DateTime.fromMillisecondsSinceEpoch(date)
                                    .add(Duration(days: 1))
                                    .millisecondsSinceEpoch;
                              });
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: Color(0xFF3e6fa5),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '次数',
                                    style: TextStyle(
                                      color: Color(0xFF3e6fa5),
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                          '${context.read<MainLogic>().searchDayCount(date)}',
                                          style: TextStyle(
                                            color: Color(0xFF3e6fa5),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '日均时长',
                                    style: TextStyle(
                                      color: Color(0xFF3e6fa5),
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                          '${context.read<MainLogic>().searchDayMinute(date)}',
                                          style: TextStyle(
                                            color: Color(0xFF3e6fa5),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '分钟',
                                          style: TextStyle(
                                            color: Color(0xFF3e6fa5),
                                            fontSize: 8,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                      child: Text(
                        '近七天使用详情',
                        style: TextStyle(
                          color: Color(0xFF3e6fa5),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    AspectRatio(
                      aspectRatio: 1.70,
                      child: Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                            left: 16,
                            top: 24,
                            bottom: 12,
                          ),
                          child:
                          LineChart(
                            //是否显示平均数据
                            showAvg ? avgData() : mainData(),
                          )
                      ),
                    ),
                    Container(
                      width: 72,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20) //配置圆角
                      ),
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showAvg = !showAvg;
                          });
                        },
                        child: Text(
                          showAvg ? '每日情况' : "日均情况",
                          style: TextStyle(
                            fontSize: 10,
                            color: showAvg
                                ? Colors.black.withOpacity(0.5)
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        //  ),
        //    ],
      );
  }
}
