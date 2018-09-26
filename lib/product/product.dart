import 'package:flutter/material.dart';
import 'package:salbang/product/product_list_items.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new CustomScrollView(
      slivers: <Widget>[
        new SliverPadding(
            padding: new EdgeInsets.all(8.0),
            sliver: new SliverGrid(
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
              childAspectRatio: 2.0),
              delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return new ProductListItems('Erwin Tandean');
                },
                childCount: 2250,
              ),
            ),),
      ],
    ),);
  }
}
