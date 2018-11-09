import 'package:flutter/material.dart';
import 'package:salbang/bloc/brand_bloc.dart';
import 'package:salbang/bloc/product_bloc.dart';
import 'package:salbang/bloc/type_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/brand.dart';
import 'package:salbang/model/product_type.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/ui/global_widget/flutter_search_bar_base.dart';
import 'package:salbang/ui/global_widget/progress_indicator_builder.dart';
import 'package:salbang/ui/product/product_catalog.dart';

import 'package:salbang/ui/product/product_catalog_detail.dart';
import 'package:salbang/ui/product/product_catalog_list_items.dart';
import 'package:salbang/model/product.dart';

class ProductBrandCatalog extends StatefulWidget {
  @override
  _ProductBrandState createState() => _ProductBrandState();
}

class _ProductBrandState extends State<ProductBrandCatalog> {
  BrandBloc brandBloc;

  SearchBar searchBar;

  _ProductBrandState() {
    searchBar = new SearchBar(
      inBar: false,
      buildDefaultAppBar: renderAppBar,
      setState: setState,
      onSubmitted: onSearchBarSubmitted,
      onClosed: onSearchBarClosed,
      clearOnSubmit: false,
      colorBackButton: false,
      closeOnSubmit: false,
    );
  }

  Widget renderAppBar(BuildContext context) {
    return new AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: colorAppbar,
        title: const Text("Katalog Merk"),
        actions: [
          searchBar.getSearchAction(context),
        ]);
  }

  void onSearchBarSubmitted(String query) {
    brandBloc.getBrands(brandName: query);
  }

  void onSearchBarClosed() {
    brandBloc.getBrands();
  }

  @override
  Widget build(BuildContext context) {
    brandBloc = BlocProvider.of<BrandBloc>(context);
    brandBloc.getBrands();
    return new Scaffold(
      appBar: searchBar.build(context),
      body: new Container(
        child: new StreamBuilder<ResponseDatabase<List<Brand>>>(
          stream: brandBloc.outputBrands,
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
                                NavigationUtil.navigateToAnyWhere(
                                  context,
                                  new BlocProvider<ProductBloc>(
                                    bloc: ProductBloc(DBHelper()),
                                    child: ProductCatalog(brandId: snapshot.data.data[index].id,),
                                  ),
                                );
                              },
                              child: new Card(
                                child: new Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: new Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    children: <Widget>[
                                      new Text(
                                        snapshot.data.data[index].name,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: snapshot.data.data.length,
                        ),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.data.result ==
                  ResponseDatabase.SUCCESS_EMPTY) {
                return const Center(
                  child: Text('No Data Available'),
                );
              } else if (snapshot.data.result ==
                  ResponseDatabase.ERROR_SHOULD_RETRY) {
                return GestureDetector(
                  onTap: () {
                    brandBloc.getBrands();
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
            return ProgressIndicatorBuilder
                .getCenterCircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
