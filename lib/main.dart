import 'package:flutter/material.dart';
import 'package:salbang/bloc/my_homepage_bloc.dart';
import 'package:salbang/bloc/type_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/ui/my_homepage.dart';

import 'resources/themes.dart';

void main(){
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Salbang',
      debugShowCheckedModeBanner: false,
      theme: salbangTheme(),
      home: BlocProvider<MyHomePageBloc>(
        bloc: MyHomePageBloc(),
        child : BlocProvider<TypeBloc>(
          bloc: TypeBloc(DBHelper()),
          child: new MyHomePage(),
        )

      ),
    );
  }
}


