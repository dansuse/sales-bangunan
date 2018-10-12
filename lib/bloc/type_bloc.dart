import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/model/product_type.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';

class TypeBloc implements BlocBase{
  final _inputTypeStatus = StreamController<bool>();
  final _inputInsertType = StreamController<String>();
  final _inputUpdateType  = StreamController<ProductType>();

  StreamSink<bool> get inputTypeStatus => _inputTypeStatus.sink;
  StreamSink<String> get inputInsertType => _inputInsertType.sink;
  StreamSink<ProductType> get inputUpdateType => _inputUpdateType.sink;

  final BehaviorSubject<bool> _outputTypeStatus = new BehaviorSubject<bool>(seedValue: true);
  Observable<bool> get outputTypeStatus => _outputTypeStatus.stream;

  final BehaviorSubject<ButtonState> _outputButtonInsertTypeState = new BehaviorSubject<ButtonState>(seedValue: ButtonState.IDLE);
  Observable<ButtonState> get outputButtonInsertTypeState => _outputButtonInsertTypeState.stream;

  final PublishSubject<String> _outputOperationResult = new PublishSubject<String>();
  Observable<String> get outputOperationResult => _outputOperationResult.stream;

  final PublishSubject<ResponseDatabase<List<ProductType>>> _outputListDataTypes = new PublishSubject<ResponseDatabase<List<ProductType>>>();
  Observable<ResponseDatabase<List<ProductType>>> get outputListDataTypes => _outputListDataTypes.stream;

  DBHelper _dbHelper;
  bool typeStatus = true;

  TypeBloc(this._dbHelper){
    _inputTypeStatus.stream.listen(updateStatus);
    _inputInsertType.stream.listen(insertType);
    _inputUpdateType.stream.listen(updateType);
  }

  void updateStatus(bool status){
    typeStatus = status;
    _outputTypeStatus.add(typeStatus);
  }

  Future<void> getTypesData({String typeName = ''}) async{
    _outputListDataTypes.add( ResponseDatabase(result: ResponseDatabase.LOADING, data: null ,message: 'Loading'));
    final ResponseDatabase<List<ProductType>> listDataTypes = await _dbHelper.getProductTypes(typename: typeName);
    _outputListDataTypes.add(listDataTypes);
  }

  void insertType(String typeName) async{
    print(typeName);
    _outputButtonInsertTypeState.add(ButtonState.LOADING);
    final ProductType type = new ProductType(name : typeName, status: typeStatus ? 1 : 0);
    final  ResponseDatabase<ProductType> insertedProductType = await _dbHelper.insertOrUpdateType(type);
    _outputButtonInsertTypeState.add(ButtonState.IDLE);
    _outputOperationResult.add(insertedProductType.data.name + ' dengan id "' + insertedProductType.data.id.toString() + '" berhasil ditambahkan');
  }

  void updateType(ProductType productType) async{
    _outputButtonInsertTypeState.add(ButtonState.LOADING);
    final ProductType type = new ProductType(name : productType.name, id: productType.id, status: productType.status);
    final  ResponseDatabase<ProductType> insertedProductType = await _dbHelper.insertOrUpdateType(type);
    _outputButtonInsertTypeState.add(ButtonState.IDLE);
    _outputOperationResult.add(insertedProductType.data.name + ' dengan id "' + insertedProductType.data.id.toString() + '" berhasil diubah');
  }

  Future<ResponseDatabase> deleteType(int id)async{
    final ResponseDatabase responseDatabase = await _dbHelper.deleteType(id);
    if(responseDatabase.result == ResponseDatabase.SUCCESS){
      await getTypesData();
    }
    return responseDatabase;
  }

  void restoreType(ProductType type) async{
    type.status = 1;
    final ResponseDatabase<ProductType> response
      = await _dbHelper.insertOrUpdateType(type);
    if(response.result == ResponseDatabase.SUCCESS){
      await getTypesData();
    }
  }

  @override
  void dispose() {
    _outputOperationResult.close();
    _outputButtonInsertTypeState.close();
    _outputTypeStatus.close();

  }
}
