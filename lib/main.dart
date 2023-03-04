import 'package:chats_app/logics.dart';
import 'package:flutter/material.dart';
import 'package:chats_app/allchatpage.dart';
import 'package:provider/provider.dart';

import 'login.dart';

void main() => runApp(
  ChangeNotifierProvider(
      create: (context) => ChatServices(),
      child: const MyApp(),
    ),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }

}