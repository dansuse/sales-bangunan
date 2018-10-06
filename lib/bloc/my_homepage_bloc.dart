import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:salbang/provider/bloc_provider.dart';

class MyHomePageBloc implements BlocBase{
  final _inputHomePageBody = StreamController<int>();
  final _outputHomePageBody = PublishSubject<int>();

  StreamSink<int> get inputHomePageBody => _inputHomePageBody.sink;
  Stream<int>get outputHomePageBody => _outputHomePageBody.stream;

  MyHomePageBloc(){
    _inputHomePageBody.stream.listen(handleHomePageBody);
  }

  @override
  void dispose() {
    _inputHomePageBody.close();
    _outputHomePageBody.close();
  }

  void handleHomePageBody(int index){
    _outputHomePageBody.add(index);
  }
}