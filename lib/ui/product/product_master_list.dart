import 'package:flutter/material.dart';
import 'package:salbang/bloc/product_bloc.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/resources/colors.dart';
import 'package:salbang/resources/navigation_util.dart';
import 'package:salbang/resources/string_constant.dart';
import 'package:salbang/ui/product/product_settings.dart';

class ProductMasterList extends StatefulWidget {
  final Product product;
  ProductMasterList(this.product);
  @override
  _ProductMasterListState createState() => _ProductMasterListState();
}

class _ProductMasterListState extends State<ProductMasterList> {
  ProductBloc productBloc;

  @override
  Widget build(BuildContext context) {
    productBloc = BlocProvider.of<ProductBloc>(context);
    return Container(
      padding: EdgeInsets.all(8.0),
        child:  new Row(
          children: <Widget>[
            new Expanded(
                child: new Text(
                  widget.product.name,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: Theme.of(context).primaryTextTheme.display2,
                )),
            new IconButton(
              icon: new Icon(Icons.edit),
              onPressed: () {
                NavigationUtil.navigateToAnyWhere(
                  context,  ProductSettings(widget.product),);
              },
              color: colorEdit,
            ),
            new IconButton(
                icon: new Icon(Icons.delete),
                onPressed: () {
                  showDeleteDialog(context);
                },
                color: colorDelete),
          ],
        ),

    );
  }

  void showDeleteDialog(BuildContext context){
    showDialog(context: context, builder: (_) => new AlertDialog(
      title : const Text("Delete Product"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(StringConstant.getDeleteConfirmationMessageInMaster
            ("product dengan nama ${widget.product.name}", "dengan product ${widget.product.name}")
          ),
          Text('Produk terkait :'),
          new FutureBuilder<List<Product>>(
            future: BlocProvider.of<ProductBloc>(context).getProductByBrand(widget.product.id),
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
            new FlatButton(onPressed: (){deleteProduct(context);}, child: const Text(StringConstant.DELETE_OK,style: TextStyle(color: colorButtonAdd),)),
          ],
        )
      ],
    ));
  }

  void deleteProduct(BuildContext context){
    closeDialog(context);
    BlocProvider.of<ProductBloc>(context).deleteProduct(widget.product.id);
  }

  void closeDialog(BuildContext context){
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }
  }
}
