import 'package:flutter/material.dart';
import 'package:salbang/bloc/product_bloc.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/global_widget/progress_indicator_builder.dart';
import 'package:salbang/ui/product/product_master_list.dart';
import 'package:salbang/ui/product/product_settings.dart';

class ProductMaster extends StatefulWidget {
  @override
  _ProductMasterState createState() => _ProductMasterState();
}

class _ProductMasterState extends State<ProductMaster> {
  ProductBloc productBloc;

  @override
  Widget build(BuildContext context) {
    productBloc = BlocProvider.of<ProductBloc>(context);
    productBloc.getProductsForMaster();
    return Scaffold(
      body: StreamBuilder<ResponseDatabase<List<Product>>>(
        stream: productBloc.outputMasterProducts,
        builder: (context, snapshot){
          if(snapshot.hasData){
            if(snapshot.data.result == ResponseDatabase.SUCCESS){
              return new CustomScrollView(
                slivers: <Widget>[
                  new SliverAppBar(
                    backgroundColor: colorAppbar,
                    title: new Text("Master Produk"),
                    actions: <Widget>[
                      new IconButton(
                          icon: new Icon(Icons.add),
                          color: colorButtonAdd,
                          onPressed: () {
                            NavigationUtil.navigateToAnyWhere(
                              context, ProductSettings(null),);
                          })
                    ],
                  ),
                  new SliverList(
                    delegate: new SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return new Container(
                          child: new GestureDetector(
                            onTap: () {},
                            child: new ProductMasterList(snapshot.data.data[index]),
                          ),
                        );
                      },
                      childCount: snapshot.data.data.length,
                    ),
                  )
                ],
              );
            }else if(snapshot.data.result == ResponseDatabase.SUCCESS_EMPTY){
              return getEmptyWidget();
            }else if(snapshot.data.result == ResponseDatabase.ERROR_SHOULD_RETRY){
              return getEmptyWidget();
            }else{
              return getEmptyWidget();
            }
          }
          return ProgressIndicatorBuilder.getCenterCircularProgressIndicator();
        },
      ),
    );
  }

  Widget getEmptyWidget(){
    return new CustomScrollView(
      slivers: <Widget>[
        new SliverAppBar(
          backgroundColor: colorAppbar,
          title: new Text("Master Produk"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.add),
                color: colorButtonAdd,
                onPressed: () {
                  NavigationUtil.navigateToAnyWhere(
                    context, ProductSettings(null),);
                })
          ],
        ),
        const SliverFillRemaining(
          child: Center(child: Text("No Data Available"),),
        )
      ],
    );
  }
}
