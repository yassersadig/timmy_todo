class TodoItem {
  int id = 0;
  String title = '';
  String subTitle = '';
  bool isDone = false;

  TodoItem(
      {required this.id,
      required this.title,
      required this.subTitle,
      required this.isDone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subTitle,
      'isDone': isDone ? 1 : 0,
    };
  }

  static TodoItem fromMap(Map<String, dynamic> itemMap) {
    return TodoItem(
      id: itemMap['id'],
      title: itemMap['title'],
      subTitle: itemMap['subtitle'],
      isDone: itemMap['isDone'] == 1 ? true : false,
    );
  }
}
