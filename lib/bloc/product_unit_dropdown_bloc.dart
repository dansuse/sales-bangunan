import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
import 'package:salbang/model/product_unit.dart';

class ProductUnitDropdownBloc extends BlocBase{

  final BehaviorSubject<DropdownProductUnit> _outputProductUnits = new BehaviorSubject<DropdownProductUnit>();
  Observable<DropdownProductUnit> get outputProductUnits => _outputProductUnits.stream;
  DBHelper dbHelper;
  DropdownProductUnit dropdownData;

  ProductUnitDropdownBloc(this.dbHelper){
    populateDropdown();
  }

  Future<void> populateDropdown()async{
    final ResponseDatabase<List<ProductUnit>> responseProductUnits = await dbHelper.getProductUnits();
    if(responseProductUnits.result == ResponseDatabase.SUCCESS){
      dropdownData = new DropdownProductUnit(responseProductUnits.data,
          selectedValue: responseProductUnits.data[0]);
      _outputProductUnits.add(dropdownData);
    }else{
      dropdownData = new DropdownProductUnit(<ProductUnit>[],);
      _outputProductUnits.add(dropdownData);
    }
  }

  void onDropdownChange(ProductUnit newValue){
    dropdownData.selectedValue = newValue;
    _outputProductUnits.add(dropdownData);
  }

  @override
  void dispose() {
    _outputProductUnits.close();
  }
}

class DropdownProductUnit{
  List<ProductUnit> items;
  ProductUnit selectedValue;
  DropdownProductUnit(this.items, {this.selectedValue});
}