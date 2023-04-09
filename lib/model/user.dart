class User {
  String? account;
  String? password;
  String? avatar;
  String? content;

  User({
    required this.account,
    required this.password,
    this.avatar,
    this.content,
  });

  User.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    password = json['password'];
    avatar = json['avatar'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['account'] = account;
    _data['password'] = password;
    _data['avatar'] = avatar;
    _data['content'] = content;
    return _data;
  }
}
