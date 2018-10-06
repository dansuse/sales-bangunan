import 'package:flutter/widgets.dart';
import 'package:salbang/database/database.dart';

class DatabaseProvider extends InheritedWidget{

  final DBHelper dbHelper;
  DatabaseProvider(this.dbHelper, {Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
  static DBHelper of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(DatabaseProvider) as DatabaseProvider)
          .dbHelper;
}