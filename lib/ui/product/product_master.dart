import 'package:flutter/material.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/product/product_master_list.dart';
import 'package:salbang/ui/product/product_settings.dart';

class ProductMaster extends StatefulWidget {
  @override
  _ProductMasterState createState() => _ProductMasterState();
}

class _ProductMasterState extends State<ProductMaster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          new SliverAppBar(
            backgroundColor: colorAppbar,
            title: new Text("Master Produk"),
            actions: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.add),
                  color: colorButtonAdd,
                  onPressed: () {
                    NavigationUtil.navigateToAnyWhere(
                        context, ProductSettings(),);
                  })
            ],
          ),
          new SliverList(
            delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return new Container(
                  child: new GestureDetector(
                    onTap: () {},
                    child: new ProductMasterList(),
                  ),
                );
              },
              childCount: 120,
            ),
          )
        ],
      ),
    );
  }
}
