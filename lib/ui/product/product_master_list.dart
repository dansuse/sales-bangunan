import 'package:flutter/material.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/product/product_settings.dart';

class ProductMasterList extends StatefulWidget {
  @override
  _ProductMasterListState createState() => _ProductMasterListState();
}

class _ProductMasterListState extends State<ProductMasterList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
        child:  new Row(
          children: <Widget>[
            new Expanded(
                child: new Text(
                  "String",
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).primaryTextTheme.display2,
                )),
            new IconButton(
              icon: new Icon(Icons.edit),
              onPressed: () {
                NavigationUtil.navigateToAnyWhere(
                    context, ProductSettings(addMode: false),);
              },
              color: colorEdit,
            ),
            new IconButton(
                icon: new Icon(Icons.delete),
                onPressed: () {},
                color: colorDelete),
          ],
        ),

    );
  }
}
