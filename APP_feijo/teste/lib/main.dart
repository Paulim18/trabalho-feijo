// lib/main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const TodoApp());
}

class Todo {
  String title;
  String description;
  DateTime date;
  bool completed;

  Todo({
    required this.title,
    required this.description,
    required this.date,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'completed': completed,
      };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json['title'],
        description: json['description'],
        date: DateTime.parse(json['date']),
        completed: json['completed'],
      );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  List<Todo> todos = [];
  String filter = 'all';

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('todos');
    if (data != null) {
      final jsonList = jsonDecode(data) as List;
      setState(() {
        todos = jsonList.map((json) => Todo.fromJson(json)).toList();
      });
    }
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = todos.map((todo) => todo.toJson()).toList();
    prefs.setString('todos', jsonEncode(jsonList));
  }

  void addTodo(Todo todo) {
    setState(() {
      todos.add(todo);
    });
    saveTodos();
  }

  void toggleTodoStatus(int index) {
    setState(() {
      todos[index].completed = !todos[index].completed;
    });
    saveTodos();
  }

  List<Todo> get filteredTodos {
    switch (filter) {
      case 'pending':
        return todos.where((t) => !t.completed).toList();
      case 'completed':
        return todos.where((t) => t.completed).toList();
      default:
        return todos;
    }
  }

  void showAddTodoDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nova Tarefa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Título')),
            TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Descrição')),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  selectedDate = picked;
                }
              },
              child: const Text('Selecionar Data'),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              addTodo(Todo(
                title: titleController.text,
                description: descriptionController.text,
                date: selectedDate,
              ));
              Navigator.pop(context);
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                filter = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'all', child: Text('Todas')),
              PopupMenuItem(value: 'pending', child: Text('Pendentes')),
              PopupMenuItem(value: 'completed', child: Text('Concluídas')),
            ],
          )
        ],
      ),
      body: ListView.builder(
        itemCount: filteredTodos.length,
        itemBuilder: (context, index) {
          final todo = filteredTodos[index];
          return ListTile(
            title: Text(todo.title,
                style: TextStyle(
                    decoration: todo.completed ? TextDecoration.lineThrough : null)),
            subtitle: Text('${todo.description}\n${todo.date.toLocal().toString().split(" ")[0]}'),
            trailing: Checkbox(
              value: todo.completed,
              onChanged: (_) => toggleTodoStatus(todos.indexOf(todo)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
