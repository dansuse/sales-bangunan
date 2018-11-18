import 'package:salbang/database/database.dart';

class ProductUnit{
  int id;
  String name;
  String description;
  int status;

  ProductUnit(this.name, this.description, {this.id = DBHelper.ID_FOR_INSERT, this.status = 1});
}