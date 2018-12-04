/**
 *
 *
 * @author  Daniel Sugiarto
 * @since   04/12/18
 */

import 'package:mockito/mockito.dart';
import 'package:salbang/bloc/brand_bloc.dart';
import 'package:salbang/database/database.dart';
import 'package:test/test.dart';

class MockDBHelper extends Mock implements DBHelper {}

void main(){
  final MockDBHelper mockDBHelper = MockDBHelper();
  final BrandBloc brandBloc = BrandBloc(
    mockDBHelper,
  );
  test("status berubah ketika method updateStatus() dipanggil", (){
    brandBloc.updateStatus(false);
    expect(brandBloc.brandStatus, false);
    brandBloc.updateStatus(true);
    expect(brandBloc.brandStatus, true);
  });
}
