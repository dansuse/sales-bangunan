import 'package:salbang/database/database.dart';
class Brand{
  int id;
  String name;
  String description;
  int status;
  Brand(this.name, this.description, {this.id = DBHelper.ID_FOR_INSERT, this.status = 1});
}