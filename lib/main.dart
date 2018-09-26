import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salbang/drawer_items.dart';
import 'package:salbang/product/product.dart';
import 'package:salbang/product/product_cupertino.dart';
import 'package:salbang/product/product_settings.dart';
import 'package:salbang/product_brand/product_brand_settings.dart';
import 'package:salbang/product_size/product_size_settings.dart';
import 'package:salbang/product_type/product_type_settings.dart';
import 'package:salbang/resources/colors.dart';
import 'resources/themes.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Salbang',
      debugShowCheckedModeBanner: false,
      theme: salbangTheme(),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<DrawerItems> data = <DrawerItems>[
    DrawerItems(
      'Katalog',
      children: <DrawerItems>[
        new DrawerItems('Produk', index: 0),
        new DrawerItems('Merk Produk', index: 1),
        new DrawerItems('Jenis Produk', index: 2),
      ],
    ),
    DrawerItems(
      'Master',
      children: <DrawerItems>[
        DrawerItems('Produk', index: 3),
        DrawerItems('Merk Produk', index: 4),
        DrawerItems('Jenis Produk', index: 5),
        DrawerItems('Ukuran Produk', index: 6),
      ],
    ),
  ];
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _selectedDrawerIndex = 0;

  Widget _buildTiles(DrawerItems root) {
    return root.children.isEmpty
        ? new ListTile(
            onTap: () {
              _onSelectItem(root.index);
            },
            selected: root.index == _selectedDrawerIndex,
            title: new Text(root.title))
        : new ExpansionTile(
            key: new PageStorageKey<DrawerItems>(root),
            title: new Text(root.title),
            initiallyExpanded: true,
            children: root.children.map(_buildTiles).toList(),
          );
  }

   _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Product();
      case 1:
        return new CupertinoPickerDemo();
      case 3:
        return new ProductSettings();
      case 4:
        return new ProductBrandSettings();
      case 5:
        return new ProductTypeSettings();
      case 6:
        return new ProductSizeSettings();
    }
  }

  void _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness:
            Brightness.dark //or set color with: Color(0xFF0000FF)
        ));
    final List<Widget> drawerOptions = <Widget>[];
    for (int i = 0; i < widget.data.length; i++) {
      final DrawerItems root = widget.data[i];
      drawerOptions.add(_buildTiles(root));
      drawerOptions.add(const Divider(
        height: 0.1,
      ));
    }
    return new Scaffold(
      key: _key,
      appBar: new AppBar(
        backgroundColor: colorAppbar,
        title: const Text('Salbang'),
        centerTitle: true,
        elevation: 1.0,
      ),
      drawer: new Drawer(
        child: new SafeArea(
          child: new ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[new Column(children: drawerOptions)],
          ),
        ),
      ),
      body: new SafeArea(child: _getDrawerItemWidget(_selectedDrawerIndex)),
    );
  }
}
