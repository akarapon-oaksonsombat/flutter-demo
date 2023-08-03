import 'package:demo/continuous_list/continuous_list.dart';
import 'package:demo/continuous_list/continuous_list_provider.dart';
import 'package:demo/continuous_list_reversed/continuous_list_reversed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'continuous_list_reversed/continuous_list_reversed_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContinuousListProvider()),
        ChangeNotifierProvider(create: (_) => ContinuousListReversedProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blue, inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder())),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Continuous List'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContinuousList())),
          ),
          ListTile(
            title: const Text('Continuous List Reversed'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ContinuousListReversed())),
          )
        ],
      ),
    );
  }
}
