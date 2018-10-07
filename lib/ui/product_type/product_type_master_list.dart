import 'package:flutter/material.dart';
import 'package:salbang/model/product_type.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/product_type/product_type_update_layout.dart';

class ProductTypeMasterList extends StatefulWidget {
  final ProductType productType;
  ProductTypeMasterList(this.productType);
  @override
  _ProductTypeMasterListState createState() => _ProductTypeMasterListState();
}

class _ProductTypeMasterListState extends State<ProductTypeMasterList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new Text(
            widget.productType.name,
            softWrap: false,
            overflow: TextOverflow.fade,
            style: Theme.of(context).primaryTextTheme.display2,
          )),
          widget.productType.status == 1
              ? new IconButton(
                  icon: new Icon(Icons.edit),
                  onPressed: () {
//              final DataProductType _dataProductType = new DataProductType(addMode: false, productType: widget.productType);
                    NavigationUtil.navigateToAnyWhere(
                      context,
                      ProductTypeUpdateLayout(
                        productType: widget.productType,
                      ),
                    );
                  },
                  color: colorEdit,
                )
              : new Container(),
          widget.productType.status == 1
              ? new IconButton(
                  icon: new Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                              title: new Text("Delete Katalog Tipe"),
                              content: new Text(
                                  'Apakah anda yakin untuk menghapus tipe ' +
                                      widget.productType.name +
                                      ''
                                      ' ? \njika iya maka semua barang yang bertipe ' +
                                      widget.productType.name +
                                      ''
                                      ' akan terhapus.'),
                              actions: <Widget>[
                                new Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    new FlatButton(
                                        onPressed: () {},
                                        child: new Text(
                                          'Tidak',
                                          style: TextStyle(color: colorDelete),
                                        )),
                                    new FlatButton(
                                        onPressed: () {},
                                        child: new Text(
                                          'Setuju',
                                          style:
                                              TextStyle(color: colorButtonAdd),
                                        )),
                                  ],
                                )
                              ]),
                    );
                  },
                  color: colorDelete)
              : new IconButton(
                  icon: new Icon(Icons.check),
                  onPressed: () {},
                  color: colorDelete),
        ],
      ),
    );
  }
}
