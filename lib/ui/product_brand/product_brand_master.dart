import 'package:flutter/material.dart';
import 'package:salbang/bloc/brand_bloc.dart';
import 'package:salbang/model/brand.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/string_constant.dart';
import 'package:salbang/ui/global_widget/progress_indicator_builder.dart';
import 'package:salbang/ui/product_brand/product_brand_settings.dart';

class ProductBrandMaster extends StatefulWidget {
  @override
  State createState() {
    return ProductBrandMasterState();
  }

}

class ProductBrandMasterState extends State<ProductBrandMaster>{

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  static const Color _kKeyUmbraOpacity = Color(0x33000000); // alpha = 0.2
  static const Color _kKeyPenumbraOpacity = Color(0x24000000); // alpha = 0.14
  static const Color _kAmbientShadowOpacity = Color(0x1F000000); // alpha = 0.12

  BrandBloc bloc;

//  void _onRefresh(bool event){
//    if(bloc != null){
//      bloc.getBrands();
//    }
//  }
//
//  void _onOffsetCallback(bool event, double offset){
//
//  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<BrandBloc>(context);
    bloc.getBrands();

    return new RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){return bloc.getBrands();},
        child: new StreamBuilder<ResponseDatabase<List<Brand>>>(
            stream: bloc.outputBrands,
            builder: (context, snapshot){
              if(snapshot.hasData){
                if(snapshot.data.result == ResponseDatabase.SUCCESS){
                  return new GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 3.0, crossAxisSpacing: 3.0),
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return new GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context){
                              return new ProductBrandSettings(brand: snapshot.data.data[index],);
                            },
                          ));
                        },
                        child: new Container(

                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(3.0)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(offset: Offset(0.0, 2.0), blurRadius: 1.0, spreadRadius: -1.0, color: _kKeyUmbraOpacity),
                                BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 1.0, spreadRadius: 0.0, color: _kKeyPenumbraOpacity),
                                BoxShadow(offset: Offset(0.0, 1.0), blurRadius: 3.0, spreadRadius: 0.0, color: _kAmbientShadowOpacity),
                              ]
                          ),
                          child: new Center(
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(snapshot.data.data[index].name),
                                Text(snapshot.data.data[index].description),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }else if(snapshot.data.result == ResponseDatabase.SUCCESS_EMPTY){
                  return Center(child: Text(StringConstant.MESSAGE_NO_DATA_AVAILABLE),);
                }else if(snapshot.data.result == ResponseDatabase.ERROR_SHOULD_RETRY){
                  return RaisedButton(
                    child: Text(StringConstant.MESSAGE_TAP_TO_RETRY),
                    onPressed: (){
                      bloc.getBrands();
                    },
                  );
                }
              }
              return ProgressIndicatorBuilder.getCenterCircularProgressIndicator();
            }
        ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
