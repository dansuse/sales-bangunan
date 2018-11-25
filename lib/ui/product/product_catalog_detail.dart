import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salbang/bloc/image_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/product/product_catalog_detail_picture.dart';

import 'product_catalog_detail_picture.dart';

class ProductCatalogDetail extends StatefulWidget {
  Product product;
  ProductCatalogDetail({this.product});
  @override
  _ProductCatalogDetailState createState() => _ProductCatalogDetailState();
}

class _ProductCatalogDetailState extends State<ProductCatalogDetail> {
  ImageBloc _imageBloc;

  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();
  String _appBarTitle = '';
  PageController _controller;
  bool _handleScrollNotification(ScrollNotification notification) {
    final String title = "Restu Jaya";
    double visibleStatsHeight = notification.metrics.pixels;
    double screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    double visiblePercentage = visibleStatsHeight / screenHeight;
    if (visiblePercentage > 0.45 && _appBarTitle != title) {
      setState(() {
        _appBarTitle = title;
      });
    } else if (visiblePercentage < 0.45 && _appBarTitle.isNotEmpty) {
      setState(() {
        _appBarTitle = "";
      });
    }
    return false;
  }

  List<Widget> _buildProductDetailWidget(String contoh) {
    List<Widget> cells = [];
    List<Widget> photos = [];
    final textContainer = new Container(
      color: colorWhite,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: new Stack(
                alignment: FractionalOffset.bottomCenter,
                children: <Widget>[
                  new StreamBuilder(
                      stream: _imageBloc.outputGetImageResponse,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print(snapshot.data.result.toString());
                          if (snapshot.data.result ==
                              ResponseDatabase.SUCCESS) {
                            List<Widget> abc = new List<Widget>();
                            for (int i = 0;
                                i < snapshot.data.data.length;
                                i++) {
                              print("detail : " + snapshot.data.data[i].url);
                              File a = new File(snapshot.data.data[i].url);
                              abc.add(new Hero(
                                tag: snapshot.data.data[i].url,
                                child: new Image.file(a),
                              ));
                            }
                            return new GestureDetector(
                              child: new PageView(
                                children: abc,
                                controller: _controller,
                              ),
                              onTap: () {
                                NavigationUtil.navigateToAnyWhere(context,
                                    new ProductCatalogDetailPicture(_controller.page.toInt(), productImages : abc));
                              },
                            );

//                                  snapshot.data.data.map((productImage){
//                                    File a = new File(productImage.url);
//                                   return new Hero(
//                                      tag: productImage.url,
//                                      child:  new Image.file(a),
//                                    );
//                                  }).toList();
                          } else if (snapshot.data.result ==
                              ResponseDatabase.SUCCESS_EMPTY) {
                            return new Hero(
                                tag: "1",
                                child: new Image.asset(
                                  "assets/image/asset_no_image_available.jpg",
                                  fit: BoxFit.fill,
                                  width: MediaQuery.of(context).size.width,
                                ));
                          } else if (snapshot.data.result ==
                              ResponseDatabase.ERROR_SHOULD_RETRY) {
                            return new Hero(
                                tag: "1",
                                child: new Image.asset(
                                  "assets/image/asset_no_image_available.jpg",
                                  fit: BoxFit.fill,
                                  width: MediaQuery.of(context).size.width,
                                ));
                          }
                        }
                        return new Hero(
                            tag: "1",
                            child: new Image.asset(
                              "assets/image/asset_no_image_available.jpg",
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                            ));
                      }),
                ]),
          ),
          const SizedBox(
            height: 4.0,
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 4.0, right: 4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildProductDescriptionWidget('Nama', widget.product.name),
                buildProductDescriptionWidget(
                    'Ukuran',
                    widget.product.size.toString() +
                        " " +
                        widget.product.productSize.name),
                buildProductDescriptionWidget(
                    'Tipe', widget.product.productType.name),
                buildProductDescriptionWidget(
                    'Merk', widget.product.productBrand.name),
                buildProductDescriptionWidget(
                    'Harga', widget.product.price.toString()),
                buildProductDescriptionWidget(
                    'Deskripsi', widget.product.description),
                const SizedBox(
                  height: 4.0,
                ),
                const SizedBox(
                  height: 4.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    cells.add(textContainer);
    return cells;
  }

  Widget buildProductDescriptionWidget(String label, String value) {
    return new Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Expanded(
          child: new Container(
            child: new Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: new Text(
                label,
                textAlign: TextAlign.left,
                style: Theme.of(context).primaryTextTheme.display2,
              ),
            ),
          ),
          flex: 5,
        ),
        new Expanded(
          child: new Container(
            child: new Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: new Text(":",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).primaryTextTheme.display2),
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
                style: Theme.of(context).primaryTextTheme.display2,
              ),
            ),
          ),
          flex: 9,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _imageBloc.getImageFromDatabase(widget.product.id);
    return new SafeArea(
        child: new Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorAppbar,
      body: new NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: new CustomScrollView(
          slivers: [
            new SliverAppBar(
              backgroundColor: colorPrimary,
              pinned: false,
              floating: true,
              snap: true,
              title: new Text(
                "Detail Produk",
                style: Theme.of(context).textTheme.title,
              ),
            ),
            new SliverList(
              delegate: new SliverChildListDelegate(
                  _buildProductDetailWidget("Erwin")),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    _imageBloc.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = new PageController();
    _imageBloc = ImageBloc(DBHelper());
    super.initState();
  }
}
