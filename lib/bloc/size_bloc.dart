import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/model/button_state.dart';
import 'package:salbang/model/product_size.dart';
import 'package:salbang/model/response_database.dart';
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

  final PublishSubject<ResponseDatabase<List<ProductSize>>> _outputListDataSizes = new PublishSubject<ResponseDatabase<List<ProductSize>>>();
  Observable<ResponseDatabase<List<ProductSize>>> get outputListDataSizes => _outputListDataSizes.stream;

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

  Future<void> getSizesData() async{
    final ResponseDatabase<List<ProductSize>> listDataSizes = await _dbHelper.getProductSizes();
    _outputListDataSizes.add(listDataSizes);
  }

  void insertSize(String sizeName) async{
    print(sizeName);
    _outputButtonInsertSizeState.add(ButtonState.LOADING);
    final ProductSize size = new ProductSize(sizeName, status: sizeStatus ? 1 : 0);
    final ResponseDatabase<ProductSize> insertedProductSize = await _dbHelper.insertOrUpdateSize(size);
    _outputButtonInsertSizeState.add(ButtonState.IDLE);
    _outputOperationResult.add(insertedProductSize.data.name + ' dengan id "' + insertedProductSize.data.id.toString() + '" berhasil ditambahkan');
  }

  void updateSize(ProductSize productSize) async{
    _outputButtonInsertSizeState.add(ButtonState.LOADING);
    final ProductSize size = new ProductSize(productSize.name, id: productSize.id, status: productSize.status);
    final ResponseDatabase<ProductSize> insertedProductSize = await _dbHelper.insertOrUpdateSize(size);
    _outputButtonInsertSizeState.add(ButtonState.IDLE);
    _outputOperationResult.add(insertedProductSize.data.name + ' dengan id "' + insertedProductSize.data.id.toString() + '" berhasil diubah');
  }

  Future<ResponseDatabase> deleteSize(int id)async{
    final ResponseDatabase responseDatabase = await _dbHelper.deleteSize(id);
    if(responseDatabase.result == ResponseDatabase.SUCCESS){
      await getSizesData();
    }
    return responseDatabase;
  }

  void restoreSize(ProductSize size) async{
    size.status = 1;
    final ResponseDatabase<ProductSize> response
      = await _dbHelper.insertOrUpdateSize(size);
    if(response.result == ResponseDatabase.SUCCESS){
      await getSizesData();
    }
  }

  @override
  void dispose() {
    _outputOperationResult.close();
    _outputButtonInsertSizeState.close();
    _outputSizeStatus.close();

  }
}
