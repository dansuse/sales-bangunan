import 'package:flutter/material.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/util/currency_util.dart';

class ProductListItems extends StatelessWidget {
  final Product product;
  ProductListItems(this.product);
  @override
  Widget build(BuildContext context) {
    return new Card(
      elevation: 0.0,
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(
              child: buildProductDescriptionWidget(context, 'Nama', product.name),
            ),
            new Expanded(
              child: buildProductDescriptionWidget(context, 'Ukuran', product.productSize.name),
            ),
            new Expanded(
              child: buildProductDescriptionWidget(context, 'Tipe', product.productType.name),
            ),
            new Expanded(
              child: buildProductDescriptionWidget(context, 'Merk', product.productBrand.name),
            ),
            new Expanded(
              child: buildProductDescriptionWidget(context, 'Harga', CurrencyUtil.parseDoubleToIDR(123456.0)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductDescriptionWidget(BuildContext context, String label, String value) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Expanded(
          child: new Container(
            child: new Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: new Text(
                label,
                textAlign: TextAlign.left,
                style: Theme.of(context).primaryTextTheme.display1,
              ),
            ),
          ),
          flex: 6,
        ),
        new Expanded(
          child: new Container(
            child: new Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: new Text(
                ":",
                textAlign: TextAlign.left,
                style: Theme.of(context).primaryTextTheme.display1,
              ),
            ),
          ),
          flex: 1,
        ),
        new Expanded(
          child: new Container(
            child: new Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: new Text(
                value,
                textAlign: TextAlign.left,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: Theme.of(context).primaryTextTheme.display1,
              ),

            ),
          ),
          flex: 9,
        ),
      ],
    );
  }
}
