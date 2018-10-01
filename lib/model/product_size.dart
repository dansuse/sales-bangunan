import 'package:salbang/database/database.dart';

class ProductSize{
  int id;
  String name;
  int status;

  ProductSize(this.name, {this.id = DBHelper.ID_FOR_INSERT, this.status = 1});

}