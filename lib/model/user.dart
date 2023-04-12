class User {
  String? name;
  String? account;
  String? password;
  String? avatar;
  String? content;
  String? email;
  String? phonenum;
  User({
    this.name,
    required this.account,
    required this.password,
    this.avatar,
    this.content,
    this.email,
    this.phonenum
  });

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    account = json['account'];
    password = json['password'];
    avatar = json['avatar'];
    content = json['content'];
    content = json['email'];
    content = json['phonenum'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['account'] = account;
    _data['password'] = password;
    _data['avatar'] = avatar;
    _data['content'] = content;
    _data['email'] = email;
    _data['phonenum'] = phonenum;
    return _data;
  }
}
