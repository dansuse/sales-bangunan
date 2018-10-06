import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/model/product_size.dart';
import 'package:salbang/provider/bloc_provider.dart';

class SizeBloc implements BlocBase{
  final _inputSizeStatus = StreamController<bool>();
  final _inputInsertSize  = StreamController<String>();
  final _inputUpdateSize  = StreamController<ProductSize>();

  StreamSink<bool> get inputSizeStatus => _inputSizeStatus.sink;
  StreamSink<String> get inputInsertSize => _inputInsertSize.sink;
  StreamSink<ProductSize> get inputUpdateSize => _inputUpdateSize.sink;

  final BehaviorSubject<bool> _outputSizeStatus = new BehaviorSubject<bool>(seedValue: true);
  Observable<bool> get outputSizeStatus => _outputSizeStatus.stream;

  final BehaviorSubject<ButtonState> _outputButtonInsertSizeState = new BehaviorSubject<ButtonState>(seedValue: ButtonState.IDLE);
  Observable<ButtonState> get outputButtonInsertSizeState => _outputButtonInsertSizeState.stream;

  final PublishSubject<String> _outputOperationResult = new PublishSubject<String>();
  Observable<String> get outputOperationResult => _outputOperationResult.stream;

  final PublishSubject<ResponseSalbang<List<ProductSize>>> _outputListDataSizes = new PublishSubject<ResponseSalbang<List<ProductSize>>>();
  Observable<ResponseSalbang<List<ProductSize>>> get outputListDataSizes => _outputListDataSizes.stream;

  DBHelper _dbHelper;
  bool sizeStatus = true;

  SizeBloc(this._dbHelper){
    _inputSizeStatus.stream.listen(updateStatus);
    _inputInsertSize.stream.listen(insertSize);
    _inputUpdateSize.stream.listen(updateSize);
  }

  void updateStatus(bool status){
    sizeStatus = status;
    _outputSizeStatus.add(sizeStatus);
  }

  void getSizesData() async{
    final ResponseSalbang<List<ProductSize>> listDataSizes = await _dbHelper.getProductSizes();
    _outputListDataSizes.add(listDataSizes);
  }

  void insertSize(String sizeName) async{
    print(sizeName);
    _outputButtonInsertSizeState.add(ButtonState.LOADING);
    final ProductSize size = new ProductSize(sizeName, status: sizeStatus ? 1 : 0);
    final ProductSize insertedProductSize = await _dbHelper.insertOrUpdateSize(size);
    _outputButtonInsertSizeState.add(ButtonState.IDLE);
    _outputOperationResult.add(insertedProductSize.name + ' dengan id "' + insertedProductSize.id.toString() + '" berhasil ditambahkan');
  }

  void updateSize(ProductSize productSize) async{
    _outputButtonInsertSizeState.add(ButtonState.LOADING);
    final ProductSize size = new ProductSize(productSize.name, id: productSize.id, status: productSize.status);
    final ProductSize insertedProductSize = await _dbHelper.insertOrUpdateSize(size);
    _outputButtonInsertSizeState.add(ButtonState.IDLE);
    _outputOperationResult.add(insertedProductSize.name + ' dengan id "' + insertedProductSize.id.toString() + '" berhasil diubah');
  }

  @override
  void dispose() {
    _outputOperationResult.close();
    _outputButtonInsertSizeState.close();
    _outputSizeStatus.close();

  }
}

class ResponseSalbang<T>{
  int httpStatusCode;
  int result;
  String errorMessage;
  T data;
  ResponseSalbang({this.httpStatusCode, this.result, this.data, this.errorMessage});
}
class ResultResponseSalbang{
  static int INSERT_SIZE_SUCCESS = 1;
  static int UPDATE_SIZE_SUCCESS = 2;
  static int UPDATE_SIZE_FAIL = -2;
  static int INSERT_SIZE_FAIL = -1;
  static int GET_SIZE_SUCESS = 3;
  static int GET_SIZE_FAIL = -3;
}