import 'package:salbang/database/database.dart';
import 'package:rxdart/rxdart.dart';
import 'package:salbang/model/brand.dart';
import 'package:salbang/model/button_state.dart';

class BrandBloc{
  final BehaviorSubject<bool> _outputBrandStatus = new BehaviorSubject<bool>(seedValue: true);
  Observable<bool> get outputBrandStatus => _outputBrandStatus.stream;

  final BehaviorSubject<ButtonState> _outputButtonInsertBrandState = new BehaviorSubject<ButtonState>(seedValue: ButtonState.IDLE);
  Observable<ButtonState> get outputButtonInsertBrandState => _outputButtonInsertBrandState.stream;

  final PublishSubject<String> _outputOperationResult = new PublishSubject<String>();
  Observable<String> get outputOperationResult => _outputOperationResult.stream;

  DBHelper _dbHelper;
  bool brandStatus = true;

  BrandBloc(this._dbHelper){
  }

  void dispose(){
    _outputOperationResult.close();
    _outputButtonInsertBrandState.close();
    _outputBrandStatus.close();

  }

  void updateStatus(bool status){
    brandStatus = status;
    _outputBrandStatus.add(brandStatus);
  }

  void insertBrand(String brandName, String brandDescription) async{
    _outputButtonInsertBrandState.add(ButtonState.LOADING);
    final Brand brand = new Brand(brandName, brandDescription, status: brandStatus ? 1 : 0);
    final Brand insertedBrand = await _dbHelper.insertOrUpdateBrand(brand);
    _outputButtonInsertBrandState.add(ButtonState.IDLE);
    _outputOperationResult.add(insertedBrand.name + ' dengan id "' + insertedBrand.id.toString() + '" berhasil ditambahkan');
  }
}