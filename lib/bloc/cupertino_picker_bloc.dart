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

  final _outputSelectBrand = BehaviorSubject<CupertinoData>();
  final _outputSelectType  = BehaviorSubject<CupertinoData>();
  final _outputSelectSize  = BehaviorSubject<CupertinoData>();
  final _outputGetBrands  = BehaviorSubject<ResponseDatabase<List<CupertinoData>>>();
  final _outputGetSizes  = BehaviorSubject<ResponseDatabase<List<CupertinoData>>>();
  final _outputGetTypes  = BehaviorSubject<ResponseDatabase<List<CupertinoData>>>();

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
  CupertinoData selectedBrand;
  CupertinoData selectedSize;
  CupertinoData selectedType;
//  int initialBrandId;
//  int initialTypeId;
//  int initialSizeId;

  CupertinoPickerBloc(this._dbHelper,
//  {this.initialBrandId, this.initialTypeId, this.initialSizeId}
  ){
    _inputSelectBrand.stream.listen(PickBrand);
    _inputSelectType.stream.listen(PickType);
    _inputSelectSize.stream.listen(PickSize);
  }
  @override
  void dispose() {
//    _inputSelectBrand.close();
//    _inputSelectType.close();
//    _inputSelectSize.close();
//    _outputSelectBrand.close();
//    _outputSelectType.close();
//    _outputSelectSize.close();
  }

  Future<void> initializeBrand(int brandId)async{
    await getBrandsStatusActive();
    for(CupertinoData data in dataBrandsCupertino){
      if(data.idInformation == brandId){
        selectedBrand = data;
        break;
      }
    }
    _outputSelectBrand.add(selectedBrand);
  }

  Future<void> initializeType(int typeId)async{
    await getTypesStatusActive();
    for(CupertinoData data in dataTypesCupertino){
      if(data.idInformation == typeId){
        selectedType = data;
        break;
      }
    }
    _outputSelectType.add(selectedType);
  }

  Future<void> initializeSize(int sizeId)async{
    await getSizesStatusActive();
    for(CupertinoData data in dataSizesCupertino){
      if(data.idInformation == sizeId){
        selectedSize = data;
        break;
      }
    }
    _outputSelectSize.add(selectedSize);
  }

  Future<void> getBrandsStatusActive()async{
    print("terpanggil getBrandsStatusActive(), dgn kondisi selectedbrand:" + (selectedBrand == null).toString());
    final ResponseDatabase<List<Brand>> responseBrands = await _dbHelper.getBrands();

    dataBrandsCupertino = <CupertinoData>[];
    if(responseBrands.result == ResponseDatabase.SUCCESS){
      for(int i = 0 ; i < responseBrands.data.length; i++) {
        dataBrandsCupertino.add(CupertinoData
          (i, responseBrands.data[i].id, responseBrands.data[i].name));
      }
    }
    final ResponseDatabase<List<CupertinoData>> result = ResponseDatabase
        .fromAnotherResponse(responseBrands);
    result.data = dataBrandsCupertino;
    _outputGetBrands.add(result);

    if(selectedBrand == null){
      if(dataBrandsCupertino.isNotEmpty){
        selectedBrand = dataBrandsCupertino[0];
      }else{
        selectedBrand = CupertinoData.empty();
      }
      _outputSelectBrand.add(selectedBrand);
    }
  }

  Future<void> getSizesStatusActive()async{
    final ResponseDatabase<List<ProductSize>> response = await _dbHelper.getProductSizes();
    dataSizesCupertino = <CupertinoData>[];
    if(response.result == ResponseDatabase.SUCCESS){
      for(int i = 0 ; i < response.data.length; i++)
      {
        dataSizesCupertino.add(CupertinoData(i, response.data[i].id, response.data[i].name));
      }
    }
    final ResponseDatabase<List<CupertinoData>> responseCupertinoData
      = new ResponseDatabase.fromAnotherResponse(response);
    responseCupertinoData.data = dataSizesCupertino;
    _outputGetSizes.add(responseCupertinoData);
    if(dataSizesCupertino.isNotEmpty){
      selectedSize = dataSizesCupertino[0];
    }else{
      selectedSize = CupertinoData.empty();
    }
    _outputSelectSize.add(selectedSize);
  }

  Future<void> getTypesStatusActive()async{
    final ResponseDatabase<List<ProductType>> response = await _dbHelper.getProductTypes();
    dataTypesCupertino = <CupertinoData>[];
    for(int i = 0 ; i < response.data.length; i++)
    {
      dataTypesCupertino.add(CupertinoData(i,response.data[i].id, response.data[i].name));
    }
    final ResponseDatabase<List<CupertinoData>> responseCupertinoData
    = new ResponseDatabase.fromAnotherResponse(response);
    responseCupertinoData.data = dataTypesCupertino;
    _outputGetTypes.add(responseCupertinoData);
    if(dataTypesCupertino.isNotEmpty){
      selectedType = dataTypesCupertino[0];
    }else{
      selectedType = CupertinoData.empty();
    }
    _outputSelectType.add(selectedType);
  }

  void PickBrand(int index){
//    CupertinoData selectedData;
//    for(CupertinoData data in dataBrandsCupertino){
//      if(data.idInformation == id){
//        selectedData = data;
//        break;
//      }
//    }
//    if(selectedData != null){
//      selectedBrand = selectedData;
//      _outputSelectBrand.add(selectedBrand);
//    }
    print("masuk pick brand");
    selectedBrand = dataBrandsCupertino[index];
    _outputSelectBrand.add(selectedBrand);
  }

  void PickType(int index){
//    if(dataTypesCupertino != null){
//      CupertinoData selectedData;
//      for(CupertinoData data in dataTypesCupertino){
//        if(data.idInformation == id){
//          selectedData = data;
//          break;
//        }
//      }
//      if(selectedData != null){
//        selectedType = selectedData;
//        _outputSelectType.add(selectedType);
//      }
//    }
    selectedType = dataTypesCupertino[index];
    _outputSelectType.add(selectedType);
  }

  void PickSize(int index){
//    CupertinoData selectedData;
//    for(CupertinoData data in dataSizesCupertino){
//      if(data.idInformation == id){
//        selectedData = data;
//        break;
//      }
//    }
//    if(selectedData != null){
//      selectedSize = selectedData;
//      _outputSelectSize.add(selectedSize);
//    }
    selectedSize = dataSizesCupertino[index];
    _outputSelectSize.add(selectedSize);
  }
}