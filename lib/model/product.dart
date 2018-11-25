import 'package:salbang/model/brand.dart';
import 'package:salbang/model/product_size.dart';
import 'package:salbang/model/product_type.dart';
import 'package:salbang/model/product_unit.dart';

class Product{
  int id;
  String name;
//  double price;
  int stock;
  String description;
  int status;
//  int size;

  int brandId;
  int typeId;
  int unitId;
//  int sizeId;

  Brand productBrand;
  ProductType productType;
  ProductSize productSize;
  ProductUnit productUnit;


//  Product([this.id, this.name, this.price, this.stock, this.description,
//      this.status, this.size, this.brandId, this.typeId, this.unitId,
//      this.sizeId, this.productBrand, this.productType, this.productSize, this.productUnit]);
  Product(this.id, this.name, this.stock, this.description,
    this.status, this.brandId, this.typeId,
    {this.productBrand,
      this.productType,
      this.productSize,
      this.productUnit});

}