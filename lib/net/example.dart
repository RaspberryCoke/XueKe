import 'package:http/http.dart' as http;

void main(List<String> arguments)async {
  var url = Uri.http('https://service-ik2qj51p-1307951248.sh.apigw.tencentcs.com/release/', '/login');
  var response = await http.post(url, body: {'username': 'qwe', 'passwd': '123'});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  var url2 = Uri.http('https://service-ik2qj51p-1307951248.sh.apigw.tencentcs.com/release/', '/register');
  var response2 = await http.post(url2, body: {'username': 'qwe', 'passwd': '123'});
  print('Response status: ${response2.statusCode}');
  print('Response body: ${response2.body}');
  //print(await http.read(Uri.https('example.com', 'foobar.txt')));
}
