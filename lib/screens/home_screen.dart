import 'package:flutter/material.dart';
import '../models/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // list
  List<Todo> todos = [];

  // load todo data when the App is started.
  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  // load todo data
  void _loadTodos() async {
    List<Todo> loadedTodos = await TodoStorage.loadTodos();
    setState(() {
      todos = loadedTodos;
    });
  }

  // add todo
  void _addTodo(String title) {
    setState(() {
      todos.add(Todo(id: DateTime.now().toString(), title: title));
      TodoStorage.saveTodos(todos);
    });
  }

  // delete todo
  void _deleteTodo(String id) {
    setState(() {
      todos.removeWhere((todo) => todo.id == id);
      TodoStorage.saveTodos(todos);
    });
  }

  // checkbox toggle status
  void _toggleTodo(String id) {
    setState(() {
      final index = todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        todos[index].isDone = !todos[index].isDone;
      }
      TodoStorage.saveTodos(todos);
    });
  }

  // Add todo dialog
  Future<String?> _showAddTodoDialog() async {
    String input = '';

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Todo'),
          content: TextField(
            autofocus: true,
            onChanged: (value) => input = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(input),
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        centerTitle: true,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        backgroundColor: Colors.teal.shade100,
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
            leading: Checkbox(
              value: todo.isDone,
              onChanged: (_) => _toggleTodo(todo.id),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteTodo(todo.id),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // new todo dialog, create todo as input value
          final newTodoTitle = await _showAddTodoDialog();

          if (newTodoTitle != null && newTodoTitle.isNotEmpty) {
            _addTodo(newTodoTitle);
          }
        },
      ),
    );
  }
}
