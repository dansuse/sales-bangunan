import 'package:flutter/material.dart';
import 'package:salbang/bloc/cupertino_picker_bloc.dart';
import 'package:salbang/bloc/my_homepage_bloc.dart';
import 'package:salbang/bloc/size_bloc.dart';
import 'package:salbang/bloc/type_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/database/response_salbang.dart';
import 'package:salbang/model/product_type.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/product_size/data_product_size.dart';
import 'package:salbang/ui/product_size/product_size_settings.dart';
import 'package:salbang/ui/product_type/product_type_add_layout.dart';
import 'package:salbang/ui/product_type/product_type_master_list.dart';
import 'package:salbang/ui/product_type/product_type_update_layout.dart';

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
      body: new StreamBuilder<ResponseSalbang<List<ProductType>>>(
        stream: _typeBloc.outputListDataTypes,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.result == ResultResponseSalbang.GET_SQFLITE_SUCCESS) {
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
                            context, ProductTypeAddLayout(),

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
                              new ProductTypeMasterList(snapshot.data.data[index]),
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
                title: new Text("Master Tipe"),
                actions: <Widget>[
                  new IconButton(
                      icon: new Icon(Icons.add),
                      color: colorButtonAdd,
                      onPressed: () {
                        NavigationUtil.navigateToAnyWhere(
                          context, ProductTypeAddLayout(),

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
