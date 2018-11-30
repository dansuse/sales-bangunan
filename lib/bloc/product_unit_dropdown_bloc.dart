import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/model/product_unit.dart';

class ProductUnitDropdownBloc extends BlocBase{

  final BehaviorSubject<List<ProductUnit>> _outputProductUnits = new BehaviorSubject<List<ProductUnit>>();
  Observable<List<ProductUnit>> get outputProductUnits => _outputProductUnits.stream;
  DBHelper dbHelper;
  ProductUnit selectedProductUnit;

  ProductUnitDropdownBloc(this.dbHelper){
    populateDropdown();
  }

  Future<void> populateDropdown()async{
    final ResponseDatabase<List<ProductUnit>> responseProductUnits = await dbHelper.getProductUnits();
    if(responseProductUnits.result == ResponseDatabase.SUCCESS){
      _outputProductUnits.add(responseProductUnits.data);
    }else{
      _outputProductUnits.add(<ProductUnit>[]);
    }
  }

  @override
  void dispose() {
    _outputProductUnits.close();
  }
}