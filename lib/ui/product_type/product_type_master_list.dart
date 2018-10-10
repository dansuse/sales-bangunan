import 'package:flutter/material.dart';
import 'package:salbang/bloc/product_bloc.dart';
import 'package:salbang/bloc/type_bloc.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/model/product_type.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/resources/string_constant.dart';
import 'package:salbang/ui/product_type/product_type_update_layout.dart';

class ProductTypeMasterList extends StatefulWidget {
  final ProductType productType;
  ProductTypeMasterList(this.productType);
  @override
  _ProductTypeMasterListState createState() => _ProductTypeMasterListState();
}

class _ProductTypeMasterListState extends State<ProductTypeMasterList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new Text(
            widget.productType.name,
            softWrap: false,
            overflow: TextOverflow.fade,
            style: Theme.of(context).primaryTextTheme.display2,
          )),
          widget.productType.status == 1
              ? new IconButton(
                  icon: new Icon(Icons.edit),
                  onPressed: () {
//              final DataProductType _dataProductType = new DataProductType(addMode: false, productType: widget.productType);
                    NavigationUtil.navigateToAnyWhere(
                      context,
                      ProductTypeUpdateLayout(
                        productType: widget.productType,
                      ),
                    );
                  },
                  color: colorEdit,
                )
              : new Container(),
          widget.productType.status == 1
              ? new IconButton(
                  icon: new Icon(Icons.delete),
                  onPressed: () {
                    showDeleteDialog(context);
                  },
                  color: colorDelete)
              : new IconButton(
                  icon: new Icon(Icons.check),
                  onPressed: () {showRestoreDialog(context);},
                  color: colorDelete),
        ],
      ),
    );
  }

  void showRestoreDialog(BuildContext context){
    showDialog(context: context, builder: (_) => new AlertDialog(
      title : const Text("Restore Type"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(StringConstant.getRestoreConfirmationMessageInMaster
            ("type dengan nama ${widget.productType.name}", "dengan type ${widget.productType.name}")
          ),
        ],
      ),
      actions: <Widget>[
        new Row(
          mainAxisAlignment : MainAxisAlignment.end,
          children: <Widget>[
            new FlatButton(onPressed: (){closeDialog(context);}, child: const Text(StringConstant.DELETE_CANCEL,style: TextStyle(color: colorDelete),)),
            new FlatButton(onPressed: (){restoreType(context);}, child: const Text(StringConstant.DELETE_OK,style: TextStyle(color: colorButtonAdd),)),
          ],
        )
      ],
    ));
  }

  void restoreType(BuildContext context){
    closeDialog(context);
    BlocProvider.of<TypeBloc>(context).restoreType(widget.productType);
  }

  void showDeleteDialog(BuildContext context){
    showDialog(context: context, builder: (_) => new AlertDialog(
      title : const Text("Delete Brand"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(StringConstant.getDeleteConfirmationMessageInMaster
            ("type dengan nama ${widget.productType.name}", "dengan type ${widget.productType.name}")
          ),
          Text('Produk terkait :'),
          new FutureBuilder<List<Product>>(
            future: BlocProvider.of<ProductBloc>(context).getProductByType(widget.productType.id),
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
            new FlatButton(onPressed: (){deleteType(context);}, child: const Text(StringConstant.DELETE_OK,style: TextStyle(color: colorButtonAdd),)),
          ],
        )
      ],
    ));
  }

  void deleteType(BuildContext context){
    closeDialog(context);
    BlocProvider.of<TypeBloc>(context).deleteType(widget.productType.id);
  }

  void closeDialog(BuildContext context){
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }
  }
}
