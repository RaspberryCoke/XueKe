import 'package:device_apps/device_apps.dart';
class GlobalData{
  //被选中的代办事项
  static int minutes = 1;
  static String  planName= '';
  static String  content= '';
  //包信息
  static Map<String,String> appNameToPackageName={};
  static Map<String,String> packageNameToAppName={};
  static Map<String,bool> whiteAppsMap={};
  static Map<String,bool> whitePackagesMap={};
  //以下代码和通知有关
  static Map<String,bool> packageWhetherFilter={};
  static Map<String,String> packageFilterString={};
}