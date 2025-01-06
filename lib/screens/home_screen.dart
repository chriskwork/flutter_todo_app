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
              child: Text('Cancel'.toUpperCase()),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(input.trim()),
              child: Text(
                'Add'.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Simple Todo App'),
        centerTitle: true,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Container(
          width: 500,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    _deleteTodo(todo.id);
                  }
                },
                child: ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (_) => _toggleTodo(todo.id),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.black26),
                    onPressed: () => _deleteTodo(todo.id),
                  ),
                ),
              );
            },
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
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
