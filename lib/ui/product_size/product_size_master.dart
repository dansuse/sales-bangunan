import 'package:flutter/material.dart';
import 'package:salbang/bloc/size_bloc.dart';
import 'package:salbang/model/product_size.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/global_widget/flutter_search_bar_base.dart';
import 'package:salbang/ui/product_size/product_size_master_list.dart';
import 'package:salbang/ui/product_size/product_size_settings.dart';

class ProductSizeMaster extends StatefulWidget {
  @override
  _ProductSizeMasterState createState() => _ProductSizeMasterState();
}

class _ProductSizeMasterState extends State<ProductSizeMaster> {
  SizeBloc _sizeBloc;
  SearchBar searchBar;
  @override
  void initState() {
    super.initState();
  }
  _ProductSizeMasterState(){
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
    _sizeBloc.getSizesData(sizeName: query);
  }

  void onSearchBarClosed() {
    _sizeBloc.getSizesData();
  }

  Widget renderAppBar(BuildContext context){
    return new AppBar(
        elevation: 0.0,
        backgroundColor: colorAppbar,
        title: const Text("Master Ukuran"),
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
          ),]
    );
  }

  @override
  Widget build(BuildContext context) {
    _sizeBloc = BlocProvider.of<SizeBloc>(context);
    _sizeBloc.getSizesData();
    return Scaffold(
      appBar: searchBar.build(context),
      body: new StreamBuilder<ResponseDatabase<List<ProductSize>>>(
        stream: _sizeBloc.outputListDataSizes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return new CustomScrollView(
              slivers: <Widget>[
//                buildSliverAppBar(),
                buildList(snapshot.data),
              ],
            );
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
      title: const Text("Master Ukuran"),
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

  Widget buildList(ResponseDatabase<List<ProductSize>> response){
    if(response.result == ResponseDatabase.SUCCESS){
      return new SliverList(
        delegate: new SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return new Container(
              child: new GestureDetector(
                onTap: () {},
                child:
                new ProductSizeMasterList(response.data[index]),
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


