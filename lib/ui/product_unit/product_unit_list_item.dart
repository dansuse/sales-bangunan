import 'package:flutter/material.dart';
import 'package:salbang/bloc/product_bloc.dart';
import 'package:salbang/bloc/unit_bloc.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/model/product_unit.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/resources/string_constant.dart';
import 'package:salbang/ui/product_unit/product_unit_update_layout.dart';

class ProductUnitListItem extends StatefulWidget {
  final ProductUnit productUnit;
  ProductUnitListItem(this.productUnit);
  @override
  _ProductUnitListItemState createState() => _ProductUnitListItemState();
}

class _ProductUnitListItemState extends State<ProductUnitListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child:  new Row(
        children: <Widget>[
          new Expanded(
              child: new Text(
                widget.productUnit.name,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: Theme.of(context).primaryTextTheme.display2,
              )),
          widget.productUnit.status == 1 ? new IconButton(
            icon: new Icon(Icons.edit),
            onPressed: () {
              NavigationUtil.navigateToAnyWhere(
                context, ProductUnitUpdateLayout(productUnit: widget.productUnit,),);
            },
            color: colorEdit,
          ) : new Container(),
          widget.productUnit.status == 1 ?
          new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () {
                showDeleteDialog(context);
              },
              color: colorDelete)
          :new IconButton(
              icon: new Icon(Icons.check),
              onPressed: () {showRestoreDialog(context);},
              color: colorDelete),
        ],
      ),

    );
  }

  void showRestoreDialog(BuildContext context){
    showDialog(context: context, builder: (_) => new AlertDialog(
      title : const Text("${StringConstant.RESTORE} ${StringConstant.UNIT}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(StringConstant.getRestoreConfirmationMessageInMaster
            ("${StringConstant.UNIT} dengan nama ${widget.productUnit.name}", "dengan ${StringConstant.UNIT} ${widget.productUnit.name}")
          ),
        ],
      ),
      actions: <Widget>[
        new Row(
          mainAxisAlignment : MainAxisAlignment.end,
          children: <Widget>[
            new FlatButton(
                onPressed: (){closeDialog(context);},
                child: const Text(StringConstant.DELETE_CANCEL,
                  style: TextStyle(color: colorDelete),
                )
            ),
            new FlatButton(
                onPressed: (){restoreSize(context);},
                child: const Text(StringConstant.DELETE_OK,
                  style: TextStyle(color: colorButtonAdd),
                ),
            ),
          ],
        )
      ],
    ));
  }

  void restoreSize(BuildContext context){
    closeDialog(context);
    BlocProvider.of<UnitBloc>(context).restoreUnit(widget.productUnit);
  }

  void showDeleteDialog(BuildContext context){
    showDialog(context: context, builder: (_) => new AlertDialog(
      title : const Text("Delete ${StringConstant.UNIT}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(StringConstant.getDeleteConfirmationMessageInMaster
            ("${StringConstant.UNIT} dengan nama ${widget.productUnit.name}", "dengan ${StringConstant.UNIT} ${widget.productUnit.name}")
          ),
          Text(StringConstant.RELATED_PRODUCT),
          new FutureBuilder<List<Product>>(
            future: BlocProvider.of<ProductBloc>(context).getProductBySize(widget.productUnit.id),
            builder: (context, snapshot){
              if(snapshot.hasData){
                if(snapshot.data.isNotEmpty){
                  return ListView.builder(
                    itemBuilder: (context, index){
                      return Text(snapshot.data[index].name);
                    },
                  );
                }else{
                  return Text(StringConstant.NO_RELATED_PRODUCT);
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
            new FlatButton(
                onPressed: (){closeDialog(context);},
                child: const Text(StringConstant.DELETE_CANCEL,
                  style: TextStyle(color: colorDelete),)),
            new FlatButton(
                onPressed: (){deleteSize(context);},
                child: const Text(StringConstant.DELETE_OK,
                  style: TextStyle(color: colorButtonAdd),)),
          ],
        )
      ],
    ));
  }

  void deleteSize(BuildContext context){
    closeDialog(context);
    BlocProvider.of<UnitBloc>(context).deleteUnit(widget.productUnit.id);
  }

  void closeDialog(BuildContext context){
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }
  }
}
