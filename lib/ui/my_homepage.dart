import 'dart:async';

import 'package:flutter/material.dart';
import 'package:salbang/bloc/brand_bloc.dart';
import 'package:salbang/bloc/cupertino_picker_bloc.dart';
import 'package:salbang/bloc/my_homepage_bloc.dart';
import 'package:salbang/bloc/product_bloc.dart';
import 'package:salbang/bloc/size_bloc.dart';
import 'package:salbang/bloc/type_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/drawer_items.dart';
import 'package:salbang/drawer_list_data.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/ui/product/product_catalog.dart';
import 'package:salbang/ui/product/product_master.dart';
import 'package:salbang/ui/product_brand/product_brand_master.dart';
import 'package:salbang/ui/product_size/product_size_master.dart';
import 'package:salbang/ui/product_type/product_type_master.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  MyHomePageBloc _myHomePageBloc;
  DrawerListItemData _drawerListItemData;
  List<DrawerItems> _drawerItemsData;
  @override
  void initState() {
    super.initState();
    _drawerListItemData = new DrawerListItemData();
    _drawerItemsData = _drawerListItemData.drawerContainer();
  }

  Widget _buildTiles(DrawerItems root) {
    return root.children.isEmpty
        ? new ListTile(
            onTap: () {
              _myHomePageBloc.inputHomePageBody.add(root.index);
              Navigator.of(context).pop();
            },
            title: new Text(root.title))
        : new ExpansionTile(
            key: new PageStorageKey<DrawerItems>(root),
            title: new Text(root.title),
            initiallyExpanded: true,
            children: root.children.map(_buildTiles).toList(),
          );
  }

  Widget _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new BlocProvider<ProductBloc>(
          bloc: ProductBloc(DBHelper()),
          child: ProductCatalog(),
        );
      case 1:
        return ProductCatalog();
      case 3:
        return new BlocProvider<ProductBloc>(
          bloc: ProductBloc(DBHelper()),
          child: new BlocProvider<CupertinoPickerBloc>(
            bloc: CupertinoPickerBloc(DBHelper()),
            child: new ProductMaster(),
          ),
        );
      case 4:
        return new BlocProvider<BrandBloc>(
          bloc: BrandBloc(DBHelper()),
          child: new BlocProvider<ProductBloc>(
            bloc: ProductBloc(DBHelper()),
            child: new ProductBrandMaster(),
          ),
        );
      case 5:
        return new BlocProvider<TypeBloc>(
          bloc: TypeBloc(DBHelper()),
          child: new BlocProvider<ProductBloc>(
            bloc: ProductBloc(DBHelper()),
            child: new ProductTypeMaster(),
          ),
        );
      case 6:
        return new BlocProvider<SizeBloc>(
          bloc: SizeBloc(DBHelper()),
          child: new BlocProvider<ProductBloc>(
            bloc: ProductBloc(DBHelper()),
            child: new ProductSizeMaster(),
          ),
        );
      default:
        return new ProductCatalog();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('- build homepage');
    _myHomePageBloc = BlocProvider.of<MyHomePageBloc>(context);
    final List<Widget> drawerOptions = <Widget>[];
    for (int i = 0; i < _drawerItemsData.length; i++) {
      final DrawerItems root = _drawerItemsData[i];
      drawerOptions.add(_buildTiles(root));
      drawerOptions.add(const Divider(
        height: 0.1,
      ));
    }
    Future<bool> _onWillPop() {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Pemberitahuan'),
          content: new Text('Apakah Anda Yakin Ingin Keluar Dari Aplikasi?'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('Tidak'),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: new Text('Ya'),
            ),
          ],
        ),
      ) ?? false;
    }
    return new SafeArea(child: new WillPopScope(
        child:new Scaffold(
      key: _key,
      appBar: new AppBar(
        backgroundColor: colorAppbar,
        title: const Text('Sal-Bang'),
        centerTitle: true,
        elevation: 0.0,
      ),
      drawer: new Drawer(
        child: new SafeArea(
          child: new ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[new Column(children: drawerOptions)],
          ),
        ),
      ),
      body: new SafeArea(
        child: new StreamBuilder<int>(
          stream: _myHomePageBloc.outputHomePageBody,
          builder: (context, snapshot) {
            return _getDrawerItemWidget(snapshot.hasData ? snapshot.data : 3);
          },
        ),
      ),
    ) ,onWillPop: _onWillPop), );
  }
}
