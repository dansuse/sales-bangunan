import 'package:salbang/model/product_unit.dart';
import 'package:salbang/database/database.dart';
import 'package:salbang/bloc/product_unit_dropdown_bloc.dart';

class ProductVariant{
  int id;
  double price;
  String typeOrSize;
  ProductUnit productUnit;
  int status;
  int productId;
  int unitId;
  ProductUnitDropdownBloc productUnitDropdownBloc;

  ProductVariant(this.price, this.typeOrSize, this.productId, this.unitId,
    {this.id = DBHelper.ID_FOR_INSERT, this.status = 1, this.productUnit,
    this.productUnitDropdownBloc});

}