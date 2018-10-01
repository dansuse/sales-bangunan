import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'product_catalog_detail_picture.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/product/product_catalog_detail_picture.dart';

class ProductCatalogDetail extends StatefulWidget {
  @override
  _ProductCatalogDetailState createState() => _ProductCatalogDetailState();
}

class _ProductCatalogDetailState extends State<ProductCatalogDetail> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();
  String _appBarTitle = '';
  PageController _controller = new PageController();
  bool _handleScrollNotification(ScrollNotification notification) {
    final String title = "C/'antique";
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
    final textContainer = new Container(
      color: colorWhite,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: GestureDetector(
              child: new Stack(
                  alignment: FractionalOffset.bottomCenter,
                  children: <Widget>[
                    new PageView(
                      children: <Widget>[
                        new Hero(
                          tag: "1",
                          child: new CachedNetworkImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            placeholder: new CupertinoActivityIndicator(),
                            imageUrl: "http://via.placeholder.com/350x150",
                            errorWidget: new Image.asset(
                              "assets/image/asset_no_image_available.jpg",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        new Hero(
                          tag: "2",
                          child: new CachedNetworkImage(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            placeholder: new CircularProgressIndicator(),
                            imageUrl: "http://via.placeholder.com/350x150",
                            errorWidget: new Image.asset(
                              "assets/image/asset_no_image_available.jpg",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                      controller: _controller,
                    ),
                  ]),
              onTap: () {
                NavigationUtil.navigateToAnyWhere(context, new ProductCatalogDetailPicture(1));
              },
            ),
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
                buildProductDescriptionWidget('Nama', contoh),
                buildProductDescriptionWidget('Ukuran', contoh+" "+contoh+" "+contoh+" "+contoh+" "+contoh+" "+contoh+" "+contoh+" "),
                buildProductDescriptionWidget('Tipe', contoh),
                buildProductDescriptionWidget('Merk', contoh),
                buildProductDescriptionWidget('Harga', contoh),
                buildProductDescriptionWidget('Deskripsi', contoh+" "+contoh+" "+contoh+" "+contoh+" "+contoh+" "+contoh+" "+contoh+" "),

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
                value ,
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
    return new Scaffold(
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
}
