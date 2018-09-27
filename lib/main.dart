import 'package:flutter/material.dart';
import 'package:salbang/bloc/my_homepage_bloc.dart';

import 'package:salbang/ui/my_homepage.dart';
import 'package:salbang/provider/bloc_provider.dart';

import 'resources/themes.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Salbang',
      debugShowCheckedModeBanner: false,
      theme: salbangTheme(),
      home: BlocProvider<MyHomePageBloc>(
        bloc: MyHomePageBloc(),
        child: new MyHomePage(),
      ),
    );
  }
}


