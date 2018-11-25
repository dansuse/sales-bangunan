import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:salbang/model/product_image.dart';

class ProductCatalogDetailPicture extends StatefulWidget {
  int _controllerPage;
  List<Widget> productImages;
  ProductCatalogDetailPicture(this._controllerPage,{this.productImages});
  @override
  ProductCatalogDetailPictureState createState() => new ProductCatalogDetailPictureState();
}

class ProductCatalogDetailPictureState extends State<ProductCatalogDetailPicture> {
  PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new PageController(initialPage: widget._controllerPage);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: Text('Detail Picture',style: Theme.of(context).textTheme.title,),
      ),
      body: new Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child:
              new Stack(
                alignment: FractionalOffset.bottomCenter,
                children: <Widget>[
                  new PageView(
                    children: widget.productImages,
                    controller: _controller,
                  ),
                ],
              ),

      ),
    );
  }
}
