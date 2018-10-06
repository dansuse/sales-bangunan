import 'package:flutter/material.dart';
import 'package:salbang/bloc/size_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/product_size.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/product_size/data_product_size.dart';
import 'package:salbang/ui/product_size/product_size_master_list.dart';
import 'package:salbang/ui/product_size/product_size_settings.dart';

class ProductSizeMaster extends StatefulWidget {
  @override
  _ProductSizeMasterState createState() => _ProductSizeMasterState();
}

class _ProductSizeMasterState extends State<ProductSizeMaster> {
  SizeBloc _sizeBloc;

  @override
  void initState() {
    super.initState();
    _sizeBloc = SizeBloc(DBHelper());
  }

  @override
  Widget build(BuildContext context) {
    _sizeBloc.getSizesData();
    return Scaffold(
      body: new StreamBuilder<ResponseSalbang<List<ProductSize>>>(
        stream: _sizeBloc.outputListDataSizes,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.result == ResultResponseSalbang.GET_SIZE_SUCESS) {
            return new CustomScrollView(
              slivers: <Widget>[
                new SliverAppBar(
                  backgroundColor: colorAppbar,
                  title: new Text("Master Ukuran"),
                  actions: <Widget>[
                    new IconButton(
                        icon: new Icon(Icons.add),
                        color: colorButtonAdd,
                        onPressed: () {
                          DataProductSize _dataProductSize = new DataProductSize(addMode: true, productSize: null);
                          NavigationUtil.navigateToAnyWhere(
                            context, ProductSizeSettings(dataProductSize: _dataProductSize,),

                          );
                        })
                  ],
                ),
                new SliverList(
                  delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return new Container(
                        child: new GestureDetector(
                          onTap: () {},
                          child:
                              new ProductSizeMasterList(snapshot.data.data[index]),
                        ),
                      );
                    },
                    childCount: snapshot.data.data.length,
                  ),
                ),
              ],
            );
          }
          return new CustomScrollView(
            slivers: <Widget>[
              new SliverAppBar(
                backgroundColor: colorAppbar,
                title: new Text("Master Ukuran"),
                actions: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.add),
                      color: colorButtonAdd,
                      onPressed: () {
                        DataProductSize _dataProductSize = new DataProductSize(addMode: true, productSize: null);
                        NavigationUtil.navigateToAnyWhere(
                          context, ProductSizeSettings(dataProductSize: _dataProductSize,),

                        );
                      })
                ],
              ),
              new SliverList(
                delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return new SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: new Center(
                          child: Text("Tidak Ada Data"),
                        ));
                  },
                  childCount: 1,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
