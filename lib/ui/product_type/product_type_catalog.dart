import 'package:flutter/material.dart';
import 'package:salbang/bloc/product_bloc.dart';
import 'package:salbang/bloc/type_bloc.dart';
import 'package:salbang/model/product_type.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/global_widget/progress_indicator_builder.dart';

import 'package:salbang/ui/product/product_catalog_detail.dart';
import 'package:salbang/ui/product/product_catalog_list_items.dart';
import 'package:salbang/model/product.dart';

class ProductTypeCatalog extends StatefulWidget {
  @override
  _ProductTypeState createState() => _ProductTypeState();
}

class _ProductTypeState extends State<ProductTypeCatalog> {
  TypeBloc typeBloc;
  @override
  Widget build(BuildContext context) {
    typeBloc = BlocProvider.of<TypeBloc>(context);
    typeBloc.getTypesData();
    return Container(
      child: new StreamBuilder<ResponseDatabase<List<ProductType>>>(
        stream: typeBloc.outputListDataTypes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.result == ResponseDatabase.SUCCESS) {
              return new CustomScrollView(
                slivers: <Widget>[
                  new SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: new SliverGrid(
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? 2
                                      : 3,
                              childAspectRatio: 3.0),
                      delegate: new SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return new GestureDetector(
                            onTap: () {
                            },
                            child:
                                new Card(
                                  child: new Padding(padding: EdgeInsets.all(8.0),
                                  child: new Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        snapshot.data.data[index].name,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                          ),);
                        },
                        childCount: snapshot.data.data.length,
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.data.result == ResponseDatabase.SUCCESS_EMPTY) {
              return const Center(
                child: Text('No Data Available'),
              );
            } else if (snapshot.data.result ==
                ResponseDatabase.ERROR_SHOULD_RETRY) {
              return GestureDetector(
                onTap: () {
                  typeBloc.getTypesData();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Tap to retry'),
                  ],
                ),
              );
            }
          }
          return ProgressIndicatorBuilder.getCenterCircularProgressIndicator();
        },
      ),
    );
  }
}
