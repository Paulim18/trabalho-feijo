import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

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

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
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

  void editTodo(int index, Todo updated) {
    setState(() {
      todos[index] = updated;
    });
    saveTodos();
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
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

  void showAddOrEditTodoDialog({Todo? todo, int? index}) {
    final titleController = TextEditingController(text: todo?.title ?? '');
    final descriptionController = TextEditingController(text: todo?.description ?? '');
    DateTime selectedDate = todo?.date ?? DateTime.now();
    bool showTitleError = false;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                todo == null ? 'Nova Tarefa' : 'Editar Tarefa',
                style: const TextStyle(color: Colors.indigo),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Título',
                        labelStyle: const TextStyle(color: Colors.indigo),
                        errorText: showTitleError ? 'O título é obrigatório' : null,
                      ),
                      onChanged: (_) {
                        if (showTitleError) {
                          setState(() => showTitleError = false);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        labelStyle: TextStyle(color: Colors.indigo),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: const Text('Selecionar Data'),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation:6,
                    shadowColor: Colors.black54,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isEmpty) {
                      setState(() => showTitleError = true);
                      return;
                    }

                    final newTodo = Todo(
                      title: titleController.text,
                      description: descriptionController.text,
                      date: selectedDate,
                      completed: todo?.completed ?? false,
                    );

                    if (todo == null) {
                      addTodo(newTodo);
                    } else if (index != null) {
                      editTodo(index, newTodo);
                    }

                    Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showTodoDetails(Todo todo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          todo.title,
          style: const TextStyle(color: Colors.indigo),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${todo.description.isNotEmpty ? todo.description : '(Sem descrição)'}',
              style: const TextStyle(color: Colors.indigo),
            ),
            const SizedBox(height: 12),
            Text(
              'Data: ${todo.date.toLocal().toString().split(" ")[0]}',
              style: const TextStyle(color: Colors.indigo),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${todo.completed ? 'Concluída' : 'Pendente'}',
              style: const TextStyle(color: Colors.indigo),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Fechar',
              style: TextStyle(color: Colors.indigo),
            ),
          ),
        ],
      ),
    );
  }

  void showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.all_inbox),
            title: const Text('Todas'),
            onTap: () {
              setState(() => filter = 'all');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Pendentes'),
            onTap: () {
              setState(() => filter = 'pending');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Concluídas'),
            onTap: () {
              setState(() => filter = 'completed');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Voltar',
        ),
        title: const Text('Lista de Tarefas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filtrar',
            onPressed: showFilterSheet,
          ),
        ],
      ),
      body: filteredTodos.isEmpty
          ? const Center(child: Text('Nenhuma tarefa'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = filteredTodos[index];
                final realIndex = todos.indexOf(todo);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Checkbox(
                      value: todo.completed,
                      onChanged: (_) => toggleTodoStatus(realIndex),
                      activeColor: Colors.green,
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        decoration: todo.completed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(
                      '${todo.description}\n${todo.date.toLocal().toString().split(" ")[0]}',
                    ),
                    isThreeLine: true,
                    onTap: () => showTodoDetails(todo),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.indigo),
                          onPressed: () => showAddOrEditTodoDialog(todo: todo, index: realIndex),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTodo(realIndex),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddOrEditTodoDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
