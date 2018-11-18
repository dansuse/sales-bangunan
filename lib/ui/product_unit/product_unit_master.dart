import 'package:flutter/material.dart';
import 'package:salbang/bloc/unit_bloc.dart';
import 'package:salbang/model/product_unit.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/resources/string_constant.dart';
import 'package:salbang/ui/global_widget/flutter_search_bar_base.dart';
import 'package:salbang/ui/product_unit/product_unit_list_item.dart';
import 'package:salbang/ui/product_unit/product_unit_settings.dart';

class ProductUnitMaster extends StatefulWidget {
  @override
  _ProductUnitMasterState createState() => _ProductUnitMasterState();
}

class _ProductUnitMasterState extends State<ProductUnitMaster> {
  UnitBloc unitBloc;
  SearchBar searchBar;

  _ProductUnitMasterState(){
    searchBar = new SearchBar(
      inBar: false,
      buildDefaultAppBar: renderAppBar,
      setState: setState,
      onSubmitted: onSearchBarSubmitted,
      onClosed: onSearchBarClosed,
      clearOnSubmit: false,
      colorBackButton : false,
      closeOnSubmit: false,
    );
  }

  Widget renderAppBar(BuildContext context){
    return new AppBar(
      elevation: 0.0,
      backgroundColor: colorAppbar,
      title: const Text("Master ${StringConstant.UNIT}"),
      actions: [
        searchBar.getSearchAction(context),
        new IconButton(
          icon: const Icon(Icons.add),
          color: colorButtonAdd,
          onPressed: () {
            NavigationUtil.navigateToAnyWhere(
              context,
              ProductSizeAddLayout(),
            );
          },
        ),
      ],
    );
  }

  void onSearchBarSubmitted(String query) {
    unitBloc.getUnits(query: query);
  }

  void onSearchBarClosed() {
    unitBloc.getUnits();
  }

  @override
  Widget build(BuildContext context) {
    unitBloc = BlocProvider.of<UnitBloc>(context);
    unitBloc.getUnits();
    return Scaffold(
      appBar: searchBar.build(context),
      body: new StreamBuilder<ResponseDatabase<List<ProductUnit>>>(
        stream: unitBloc.outputProductUnits,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data.result == ResponseDatabase.SUCCESS) {
            return new CustomScrollView(
              slivers: <Widget>[
                buildList(snapshot.data),
              ],
            );
          }
          return new CustomScrollView(
            slivers: <Widget>[
              buildSliverNoDataAvailable(),
            ],
          );
        },
      ),
    );
  }

  Widget buildSliverAppBar(){
    return new SliverAppBar(
      backgroundColor: colorAppbar,
      title: const Text(StringConstant.MASTER_UNIT),
      actions: <Widget>[
        new IconButton(
            icon: const Icon(Icons.add),
            color: colorButtonAdd,
            onPressed: () {
              NavigationUtil.navigateToAnyWhere(
                context, ProductSizeAddLayout(),
              );
            })
      ],
    );
  }

  Widget buildList(ResponseDatabase<List<ProductUnit>> response){
    return new SliverList(
      delegate: new SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return new Container(
            child: new GestureDetector(
              onTap: () {

              },
              child:
              new ProductUnitListItem(response.data[index]),
            ),
          );
        },
        childCount: response.data.length,
      ),
    );
  }

  Widget buildSliverNoDataAvailable(){
    return const SliverFillRemaining(
      child: Center(
        child: Text(StringConstant.NO_DATA_AVAILABLE),),
    );
  }

}


