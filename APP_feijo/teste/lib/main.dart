// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'login_page.dart';
// import 'theme/app_theme.dart';

// class Todo {
//   String title;
//   String description;
//   DateTime date;
//   bool completed;

//   Todo({
//     required this.title,
//     required this.description,
//     required this.date,
//     this.completed = false,
//   });

//   Map<String, dynamic> toJson() => {
//         'title': title,
//         'description': description,
//         'date': date.toIso8601String(),
//         'completed': completed,
//       };

//   factory Todo.fromJson(Map<String, dynamic> json) => Todo(
//         title: json['title'],
//         description: json['description'],
//         date: DateTime.parse(json['date']),
//         completed: json['completed'],
//       );
// }

// void main() {
//   runApp(const TodoApp());
// }

// class TodoApp extends StatelessWidget {
//   const TodoApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Trabalho Feijo',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.lightTheme,
//       home: const LoginPage(),
//     );
//   }
// }

// class TodoHomePage extends StatefulWidget {
//   const TodoHomePage({super.key});

//   @override
//   State<TodoHomePage> createState() => _TodoHomePageState();
// }

// class _TodoHomePageState extends State<TodoHomePage> {
//   List<Todo> todos = [];
//   String filter = 'all';

//   @override
//   void initState() {
//     super.initState();
//     loadTodos();
//   }

//   Future<void> loadTodos() async {
//     final prefs = await SharedPreferences.getInstance();
//     final data = prefs.getString('todos');
//     if (data != null) {
//       final jsonList = jsonDecode(data) as List;
//       setState(() {
//         todos = jsonList.map((json) => Todo.fromJson(json)).toList();
//       });
//     }
//   }

//   Future<void> saveTodos() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = todos.map((todo) => todo.toJson()).toList();
//     prefs.setString('todos', jsonEncode(jsonList));
//   }

//   void addTodo(Todo todo) {
//     setState(() {
//       todos.add(todo);
//     });
//     saveTodos();
//   }

//   void toggleTodoStatus(int index) {
//     setState(() {
//       todos[index].completed = !todos[index].completed;
//     });
//     saveTodos();
//   }

//   List<Todo> get filteredTodos {
//     switch (filter) {
//       case 'pending':
//         return todos.where((t) => !t.completed).toList();
//       case 'completed':
//         return todos.where((t) => t.completed).toList();
//       default:
//         return todos;
//     }
//   }

//   void showAddTodoDialog() {
//     final titleController = TextEditingController();
//     final descriptionController = TextEditingController();
//     DateTime selectedDate = DateTime.now();

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Nova Tarefa'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Título',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Descrição',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 2,
//               ),
//               const SizedBox(height: 12),
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.date_range),
//                 label: const Text('Selecionar Data'),
//                 onPressed: () async {
//                   final picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2100),
//                   );
//                   if (picked != null) {
//                     selectedDate = picked;
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancelar'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (titleController.text.trim().isEmpty) {
//                 // Pode mostrar uma mensagem ou validar antes
//                 return;
//               }
//               addTodo(Todo(
//                 title: titleController.text.trim(),
//                 description: descriptionController.text.trim(),
//                 date: selectedDate,
//               ));
//               Navigator.pop(context);
//             },
//             child: const Text('Adicionar'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lista de Tarefas'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredTodos.length,
//               itemBuilder: (context, index) {
//                 final todo = filteredTodos[index];
//                 return Card(
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   elevation: 3,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     contentPadding:
//                         const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     leading: Icon(
//                       todo.completed
//                           ? Icons.check_circle
//                           : Icons.radio_button_unchecked,
//                       color: todo.completed ? Colors.green : Colors.grey,
//                       size: 28,
//                     ),
//                     title: Text(
//                       todo.title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         decoration: todo.completed
//                             ? TextDecoration.lineThrough
//                             : null,
//                       ),
//                     ),
//                     subtitle: Text(
//                       '${todo.description}\n${todo.date.toLocal().toString().split(" ")[0]}',
//                       style: const TextStyle(
//                           height: 1.5, fontSize: 14, color: Colors.black87),
//                     ),
//                     trailing: Checkbox(
//                       value: todo.completed,
//                       onChanged: (_) =>
//                           toggleTodoStatus(todos.indexOf(todo)),
//                       activeColor: Colors.indigo,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 showModalBottomSheet(
//                   context: context,
//                   shape: const RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(24)),
//                   ),
//                   builder: (_) {
//                     return Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         ListTile(
//                           leading:
//                               const Icon(Icons.all_inbox, color: Colors.indigo),
//                           title: const Text('Todas'),
//                           onTap: () {
//                             setState(() => filter = 'all');
//                             Navigator.pop(context);
//                           },
//                         ),
//                         ListTile(
//                           leading:
//                               const Icon(Icons.schedule, color: Colors.indigo),
//                           title: const Text('Pendentes'),
//                           onTap: () {
//                             setState(() => filter = 'pending');
//                             Navigator.pop(context);
//                           },
//                         ),
//                         ListTile(
//                           leading:
//                               const Icon(Icons.check, color: Colors.indigo),
//                           title: const Text('Concluídas'),
//                           onTap: () {
//                             setState(() => filter = 'completed');
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               icon: const Icon(Icons.filter_list, size: 28),
//               label: const Text(
//                 'Filtrar Tarefas',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.indigo,
//                 foregroundColor: Colors.white,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 elevation: 5,
//                 shadowColor: Colors.indigoAccent,
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: showAddTodoDialog, 
//         tooltip: 'Adicionar nova tarefa',
//         child: const Icon(Icons.add, size: 32),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:teste/theme/app_theme.dart';
import 'login_page.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}
