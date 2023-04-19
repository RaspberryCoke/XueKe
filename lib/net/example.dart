import 'package:http/http.dart' as http;

void _main(List<String> arguments)async {
  //登录
  //注册
  //忘记密码
  //把待办保存
  //每日专注数据
  //壁纸
  //音频
  var url = Uri.http('service-rmo371l9-1307951248.sh.apigw.tencentcs.com', '/login');
  var response = await http.post(url, body: {'username': 'qwe', 'passwd': '123'});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  var url2 = Uri.http('service-rmo371l9-1307951248.sh.apigw.tencentcs.com', '/register');
  var response2 = await http.post(url2, body: {'username': 'qwe', 'passwd': '123'});
  print('Response status: ${response2.statusCode}');
  print('Response body: ${response2.body}');
  //print(await http.read(Uri.https('example.com', 'foobar.txt')));
}
