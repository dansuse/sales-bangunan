import 'package:flutter/material.dart';
import 'package:salbang/bloc/type_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/database/response_salbang.dart';
import 'package:salbang/model/product_type.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/product_type/product_type_add_layout.dart';
import 'package:salbang/ui/product_type/product_type_master_list.dart';

class ProductTypeMaster extends StatefulWidget {
  @override
  _ProductTypeMasterState createState() => _ProductTypeMasterState();
}

class _ProductTypeMasterState extends State<ProductTypeMaster> {
  TypeBloc _typeBloc;

  @override
  void initState() {
    super.initState();
    _typeBloc = TypeBloc(DBHelper());
  }

  @override
  Widget build(BuildContext context) {
    _typeBloc.getTypesData();
    return Scaffold(
      body: new StreamBuilder<ResponseDatabase<List<ProductType>>>(
        stream: _typeBloc.outputListDataTypes,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data.result == ResponseDatabase.LOADING) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(colorAccent),
              ),
            );
          } else if (snapshot.hasData &&
              snapshot.data.result == ResponseDatabase.SUCCESS) {
            return new CustomScrollView(
              slivers: <Widget>[
                new SliverAppBar(
                  backgroundColor: colorAppbar,
                  title: new Text("Master Tipe"),
                  actions: <Widget>[
                    new IconButton(
                        icon: new Icon(Icons.add),
                        color: colorButtonAdd,
                        onPressed: () {
                          NavigationUtil.navigateToAnyWhere(
                            context,
                            ProductTypeAddLayout(),
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
                          child: new ProductTypeMasterList(
                              snapshot.data.data[index]),
                        ),
                      );
                    },
                    childCount: snapshot.data.data.length,
                  ),
                ),
              ],
            );
          } else if (snapshot.hasData &&
              snapshot.data.result == ResponseDatabase.SUCCESS_EMPTY) {
            return new CustomScrollView(
              slivers: <Widget>[
                new SliverAppBar(
                  backgroundColor: colorAppbar,
                  title: new Text("Master Tipe"),
                  actions: <Widget>[
                    new IconButton(
                        icon: new Icon(Icons.add),
                        color: colorButtonAdd,
                        onPressed: () {
                          NavigationUtil.navigateToAnyWhere(
                            context,
                            ProductTypeAddLayout(),
                          );
                        })
                  ],
                ),
                new SliverList(
                  delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Center(child: Text("Tidak Ada Data Tipe Produk"));
                    },
                    childCount: 1,
                  ),
                ),
              ],
            );
          }
          return new CustomScrollView(
            slivers: <Widget>[
              new SliverAppBar(
                backgroundColor: colorAppbar,
                title: new Text("Master Tipe"),
                actions: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.add),
                      color: colorButtonAdd,
                      onPressed: () {
                        NavigationUtil.navigateToAnyWhere(
                          context,
                          ProductTypeAddLayout(),
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
