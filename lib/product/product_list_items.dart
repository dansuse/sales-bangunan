import 'package:flutter/material.dart';

class ProductListItems extends StatelessWidget {
  final String isi;
  ProductListItems(this.isi);
  @override
  Widget build(BuildContext context) {
    Widget buildProductDescriptionWidget(String label, String value) {
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

    return new Card(
      child: new Padding(
        padding: EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(
              child: buildProductDescriptionWidget('Nama', isi),
            ),
            new Expanded(
              child: buildProductDescriptionWidget('Ukuran', 'Nama Produk'),
            ),
            new Expanded(
              child: buildProductDescriptionWidget('Tipe', 'Nama Produk'),
            ),
            new Expanded(
              child: buildProductDescriptionWidget('Merk', 'Nama Produk'),
            ),
            new Expanded(
              child: buildProductDescriptionWidget('Harga', 'Nama Produk'),
            ),
          ],
        ),
      ),
    );
  }
}
