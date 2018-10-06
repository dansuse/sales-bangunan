import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/brand.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';

class BrandBloc extends BlocBase{
  final BehaviorSubject<bool> _outputBrandStatus = new BehaviorSubject<bool>();
  Observable<bool> get outputBrandStatus => _outputBrandStatus.stream;

  final BehaviorSubject<ButtonState> _outputButtonInsertBrandState = new BehaviorSubject<ButtonState>(seedValue: ButtonState.IDLE);
  Observable<ButtonState> get outputButtonInsertBrandState => _outputButtonInsertBrandState.stream;

  final PublishSubject<ResponseDatabase<Brand>> _outputOperationResult = new PublishSubject<ResponseDatabase<Brand>>();
  Observable<ResponseDatabase<Brand>> get outputOperationResult => _outputOperationResult.stream;

  final BehaviorSubject<ResponseDatabase<List<Brand>>> _outputBrands = new BehaviorSubject<ResponseDatabase<List<Brand>>>();
  Observable<ResponseDatabase<List<Brand>>> get outputBrands => _outputBrands.stream;

  DBHelper _dbHelper;
  bool brandStatus = true;

  BrandBloc(this._dbHelper){}

  void dispose(){
    _outputOperationResult.close();
    _outputButtonInsertBrandState.close();
    _outputBrandStatus.close();

  }

  void updateStatus(bool status){
    brandStatus = status;
    _outputBrandStatus.add(brandStatus);
  }

  void insertOrUpdateBrand(String brandName, String brandDescription, int id) async{
    _outputButtonInsertBrandState.add(ButtonState.LOADING);
    final Brand brand = new Brand(brandName, brandDescription, id: id, status: brandStatus ? 1 : 0);
    final ResponseDatabase<Brand> responseBrand = await _dbHelper.insertOrUpdateBrand(brand);
    _outputButtonInsertBrandState.add(ButtonState.IDLE);
    _outputOperationResult.add(responseBrand);
  }

  Future<void> getBrands()async{
    final ResponseDatabase<List<Brand>> responseBrands = await _dbHelper.getBrands();
    _outputBrands.add(responseBrands);
    return;
  }
}