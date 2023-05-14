// import 'package:flutter/material.dart';
// import 'package:tomato_clock/page/constant.dart';
// import 'package:tomato_clock/logic/main_logic.dart';
// import 'package:tomato_clock/page/event.dart';
// import 'package:tomato_clock/res.dart';
//
// import '../db/TodoDB.dart';
//
// class FinishedPage extends StatefulWidget {
//   const FinishedPage({Key? key}) : super(key: key);
//
//   @override
//   State<FinishedPage> createState() => _FinishedPageState();
// }
//
// class _FinishedPageState extends State<FinishedPage> {
//   List<String> cards = [
//     Res.card_bg_2,
//     Res.card_bg_3,
//     Res.card_bg_4,
//     Res.card_bg_5,
//     Res.card_bg_6,
//   ];
//   late final ValueNotifier<List<Todo>> _selectedEvents;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   late EventNotifier<List<Todo>> _refresh;
//
//   @override
//   void initState() {
//     super.initState();
//     _refresh = MainLogic.instance.refreshNotifier;
//     _refresh.addListener(_onRefresh);
//     _selectedDay = _focusedDay;
//     _selectedEvents =
//         ValueNotifier(MainLogic.instance.getEventsForDay(_selectedDay!));
//   }
//
//   void _onRefresh() {
//     if (!mounted) return;
//     List<Todo> list = [];
//     list.addAll(MainLogic.instance.getEventsForDay(_selectedDay!));
//     Future.delayed(Duration.zero, () {
//       _selectedEvents.value = list;
//     });
//   }
//   @override
//   void dispose() {
//     _refresh.removeListener(_onRefresh);
//     _selectedEvents.dispose();
//     super.dispose();
//   }
//
//   void back() {
//     Navigator.pushReplacementNamed(context, Constant.homePage);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: back),
//         title: Text('已完成待办'),
//       ),
//       body: Center(
// /*        child: ListView.builder(
//             itemCount: int.parse('${MainLogic.instance.completeCount()}'),//完成待办次数
//             itemBuilder: (context,index){
//               return ListTile(
//                 title: Text(
//                     //Todo.fromJson["title"]
//                     "hhh--$index"
//
//
//                 ),
//               );
//             }
//         )*/
//
//         child:ValueListenableBuilder<List<Todo>>(
//       valueListenable: _selectedEvents,
//         builder: (context, value, _) {
//           return ListView.builder(
//             itemCount: value.length,
//             //int.parse('${MainLogic.instance.completeCount()}'),
//             itemBuilder: (context, index) {
//               Todo todo = value[index];
//
//                  Container(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 12.0,
//                     vertical: 4.0,
//                   ),
//                   decoration: BoxDecoration(////////////
//                     borderRadius: BorderRadius.all(Radius.circular(4)),
//                     image: DecorationImage(
//                       fit: BoxFit.cover,
//                       image: AssetImage(cards[index % 6]),
//                     ),
//                   ),
//                   child: ListTile(
//                     title: Text(
//                       '${todo.title}',
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                     subtitle: Text(
//                       '${todo.toMs()}',
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: Colors.white,
//                       ),
//                     ),
//                     trailing: Text(
//                       '${todo.date }',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 );
//             },
//           );
//         },
//       ),
//       ),
//     );
//   }
// }