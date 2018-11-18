import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/model/product_unit.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';

class UnitBloc implements BlocBase{
  final BehaviorSubject<bool> _outputUnitStatus = new BehaviorSubject<bool>(seedValue: true);
  Observable<bool> get outputUnitStatus => _outputUnitStatus.stream;

  final BehaviorSubject<ButtonState> _outputButtonState = new BehaviorSubject<ButtonState>(seedValue: ButtonState.IDLE);
  Observable<ButtonState> get outputButtonState => _outputButtonState.stream;

  final PublishSubject<String> _outputDbOperationResult = new PublishSubject<String>();
  Observable<String> get outputDbOperationResult => _outputDbOperationResult.stream;

  final PublishSubject<ResponseDatabase<List<ProductUnit>>> _outputProductUnits
    = new PublishSubject<ResponseDatabase<List<ProductUnit>>>();
  Observable<ResponseDatabase<List<ProductUnit>>> get outputProductUnits => _outputProductUnits.stream;

  DBHelper _dbHelper;
  bool entityStatus = true;

  UnitBloc(this._dbHelper);

  void updateStatus(bool status){
    entityStatus = status;
    _outputUnitStatus.add(entityStatus);
  }

  Future<void> getUnits({String query = ''}) async{
    final ResponseDatabase<List<ProductUnit>> responseProductUnits
      = await _dbHelper.getProductUnits(query: query);
    _outputProductUnits.add(responseProductUnits);
  }

  Future<void> getUnitsForCatalog({String query = ''}) async{
    final ResponseDatabase<List<ProductUnit>> responseProductUnits
    = await _dbHelper.getProductUnitsForCatalog(query: query);
    _outputProductUnits.add(responseProductUnits);
  }

  void insertUnit(String name, {String description = ''}) async{
    _outputButtonState.add(ButtonState.LOADING);
    final ProductUnit unit = new ProductUnit(
        name,
        description,
        status: entityStatus ? 1 : 0);
    final ResponseDatabase<ProductUnit> responseProductUnit
    = await _dbHelper.insertOrUpdateUnit(unit);
    _outputButtonState.add(ButtonState.IDLE);
    if(responseProductUnit.result == ResponseDatabase.SUCCESS){
      _outputDbOperationResult.add(responseProductUnit.data.name + ' dengan id "'
          + responseProductUnit.data.id.toString() + '" berhasil ditambahkan');
    }
  }

  void updateUnit(ProductUnit productUnit) async{
    _outputButtonState.add(ButtonState.LOADING);
    final ProductUnit unit = new ProductUnit(
        productUnit.name,
        productUnit.description,
        id: productUnit.id, 
        status: productUnit.status);
    final ResponseDatabase<ProductUnit> responseProductUnit 
      = await _dbHelper.insertOrUpdateUnit(unit);
    _outputButtonState.add(ButtonState.IDLE);
    if(responseProductUnit.result == ResponseDatabase.SUCCESS){
      _outputDbOperationResult.add(
          responseProductUnit.data.name + ' dengan id "' + 
              responseProductUnit.data.id.toString() + '" berhasil diubah');
    }
    
  }

  Future<ResponseDatabase> deleteUnit(int id)async{
    final ResponseDatabase responseDatabase = await _dbHelper.deleteUnit(id);
    if(responseDatabase.result == ResponseDatabase.SUCCESS){
      await getUnits();
    }
    return responseDatabase;
  }

  void restoreUnit(ProductUnit unit) async{
    unit.status = 1;
    final ResponseDatabase<ProductUnit> response
      = await _dbHelper.insertOrUpdateUnit(unit);
    if(response.result == ResponseDatabase.SUCCESS){
      await getUnits();
    }
  }

  @override
  void dispose() {
    _outputDbOperationResult.close();
    _outputButtonState.close();
    _outputUnitStatus.close();
    _outputProductUnits.close();
  }
}
