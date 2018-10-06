import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salbang/provider/bloc_provider.dart';
class CupertinoPickerBloc implements BlocBase{
  final _inputSelectBrand = StreamController<int>();
  final _inputSelectType  = StreamController<int>();
  final _inputSelectSize  = StreamController<int>();

  final _outputSelectBrand = PublishSubject<int>();
  final _outputSelectType  = PublishSubject<int>();
  final _outputSelectSize  = PublishSubject<int>();

  StreamSink<int> get inputSelectBrand => _inputSelectBrand.sink;
  StreamSink<int> get inputSelectType => _inputSelectType.sink;
  StreamSink<int> get inputSelectSize => _inputSelectSize.sink;

  Stream<int>get outputSelectBrand => _outputSelectBrand.stream;
  Stream<int>get outputSelectType => _outputSelectType.stream;
  Stream<int>get outputSelectSize => _outputSelectSize.stream;

  CupertinoPickerBloc(){
    _inputSelectBrand.stream.listen(PickBrand);
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

  void PickBrand(int index){
    _outputSelectBrand.add(index);
  }
}