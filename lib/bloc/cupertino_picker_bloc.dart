import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salbang/cupertino_data.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/brand.dart';
import 'package:salbang/model/product_size.dart';
import 'package:salbang/model/product_type.dart';
import 'package:salbang/model/response_database.dart';
import 'package:salbang/provider/bloc_provider.dart';
class CupertinoPickerBloc implements BlocBase{
  final _inputSelectBrand = StreamController<int>();
  final _inputSelectType  = StreamController<int>();
  final _inputSelectSize  = StreamController<int>();

  final _outputSelectBrand = PublishSubject<CupertinoData>();
  final _outputSelectType  = PublishSubject<CupertinoData>();
  final _outputSelectSize  = PublishSubject<CupertinoData>();
  final _outputGetBrands  = PublishSubject<ResponseDatabase<List<CupertinoData>>>();
  final _outputGetSizes  = PublishSubject<ResponseDatabase<List<CupertinoData>>>();
  final _outputGetTypes  = PublishSubject<ResponseDatabase<List<CupertinoData>>>();

  StreamSink<int> get inputSelectBrand => _inputSelectBrand.sink;
  StreamSink<int> get inputSelectType => _inputSelectType.sink;
  StreamSink<int> get inputSelectSize => _inputSelectSize.sink;

  Stream<CupertinoData>get outputSelectBrand => _outputSelectBrand.stream;
  Stream<CupertinoData>get outputSelectType => _outputSelectType.stream;
  Stream<CupertinoData>get outputSelectSize => _outputSelectSize.stream;

  Stream<ResponseDatabase<List<CupertinoData>>> get outputGetBrands => _outputGetBrands.stream;
  Stream<ResponseDatabase<List<CupertinoData>>> get outputGetSizes => _outputGetSizes.stream;
  Stream<ResponseDatabase<List<CupertinoData>>> get outputGetTypes => _outputGetTypes.stream;


  DBHelper _dbHelper;
  List<CupertinoData> dataBrandsCupertino, dataSizesCupertino, dataTypesCupertino;
  CupertinoPickerBloc(this._dbHelper){
    _inputSelectBrand.stream.listen(PickBrand);
    _inputSelectType.stream.listen(PickType);
      _inputSelectSize.stream.listen(PickSize);
  }
  @override
  void dispose() {
    _inputSelectBrand.close();
    _inputSelectType.close();
    _inputSelectSize.close();
    _outputSelectBrand.close();
    _outputSelectType.close();
    _outputSelectSize.close();
  }

  void GetBrandsStatusActive()async{
    final ResponseDatabase<List<Brand>> response = await _dbHelper.getBrands();
    dataBrandsCupertino = new List<CupertinoData>();
    for(int i = 0 ; i < response.data.length; i++)
    {
      CupertinoData cupertinoData = new CupertinoData(i,response.data[i].id, response.data[i].name);
      dataBrandsCupertino.add(cupertinoData);
    }
    ResponseDatabase<List<CupertinoData>> responseCupertinoData = new ResponseDatabase<List<CupertinoData>>();
    responseCupertinoData.data = dataBrandsCupertino;
    responseCupertinoData.result = response.result;
    responseCupertinoData.message = response.message;

    _outputGetBrands.add(responseCupertinoData);
  }

  void GetSizesStatusActive()async{
    final ResponseDatabase<List<ProductSize>> response = await _dbHelper.getProductSizes();
    dataSizesCupertino = new List<CupertinoData>();
    for(int i = 0 ; i < response.data.length; i++)
    {
      CupertinoData cupertinoData = new CupertinoData(i,response.data[i].id, response.data[i].name);
      dataSizesCupertino.add(cupertinoData);
    }
    ResponseDatabase<List<CupertinoData>> responseCupertinoData = new ResponseDatabase<List<CupertinoData>>();
    responseCupertinoData.data = dataSizesCupertino;
    responseCupertinoData.result = response.result;
    responseCupertinoData.message = response.message;

    _outputGetSizes.add(responseCupertinoData);
  }

  void GetTypesStatusActive()async{
    final ResponseDatabase<List<ProductType>> response = await _dbHelper.getProductTypes();
    dataTypesCupertino = new List<CupertinoData>();
    for(int i = 0 ; i < response.data.length; i++)
    {
      CupertinoData cupertinoData = new CupertinoData(i,response.data[i].id, response.data[i].name);
      dataTypesCupertino.add(cupertinoData);
    }
    ResponseDatabase<List<CupertinoData>> responseCupertinoData = new ResponseDatabase<List<CupertinoData>>();
    responseCupertinoData.data = dataTypesCupertino;
    responseCupertinoData.result = response.result;
    responseCupertinoData.message = response.message;

    _outputGetTypes.add(responseCupertinoData);
  }
  void PickBrand(int index){
    _outputSelectBrand.add(dataBrandsCupertino[index]);
  }

  void PickType(int index){
    _outputSelectType.add(dataTypesCupertino[index]);
  }

  void PickSize(int index){
    _outputSelectSize.add(dataSizesCupertino[index]);
  }
}