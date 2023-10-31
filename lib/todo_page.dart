import 'package:flutter/material.dart';
import 'package:todo_list/database_helper.dart';
import 'package:todo_list/todo.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
  });
  
  @override
  State<StatefulWidget> createState() => _TodoList();
}

class _TodoList extends State<TodoList>{
  TextEditingController _namaController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  List<Todo> todoList = [];

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList() async {
    // Mengubah tampilan sesuai data yang diubah
    // setState(() {
    //   todoList = todoList;
    // });

    final todos = await dbHelper.getAllTodos();
    setState(() {
      todoList = todos;
    });

  }

  void addItem() async {
    await dbHelper.addTodo(Todo(_namaController.text, _deskripsiController.text));
    // todoList.add(Todo(_namaController.text, _deskripsiController.text));
    refreshList();

    _namaController.text = '';
    _deskripsiController.text = '';
  }

  void updateItem(int index, bool checkmark) async {
    todoList[index].checkmark = checkmark;
    await dbHelper.updateTodo(todoList[index]);
    refreshList();     
  }

  void deleteItem(int id) async {
    // todoList.removeAt(index);
    await dbHelper.deleteTodo(id);
    refreshList();
  }

  void tampilForm() {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.all(20),
        title: Text("Add To-Do"),
        actions: [
          ElevatedButton(
            onPressed: () {
            Navigator.pop(context);
          },child: Text("Close")),
          ElevatedButton(
            onPressed: () {
              addItem();
            Navigator.pop(context);
          },child: Text("Save")),
        ],
        content: Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TextField(
                controller: _namaController,
                decoration: InputDecoration(hintText: 'Nama Kegiatan'),),
              TextField(
                controller: _deskripsiController,
                decoration: InputDecoration(hintText: 'Deskripsi Kegiatan')),
            ],
          ),
        ),
      )
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tampilForm();
        },
        child: const Icon(Icons.add_box),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: todoList[index].checkmark
                  ? IconButton(
                    icon: const Icon(Icons.check_circle),
                    onPressed: () {
                      updateItem(index, !todoList[index].checkmark);
                    },
                  )
                  : IconButton(
                    icon: const Icon(Icons.radio_button_unchecked),
                    onPressed: () {
                      updateItem(index, !todoList[index].checkmark);
                    },
                  ), 
                  title: Text(todoList[index].nama),
                  subtitle: Text(todoList[index].deksripsi),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteItem(todoList[index].id ?? 0);
                    },
                  ),
                );
              })
          ),
        ],
      ),
    );
  }
}