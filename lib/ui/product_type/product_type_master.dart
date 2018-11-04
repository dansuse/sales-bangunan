import 'package:flutter/material.dart';
import 'package:salbang/bloc/type_bloc.dart';
import 'package:salbang/model/product_type.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/global_widget/flutter_search_bar_base.dart';
import 'package:salbang/ui/product_type/product_type_add_layout.dart';
import 'package:salbang/ui/product_type/product_type_master_list.dart';

class ProductTypeMaster extends StatefulWidget {
  @override
  _ProductTypeMasterState createState() => _ProductTypeMasterState();
}

class _ProductTypeMasterState extends State<ProductTypeMaster> {
  TypeBloc _typeBloc;
  SearchBar searchBar;

  _ProductTypeMasterState(){
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


  void onSearchBarSubmitted(String query) {
    _typeBloc.getTypesData(typeName: query);
  }

  void onSearchBarClosed() {
    _typeBloc.getTypesData();
  }

  @override
  void initState() {
    super.initState();

  }

  Widget renderAppBar(BuildContext context){
    return new AppBar(
      elevation: 0.0,
      backgroundColor: colorAppbar,
      title: const Text("Master Tipe"),
      actions: [
        searchBar.getSearchAction(context),
      new IconButton(
        icon: const Icon(Icons.add),
        color: colorButtonAdd,
        onPressed: () {
          NavigationUtil.navigateToAnyWhere(
            context,
            ProductTypeAddLayout(),
          );
        },
      ),]
    );
  }

  @override
  Widget build(BuildContext context) {
    _typeBloc = BlocProvider.of<TypeBloc>(context);
    _typeBloc.getTypesData();
    return Scaffold(
      appBar: searchBar.build(context),
      body: new StreamBuilder<ResponseDatabase<List<ProductType>>>(
        stream: _typeBloc.outputListDataTypes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if(snapshot.data.result == ResponseDatabase.LOADING){
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colorAccent),
                ),
              );
            }else{
              return new CustomScrollView(
                slivers: <Widget>[
//                  buildSliverAppBar(),
                  buildList(snapshot.data),
                ],
              );
            }
          }
          return new CustomScrollView(
            slivers: <Widget>[
//              buildSliverAppBar(),
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
      title: const Text("Master Tipe"),
      actions: <Widget>[
        new IconButton(
            icon: const Icon(Icons.add),
            color: colorButtonAdd,
            onPressed: () {
              NavigationUtil.navigateToAnyWhere(
                context,
                ProductTypeAddLayout(),
              );
            },
        )
      ],
    );
  }

  Widget buildList(ResponseDatabase<List<ProductType>> response){
    if(response.result == ResponseDatabase.SUCCESS){
      return new SliverList(
        delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return new Container(
              child: new GestureDetector(
                onTap: () {},
                child: new ProductTypeMasterList(
                    response.data[index]),
              ),
            );
          },
          childCount: response.data.length,
        ),
      );
    }else{
      return buildSliverNoDataAvailable();
    }
  }

  Widget buildSliverNoDataAvailable(){
    return const SliverFillRemaining(
      child: Center(
        child: Text("Tidak Ada Data"),),
    );
  }
}
