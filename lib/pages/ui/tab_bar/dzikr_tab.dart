import 'package:flutter/material.dart';

class TabDzikr extends StatefulWidget {
  const TabDzikr({Key? key}) : super(key: key);

  @override
  State<TabDzikr> createState() => _TabDzikrState();
}

class _TabDzikrState extends State<TabDzikr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Dzikir")));
  }
}
