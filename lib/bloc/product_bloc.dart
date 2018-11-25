import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/database/table_schema/product.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/model/product.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';

class ProductBloc extends BlocBase{
  DBHelper dbHelper;
  ProductBloc(this.dbHelper);

  final PublishSubject<ResponseDatabase<List<Product>>> _outputCatalogProducts = new PublishSubject<ResponseDatabase<List<Product>>>();
  Observable<ResponseDatabase<List<Product>>> get outputCatalogProducts => _outputCatalogProducts.stream;

  final _outputMasterProducts = new BehaviorSubject<ResponseDatabase<List<Product>>>();
  Observable<ResponseDatabase<List<Product>>> get outputMasterProducts => _outputMasterProducts.stream;

  final BehaviorSubject<bool> _outputEntityStatus = new BehaviorSubject<bool>();
  Observable<bool> get outputEntityStatus => _outputEntityStatus.stream;

  final BehaviorSubject<ButtonState> _outputButtonState = new BehaviorSubject<ButtonState>(seedValue: ButtonState.IDLE);
  Observable<ButtonState> get outputButtonState => _outputButtonState.stream;

  final PublishSubject<ResponseDatabase<Product>> _outputOperationResult = new PublishSubject();
  Observable<ResponseDatabase<Product>> get outputOperationResult => _outputOperationResult.stream;

  bool productStatus = true;
  void updateStatus(bool status){
    productStatus = status;
    _outputEntityStatus.add(productStatus);
  }

  Future<List<Product>> getProductByBrand(int id)async{
    return await dbHelper.getProductsBy(id, ProductTable.COLUMN_FK_BRAND);
  }

//  Future<List<Product>> getProductBySize(int id)async{
//    return await dbHelper.getProductsBy(id, ProductTable.COLUMN_FK_SIZE);
//  }

  Future<List<Product>> getProductByType(int id)async{
    return await dbHelper.getProductsBy(id, ProductTable.COLUMN_FK_TYPE);
  }

  Future<List<Product>> getProductByUnit(int id)async{
    return Future.value(<Product>[]);
  }

  Future<List<Product>> getProductBy(int id, String foreignKeyColumnName)async{
    return await dbHelper.getProductsBy(id, foreignKeyColumnName);
  }

  //mendapatkan semua produk yang statusnya 1
  Future<void> getProductsForCatalog({
    String productName = "",
    int typeId = DBHelper.PARAM_NOT_SET,
    int brandId = DBHelper.PARAM_NOT_SET,
    int unitId = DBHelper.PARAM_NOT_SET,
  })async{
    final ResponseDatabase<List<Product>> response
      = await dbHelper.getProductsForCatalog(
          productName: productName,
          typeId: typeId,
          brandId: brandId);
    _outputCatalogProducts.add(response);
  }

  Future<void> getProductsForMaster()async{
    final ResponseDatabase<List<Product>> response
    = await dbHelper.getProductsForMaster();
    _outputMasterProducts.add(response);
  }

  Future<void> insertOrUpdateProduct(int id, String name, double price,
      int stock, String description, int size,
      int fkBrand, int fkUnit, int fkType)async{
    _outputButtonState.add(ButtonState.LOADING);
    print("Brand:" + fkBrand.toString() + "||Unit:" + fkUnit.toString() + "||Type:" + fkType.toString());
    final Product product = Product(
      id,
      name,
      stock,
      description,
      productStatus ? 1 : 0,
      fkBrand,
      fkType,
    );
    final ResponseDatabase<Product> response = await dbHelper.insertOrUpdateProduct(product);
    _outputOperationResult.add(response);
    _outputButtonState.add(ButtonState.IDLE);
    await getProductsForMaster();
  }

  Future<ResponseDatabase> deleteProduct(int id)async{
    final ResponseDatabase responseDatabase = await dbHelper.deleteProduct(id);
    if(responseDatabase.result == ResponseDatabase.SUCCESS){
      await getProductsForMaster();
    }
    return responseDatabase;
  }

  @override
  void dispose() {
    _outputCatalogProducts.close();
  }


}