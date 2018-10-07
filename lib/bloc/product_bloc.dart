import 'dart:async';

import 'package:salbang/database/database.dart';
import 'package:salbang/database/table_schema/product.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/provider/bloc_provider.dart';

class ProductBloc extends BlocBase{
  DBHelper dbHelper;
  ProductBloc(this.dbHelper);

  Future<List<Product>> getProductByBrand(int id)async{
    return await dbHelper.getProductsBy(id, ProductTable.COLUMN_FK_BRAND);
  }

  Future<List<Product>> getProductBySize(int id)async{
    return await dbHelper.getProductsBy(id, ProductTable.COLUMN_FK_SIZE);
  }

  Future<List<Product>> getProductByType(int id)async{
    return await dbHelper.getProductsBy(id, ProductTable.COLUMN_FK_TYPE);
  }

  Future<List<Product>> getProductByUnit(int id)async{
    return await dbHelper.getProductsBy(id, ProductTable.COLUMN_FK_UNIT);
  }

  Future<List<Product>> getProductBy(int id, String foreignKeyColumnName)async{
    return await dbHelper.getProductsBy(id, foreignKeyColumnName);
  }

  @override
  void dispose() {

  }


}