import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Column(
        children: [
          _buildTaskInput(),
          _buildTaskList(),
        ],
      ),
    );
  }

  Widget _buildTaskInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: taskController,
              decoration: InputDecoration(
                hintText: 'Enter a task',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _addTask(taskController.text, category: null);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return Expanded(
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return _buildTaskItem(tasks[index], index);
        },
      ),
    );
  }

  Widget _buildTaskItem(Task task, int index) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration:
          task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
        ),
      ),
      subtitle: task.category != null
          ? Text('Category: ${task.category}')
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editTask(index);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteTask(index);
            },
          ),
          task.isCompleted
              ? IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              _toggleTaskCompletion(index);
            },
          )
              : IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _toggleTaskCompletion(index);
            },
          ),
        ],
      ),
    );
  }

  void _addTask(String title, {String? category}) {
    if (title.isNotEmpty) {
      setState(() {
        tasks.add(Task(title: title, category: category ?? ""));
        taskController.clear();
      });
    }
  }

  void _editTask(int index) async {
    String editedTitle = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Task'),
        content: TextField(
          controller: TextEditingController(text: tasks[index].title),
          onChanged: (value) {
            // You can add additional logic as needed
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, taskController.text);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );

    if (editedTitle != null && editedTitle.isNotEmpty) {
      setState(() {
        tasks[index].title = editedTitle;
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }
}

class Task {
  String title;
  String category;
  bool isCompleted;

  Task({required this.title, this.category = "", this.isCompleted = false});
}
