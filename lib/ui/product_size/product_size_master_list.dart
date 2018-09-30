import 'package:flutter/material.dart';
import 'package:salbang/model/product_size.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/product/product_settings.dart';
import 'package:salbang/ui/product_size/data_product_size.dart';
import 'package:salbang/ui/product_size/product_size_settings.dart';

class ProductSizeMasterList extends StatefulWidget {
  final ProductSize productSize;
  ProductSizeMasterList(this.productSize);
  @override
  _ProductSizeMasterListState createState() => _ProductSizeMasterListState();
}

class _ProductSizeMasterListState extends State<ProductSizeMasterList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child:  new Row(
        children: <Widget>[
          new Expanded(
              child: new Text(
                widget.productSize.name,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: Theme.of(context).primaryTextTheme.display2,
              )),
          widget.productSize.status == 1 ? new IconButton(
            icon: new Icon(Icons.edit),
            onPressed: () {
              final DataProductSize _dataProductSize = new DataProductSize(addMode: false, productSize: widget.productSize);
              NavigationUtil.navigateToAnyWhere(
                context, ProductSizeSettings(dataProductSize: _dataProductSize,),);
            },
            color: colorEdit,
          ) : new Container(),
          widget.productSize.status == 1 ?
          new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () {
                showDialog(context: context, builder: (_) => new AlertDialog(
                  title : new Text("Delete Katalog Ukuran"),
                    content:  new Text('Apakah anda yakin untuk menghapus ukuran dalam ' + widget.productSize.name + ''
                        ' ? \njika iya maka semua barang yang berukuran dalam '+ widget.productSize.name + ''
                        ' akan terhapus.'),
                    actions: <Widget>[
                      new Row(
                        mainAxisAlignment : MainAxisAlignment.end,
                        children: <Widget>[
                          new FlatButton(onPressed: (){}, child: new Text('Tidak',style: TextStyle(color: colorDelete),)),
                          new FlatButton(onPressed: (){}, child: new Text('Setuju',style: TextStyle(color: colorButtonAdd),)),
                        ],
                      )


                      ]
                ),
                );
              },
              color: colorDelete)
          :new IconButton(
              icon: new Icon(Icons.check),
              onPressed: () {},
              color: colorDelete),
        ],
      ),

    );
  }
}
