import 'package:flutter/material.dart';
import 'package:salbang/bloc/product_bloc.dart';
import 'package:salbang/bloc/size_bloc.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/model/product_size.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/resources/string_constant.dart';
import 'package:salbang/ui/product_size/product_size_update_layout.dart';

class ProductSizeMasterList extends StatefulWidget {
  final ProductSize productSize;
  ProductSizeMasterList(this.productSize);
  @override
  _ProductSizeMasterListState createState() => _ProductSizeMasterListState();
}

class _ProductSizeMasterListState extends State<ProductSizeMasterList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child:  new Row(
        children: <Widget>[
          new Expanded(
              child: new Text(
                widget.productSize.name,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: Theme.of(context).primaryTextTheme.display2,
              )),
          widget.productSize.status == 1 ? new IconButton(
            icon: new Icon(Icons.edit),
            onPressed: () {
              NavigationUtil.navigateToAnyWhere(
                context, ProductSizeUpdateLayout(productSize: widget.productSize,),);
            },
            color: colorEdit,
          ) : new Container(),
          widget.productSize.status == 1 ?
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
      title : const Text("Restore Size"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(StringConstant.getRestoreConfirmationMessageInMaster
            ("size dengan nama ${widget.productSize.name}", "dengan size ${widget.productSize.name}")
          ),
        ],
      ),
      actions: <Widget>[
        new Row(
          mainAxisAlignment : MainAxisAlignment.end,
          children: <Widget>[
            new FlatButton(onPressed: (){closeDialog(context);}, child: const Text(StringConstant.DELETE_CANCEL,style: TextStyle(color: colorDelete),)),
            new FlatButton(onPressed: (){restoreSize(context);}, child: const Text(StringConstant.DELETE_OK,style: TextStyle(color: colorButtonAdd),)),
          ],
        )
      ],
    ));
  }

  void restoreSize(BuildContext context){
    closeDialog(context);
    BlocProvider.of<SizeBloc>(context).restoreSize(widget.productSize);
  }

  void showDeleteDialog(BuildContext context){
    showDialog(context: context, builder: (_) => new AlertDialog(
      title : const Text("Delete Size"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(StringConstant.getDeleteConfirmationMessageInMaster
            ("size dengan nama ${widget.productSize.name}", "dengan size ${widget.productSize.name}")
          ),
          Text('Produk terkait :'),
          new FutureBuilder<List<Product>>(
            future: BlocProvider.of<ProductBloc>(context).getProductBySize(widget.productSize.id),
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
            new FlatButton(onPressed: (){deleteSize(context);}, child: const Text(StringConstant.DELETE_OK,style: TextStyle(color: colorButtonAdd),)),
          ],
        )
      ],
    ));
  }

  void deleteSize(BuildContext context){
    closeDialog(context);
    BlocProvider.of<SizeBloc>(context).deleteSize(widget.productSize.id);
  }

  void closeDialog(BuildContext context){
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }
  }
}
