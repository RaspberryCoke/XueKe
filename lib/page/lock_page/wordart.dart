import 'package:flutter/cupertino.dart';

class word_art extends StatelessWidget{
  word_art({Key? key,required String text}) : text=text,super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(text,style:TextStyle(fontFamily: 'wanghongziti',fontSize: 26));
  }

}