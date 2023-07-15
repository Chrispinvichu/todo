import 'package:flutter/material.dart';
import 'package:todo/sql_helper.dart';
import 'package:todo/todo_page.dart';
main()
{
  runApp(ToDo_App());
}
class ToDo_App extends StatelessWidget {
  const ToDo_App({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Todo_App()
    );
  }
}


