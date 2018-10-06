import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ProductCatalogDetailPicture extends StatefulWidget {
  int _controllerPage;
  ProductCatalogDetailPicture(this._controllerPage);
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
                    children: <Widget>[
                      new PhotoView(
                        imageProvider: NetworkImage("http://via.placeholder.com/350x150"),
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: 4.0,
                        heroTag: "1",
                        loadingChild: new SizedBox(),
                      ),
                      new PhotoView(
                        imageProvider: NetworkImage("http://via.placeholder.com/350x150"),
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        maxScale: 4.0,
                        heroTag: "2",
                        loadingChild: new SizedBox(),
                      ),
                    ],
                  ),
                ],
              ),

      ),
    );
  }
}
