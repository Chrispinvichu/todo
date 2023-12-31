import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo/todo_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    startSplashScreenTimer();
  }

  startSplashScreenTimer() async {
    var _duration =  Duration(seconds: 2);
    return  Timer(_duration, navigationToNextPage);

  }

  void navigationToNextPage() async {
    Navigator.pushAndRemoveUntil(
      context,  MaterialPageRoute(builder: (context) =>
        Todo_App()),
          (Route<dynamic> route) => false,//
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage("asset/logo/logoo.png"),radius: 70,
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 50,),
            SizedBox(
              width: 300,
              child: Center(
                child: LinearProgressIndicator(
                  backgroundColor: Colors.pink[300],
                ),
              ),
            ),
            SizedBox(height: 50,),

          ]
      ),
    );
  }
}