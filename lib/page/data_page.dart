import 'dart:io';
import 'dart:math';
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

//日期表示
DateTime today = DateTime.now();
DateTime day1 = today.subtract(Duration(days: 29));
DateTime day2 = today.subtract(Duration(days: 28));
DateTime day3 = today.subtract(Duration(days: 27));
DateTime day4 = today.subtract(Duration(days: 26));
DateTime day5 = today.subtract(Duration(days: 25));
DateTime day6 = today.subtract(Duration(days: 24));
DateTime day7 = today.subtract(Duration(days: 23));
DateTime day8 = today.subtract(Duration(days: 22));
DateTime day9 = today.subtract(Duration(days: 21));
DateTime day10 = today.subtract(Duration(days: 20));
DateTime day11 = today.subtract(Duration(days: 19));
DateTime day12 = today.subtract(Duration(days: 18));
DateTime day13 = today.subtract(Duration(days: 17));
DateTime day14 = today.subtract(Duration(days: 16));
DateTime day15 = today.subtract(Duration(days: 15));
DateTime day16 = today.subtract(Duration(days: 14));
DateTime day17 = today.subtract(Duration(days: 13));
DateTime day18 = today.subtract(Duration(days: 12));
DateTime day19 = today.subtract(Duration(days: 11));
DateTime day20 = today.subtract(Duration(days: 10));
DateTime day21 = today.subtract(Duration(days: 9));
DateTime day22 = today.subtract(Duration(days: 8));
DateTime day23 = today.subtract(Duration(days: 7));
DateTime day24 = today.subtract(Duration(days: 6));
DateTime day25 = today.subtract(Duration(days: 5));
DateTime day26 = today.subtract(Duration(days: 4));
DateTime day27 = today.subtract(Duration(days: 3));
DateTime day28 = today.subtract(Duration(days: 2));
DateTime day29 = today.subtract(Duration(days: 1));


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
  //late int date2 = DateTime.fromMillisecondsSinceEpoch(date).add(Duration(days: -1));
  late int curDate = DateTime.now().millisecondsSinceEpoch;


  late int day29Time = day29.millisecondsSinceEpoch;
  late int day28Time = day28.millisecondsSinceEpoch;
  late int day27Time = day27.millisecondsSinceEpoch;
  late int day26Time = day26.millisecondsSinceEpoch;
  late int day25Time = day25.millisecondsSinceEpoch;
  late int day24Time = day24.millisecondsSinceEpoch;
  late int day23Time = day23.millisecondsSinceEpoch;
  late int day22Time = day22.millisecondsSinceEpoch;
  late int day21Time = day21.millisecondsSinceEpoch;
  late int day20Time = day20.millisecondsSinceEpoch;
  late int day19Time = day19.millisecondsSinceEpoch;
  late int day18Time = day18.millisecondsSinceEpoch;
  late int day17Time = day17.millisecondsSinceEpoch;
  late int day16Time = day16.millisecondsSinceEpoch;
  late int day15Time = day15.millisecondsSinceEpoch;
  late int day14Time = day14.millisecondsSinceEpoch;
  late int day13Time = day13.millisecondsSinceEpoch;
  late int day12Time = day12.millisecondsSinceEpoch;
  late int day11Time = day11.millisecondsSinceEpoch;
  late int day10Time = day10.millisecondsSinceEpoch;
  late int day9Time = day9.millisecondsSinceEpoch;
  late int day8Time = day8.millisecondsSinceEpoch;
  late int day7Time = day7.millisecondsSinceEpoch;
  late int day6Time = day6.millisecondsSinceEpoch;
  late int day5Time = day5.millisecondsSinceEpoch;
  late int day4Time = day4.millisecondsSinceEpoch;
  late int day3Time = day3.millisecondsSinceEpoch;
  late int day2Time = day2.millisecondsSinceEpoch;
  late int day1Time = day1.millisecondsSinceEpoch;



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


  String get dateStr9 => TimeUtils2.getTime2(//
      DateTime.fromMillisecondsSinceEpoch(date).add(Duration(days: -10)));
  String get dateStr10 => TimeUtils2.getTime2(
      DateTime.fromMillisecondsSinceEpoch(date).add(Duration(days: -15)));
  String get dateStr11 => TimeUtils2.getTime2(
      DateTime.fromMillisecondsSinceEpoch(date).add(Duration(days: -20)));
  String get dateStr12 => TimeUtils2.getTime2(
      DateTime.fromMillisecondsSinceEpoch(date).add(Duration(days: -25)));
  String get dateStr13 => TimeUtils2.getTime2(
      DateTime.fromMillisecondsSinceEpoch(date).add(Duration(days: -29)));
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;
  bool showmonAvg = false;

//每周使用详情
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    //底栏
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 9,
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
      fontSize: 8,
    );

    String text;
    switch (value.toInt()) {
      case 1:
        text = '10分钟';
        break;
      case 3:
        text = '30分钟';
        break;
      case 5:
        text = '50分钟';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    String a = '${context.read<MainLogic>().searchDayMinute(date)}';
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
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(//显示边框
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 7,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots:  [//7日每天总时长
            FlSpot(1, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day24Time)}')),
            FlSpot(2, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day25Time)}')),
            FlSpot(3,double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day26Time)}')),
            FlSpot(4, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day27Time)}')),
            FlSpot(5, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day28Time)}')),
            FlSpot(6, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day29Time)}')),
            FlSpot(7, double.parse('${context.read<MainLogic>().searchDaytotalMinute(date)}')),
          ],
          isCurved: true,//是平滑曲线还是折线
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false, //显示节点


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
            reservedSize: 30,
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
      minX: 1,
      maxX: 7,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots:  [//7日平均时长
            FlSpot(1,double.parse('${MainLogic.instance.searchsevenDaysMinute()}')),

            FlSpot(7,double.parse('${MainLogic.instance.searchsevenDaysMinute()}')),

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




//每30天使用详情
  Widget bottommonTitleWidgets(double value, TitleMeta meta) {
    //底栏
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 9,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('$dateStr13', style: style);
        break;
      case 5:
        text = Text('           $dateStr12           ', style: style);
        break;
      case 10:
        text = Text('           $dateStr11           ', style: style);
        break;
      case 15:
        text = Text('           $dateStr10           ', style: style);
        break;
      case 20:
        text = Text('           $dateStr9           ', style: style);
        break;
      case 25:
        text = Text('           $dateStr7           ', style: style);
        break;
      case 30:
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

  Widget leftTitlemonWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 8,
    );

    String text;
    switch (value.toInt()) {
      case 1:
        text = '10分钟';
        break;
      case 3:
        text = '30分钟';
        break;
      case 5:
        text = '50分钟';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainmonData() {
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
            getTitlesWidget: bottommonTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitlemonWidgets,
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 1,
      maxX: 30,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots:  [
            FlSpot(1, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day1Time)}')),
            FlSpot(2, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day2Time)}')),
            FlSpot(3, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day3Time)}')),
            FlSpot(4, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day4Time)}')),
            FlSpot(5, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day5Time)}')),
            FlSpot(6, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day6Time)}')),
            FlSpot(7, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day7Time)}')),
            FlSpot(8, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day8Time)}')),
            FlSpot(9, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day9Time)}')),
            FlSpot(10, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day10Time)}')),
            FlSpot(11, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day11Time)}')),
            FlSpot(12, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day12Time)}')),
            FlSpot(13, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day13Time)}')),
            FlSpot(14, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day14Time)}')),
            FlSpot(15, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day15Time)}')),
            FlSpot(16, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day16Time)}')),
            FlSpot(17, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day17Time)}')),
            FlSpot(18, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day18Time)}')),
            FlSpot(19, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day19Time)}')),

            FlSpot(20, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day20Time)}')),
            FlSpot(21, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day21Time)}')),
            FlSpot(22, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day22Time)}')),
            FlSpot(23, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day23Time)}')),
            FlSpot(24, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day24Time)}')),
            FlSpot(25, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day25Time)}')),
            FlSpot(26, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day26Time)}')),
            FlSpot(27, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day27Time)}')),
            FlSpot(28, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day28Time)}')),
            FlSpot(29, double.parse('${context.read<MainLogic>().searchDaytotalMinute(
                day29Time)}')),
            FlSpot(30, double.parse('${context.read<MainLogic>().searchDaytotalMinute(date)}')),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,//显示节点
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

  LineChartData avgmonData() {
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
            reservedSize: 25,
            getTitlesWidget: bottommonTitleWidgets,
            interval: 1,//每隔1个日期
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitlemonWidgets,
            reservedSize: 30,
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
      minX: 1,
      maxX: 30,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots:  [
            FlSpot(1,  double.parse('${MainLogic.instance.searchthirtyDaysMinute()}')),

            FlSpot(30, double.parse('${MainLogic.instance.searchthirtyDaysMinute()}')),
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        right: 13,
                        left: 5,
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
                          fontSize: 9,
                          color: showAvg
                              ? Colors.black.withOpacity(0.5)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: 30),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                    child: Text(
                      '近一个月使用详情',
                      style: TextStyle(
                        color: Color(0xFF3e6fa5),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1.7,
                    child: Padding(
                        padding: const EdgeInsets.only(
                          right: 13,
                          left: 5,
                          top: 24,
                          bottom: 12,
                        ),
                        child:
                        LineChart(
                          //是否显示平均数据
                          showmonAvg ? avgmonData() : mainmonData(),
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
                          showmonAvg = !showmonAvg;
                        });
                      },
                      child: Text(
                        showmonAvg ? '每日情况' : "日均情况",
                        style: TextStyle(
                          fontSize: 9,
                          color: showmonAvg
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
