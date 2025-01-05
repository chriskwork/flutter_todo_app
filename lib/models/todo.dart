import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Todo {
  final String id;
  final String title;
  bool isDone;

  Todo({required this.id, required this.title, this.isDone = false});

  // todo data change to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'isDone': isDone};
  }

  // parse JSON
  static Todo fromJson(Map<String, dynamic> json) {
    return Todo(id: json['id'], title: json['title'], isDone: json['isDone']);
  }
}

class TodoStorage {
  static const String _key = 'todos';

  // save todo data
  static Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todosJson =
        todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList(_key, todosJson);
  }

  // load todo data
  static Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? todosJson = prefs.getStringList(_key);

    if (todosJson == null) {
      return [];
    }

    return todosJson
        .map((todoJson) => Todo.fromJson(jsonDecode(todoJson)))
        .toList();
  }
}
