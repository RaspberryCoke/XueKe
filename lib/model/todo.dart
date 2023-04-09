class Todo {
  String? title;
  String? content;
  int? date;
  int? duration;
  int? insertDate;

  Todo({
    required this.title,
    this.content,
    isDone = false,
    duration = 25 * 60,
    required this.date,
    this.insertDate,
  }) : this.duration = duration;

  Todo.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    date = json['date'];
    duration = json['duration'];
    insertDate = json['insertDate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['content'] = content;
    _data['date'] = date;
    _data['duration'] = duration;
    _data['insertDate'] = insertDate;
    return _data;
  }

  bool isSameDay(DateTime dateTime) {
    DateTime finalDate = DateTime.fromMillisecondsSinceEpoch(date!);
    return finalDate.year == dateTime.year &&
        finalDate.month == dateTime.month &&
        finalDate.day == dateTime.day;
  }

  DateTime getFullDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(date!);
  }

  DateTime getYmd() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date!);
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  String doneToString() {
    return '开始';
  }

  String lessDay() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date!);
    DateTime finalDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    Duration duration = finalDate.difference(DateTime.now());
    return duration.inDays.toString();
  }

  String goDay() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(insertDate!);
    DateTime finalDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    Duration duration = DateTime.now().difference(finalDate);
    return duration.inDays.toString();
  }

  String toMs() {
    int minute = (duration! / 60).truncate();
    int second = duration! % 60;
    if (minute <= 0) {
      return '$second 秒';
    }
    return '$minute 分钟';
  }

  @override
  String toString() {
    return 'Todo{title: $title, content: $content, date: $date, duration: $duration}';
  }
}
