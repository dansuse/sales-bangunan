import 'package:flutter/material.dart';
import 'package:salbang/bloc/product_bloc.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/global_widget/progress_indicator_builder.dart';

import 'package:salbang/ui/product/product_catalog_detail.dart';
import 'package:salbang/ui/product/product_catalog_list_items.dart';
import 'package:salbang/model/product.dart';

class ProductCatalog extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<ProductCatalog> {

  ProductBloc productBloc;
  @override
  Widget build(BuildContext context) {
    productBloc = BlocProvider.of<ProductBloc>(context);
    productBloc.getProductsForCatalog();
    return Container(
        child: new StreamBuilder<ResponseDatabase<List<Product>>>(
          stream: productBloc.outputCatalogProducts,
          builder: (context, snapshot){
            if(snapshot.hasData){
              if(snapshot.data.result == ResponseDatabase.SUCCESS){
                return new CustomScrollView(
                  slivers: <Widget>[
                    new SliverPadding(
                      padding: const EdgeInsets.all(8.0),
                      sliver: new SliverGrid(
                        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3,
                            childAspectRatio: 2.0),
                        delegate: new SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return new GestureDetector(
                              onTap: (){NavigationUtil.navigateToAnyWhere(context, new ProductCatalogDetail());},
                              child: new ProductListItems(snapshot.data.data[index]),
                            );
                          },
                          childCount: snapshot.data.data.length,
                        ),
                      ),
                    ),
                  ],
                );
              } else if(snapshot.data.result == ResponseDatabase.SUCCESS_EMPTY){
                return const Center(
                  child: Text('No Data Available'),
                );
              } else if(snapshot.data.result == ResponseDatabase.ERROR_SHOULD_RETRY){
                return GestureDetector(
                  onTap: (){productBloc.getProductsForCatalog();},
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
