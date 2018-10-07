import 'package:flutter/material.dart';
import 'package:salbang/bloc/brand_bloc.dart';
import 'package:salbang/bloc/product_bloc.dart';
import 'package:salbang/model/brand.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/resources/string_constant.dart';
import 'package:salbang/ui/product_brand/product_brand_settings.dart';

class ProductBrandMasterItem extends StatefulWidget {
  final Brand brand;
  ProductBrandMasterItem(this.brand);
  @override
  _ProductBrandMasterItemState createState() => _ProductBrandMasterItemState();
}

class _ProductBrandMasterItemState extends State<ProductBrandMasterItem> {
  BrandBloc brandBloc;
  ProductBloc productBloc;

  @override
  Widget build(BuildContext context) {
    brandBloc = BlocProvider.of<BrandBloc>(context);
    productBloc = BlocProvider.of<ProductBloc>(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        children: <Widget>[
          buildItem(),
          buildActionEdit(),
          buildActionDelete(context),
        ],
      ),

    );
  }

  Widget buildItem(){
    return new Expanded(
        child: new Text(
          widget.brand.name,
          softWrap: false,
          overflow: TextOverflow.fade,
          style: Theme.of(context).primaryTextTheme.display2,
        ),
    );
  }

  Widget buildActionEdit(){
    if(widget.brand.status == 1){
      return new IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          NavigationUtil.navigateToAnyWhere(
            context, ProductBrandSettings(brand: widget.brand,),
          );
        },
        color: colorEdit,
      );
    }else{
      return Container();
    }
  }

  Widget buildActionDelete(BuildContext context){
    if(widget.brand.status == 1){
      return new IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          showDeleteDialog(context);
        },
        color: colorDelete
      );
    }else{
      return new IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {showRestoreDialog(context);},
          color: colorDelete
      );
    }
  }

  void showRestoreDialog(BuildContext context){
    showDialog(context: context, builder: (_) => new AlertDialog(
      title : const Text("Restore Brand"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(StringConstant.getRestoreConfirmationMessageInMaster
            ("brand dengan nama ${widget.brand.name}", "dengan brand ${widget.brand.name}")
          ),
        ],
      ),
      actions: <Widget>[
        new Row(
          mainAxisAlignment : MainAxisAlignment.end,
          children: <Widget>[
            new FlatButton(onPressed: (){closeDialog(context);}, child: const Text(StringConstant.DELETE_CANCEL,style: TextStyle(color: colorDelete),)),
            new FlatButton(onPressed: (){restoreBrand(context);}, child: const Text(StringConstant.DELETE_OK,style: TextStyle(color: colorButtonAdd),)),
          ],
        )
      ],
    ));
  }

  void restoreBrand(BuildContext context){
    closeDialog(context);
    BlocProvider.of<BrandBloc>(context).restoreBrand(widget.brand);
  }

  void showDeleteDialog(BuildContext context){
    showDialog(context: context, builder: (_) => new AlertDialog(
        title : const Text("Delete Brand"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(StringConstant.getDeleteConfirmationMessageInMaster
              ("brand dengan nama ${widget.brand.name}", "dengan brand ${widget.brand.name}")
            ),
            Text('Produk terkait :'),
            new FutureBuilder<List<Product>>(
              future: BlocProvider.of<ProductBloc>(context).getProductByBrand(widget.brand.id),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  if(snapshot.data.isNotEmpty){
                    return ListView.builder(
                      itemBuilder: (context, index){
                        return Text(snapshot.data[index].name);
                      },
                    );
                  }else{
                    return Text('Tidak ada produk terkait');
                  }
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      actions: <Widget>[
        new Row(
          mainAxisAlignment : MainAxisAlignment.end,
          children: <Widget>[
            new FlatButton(onPressed: (){closeDialog(context);}, child: const Text(StringConstant.DELETE_CANCEL,style: TextStyle(color: colorDelete),)),
            new FlatButton(onPressed: (){deleteBrand(context);}, child: const Text(StringConstant.DELETE_OK,style: TextStyle(color: colorButtonAdd),)),
          ],
        )
      ],
    ));
  }

  void deleteBrand(BuildContext context){
    closeDialog(context);
    BlocProvider.of<BrandBloc>(context).deleteBrand(widget.brand.id);
  }

  void closeDialog(BuildContext context){
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }
  }
}
