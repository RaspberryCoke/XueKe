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

/// 统计数据
class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
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

  String get dateStr =>
      TimeUtils.getTime(DateTime.fromMillisecondsSinceEpoch(date));

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
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
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child:Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                tileMode: TileMode.mirror,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffcae3a4), Color(0xffd9b5b5)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              '统计数据',
              style: TextStyle(fontSize: 25, ),
            ),
            elevation: 0,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),

          body:


          Container(
            margin: const EdgeInsets.only(top: 90),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                    TableCalendar<Todo>(
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
                    ),

                  Container(
                    margin: const EdgeInsets.only(right: 12, left: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      color: Colors.white,
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
                                  date =
                                      DateTime.fromMillisecondsSinceEpoch(date)
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
                                  date =
                                      DateTime.fromMillisecondsSinceEpoch(date)
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
