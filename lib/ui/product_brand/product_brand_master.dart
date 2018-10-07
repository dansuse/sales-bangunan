import 'package:flutter/material.dart';
import 'package:salbang/bloc/brand_bloc.dart';
import 'package:salbang/model/brand.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/resources/string_constant.dart';
import 'package:salbang/ui/global_widget/progress_indicator_builder.dart';
import 'package:salbang/ui/product_brand/product_brand_master_item.dart';
import 'package:salbang/ui/product_brand/product_brand_settings.dart';

class ProductBrandMaster extends StatefulWidget {
  @override
  State createState() {
    return ProductBrandMasterState();
  }
}

class ProductBrandMasterState extends State<ProductBrandMaster>{

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();

  BrandBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<BrandBloc>(context);
    bloc.getBrands();

    return new Scaffold(
      body: new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){return bloc.getBrands();},
        child: new StreamBuilder<ResponseDatabase<List<Brand>>>(
            stream: bloc.outputBrands,
            builder: (context, snapshot){
              if(snapshot.hasData){
                if(snapshot.data.result == ResponseDatabase.SUCCESS ||
                    snapshot.data.result == ResponseDatabase.SUCCESS_EMPTY){
                  return new CustomScrollView(
                    slivers: <Widget>[
                      new SliverAppBar(
                        backgroundColor: colorAppbar,
                        title: const Text("Master Merk (Brand)"),
                        actions: <Widget>[
                          new IconButton(
                              icon: const Icon(Icons.add),
                              color: colorButtonAdd,
                              onPressed: () {
                                NavigationUtil.navigateToAnyWhere(
                                  context, ProductBrandSettings(),
                                );
                              })
                        ],
                      ),
                      buildList(snapshot.data.result, snapshot.data.data),
                    ],
                  );
                }else if(snapshot.data.result == ResponseDatabase.ERROR_SHOULD_RETRY){
                  return RaisedButton(
                    child: const Text(StringConstant.MESSAGE_TAP_TO_RETRY),
                    onPressed: (){
                      bloc.getBrands();
                    },
                  );
                }
              }
              return ProgressIndicatorBuilder.getCenterCircularProgressIndicator();
            }
        ),
      ),
    );
  }

  Widget buildList(int databaseResult, List<Brand> brands){
    if(databaseResult == ResponseDatabase.SUCCESS){
      return new SliverList(
        delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return new Container(
              child: new GestureDetector(
                onTap: () {},
                child:
                new ProductBrandMasterItem(brands[index]),
              ),
            );
          },
          childCount: brands.length,
        ),
      );
    }else{
      return const SliverFillRemaining(
        child: Center(child: Text(StringConstant.MESSAGE_NO_DATA_AVAILABLE),),
      );
    }
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
