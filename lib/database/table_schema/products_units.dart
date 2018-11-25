import 'package:salbang/database/table_schema/product.dart';
import 'package:salbang/database/table_schema/unit.dart';

///Table which created because of many-to-many relationship between table
///product and unit
class ProductsUnitsTable{
  static const String NAME = 'products_units';
  static const String COLUMN_PREFIX = 'products_units_';
  static const String COLUMN_ID = COLUMN_PREFIX + 'id';
  static const String COLUMN_TYPE_OR_SIZE = COLUMN_PREFIX + 'type_or_size';
  static const String COLUMN_PRICE = COLUMN_PREFIX + 'harga';
  static const String COLUMN_STATUS = COLUMN_PREFIX + 'status';
  static const String COLUMN_FK_PRODUCT = COLUMN_PREFIX + 'product_id';
  static const String COLUMN_FK_UNIT = COLUMN_PREFIX + 'unit_id';

  static String getCreateTableQuery(){
    return 'CREATE TABLE '
        + NAME + '('
        + COLUMN_ID+' INTEGER PRIMARY KEY AUTOINCREMENT, '
        + COLUMN_TYPE_OR_SIZE + ' TEXT, '
        + COLUMN_PRICE + ' REAL, '
        + COLUMN_STATUS + ' INTEGER '
        + COLUMN_FK_PRODUCT + ' INTEGER, '
        + COLUMN_FK_UNIT + ' INTEGER, '
        + 'FOREIGN KEY(${COLUMN_FK_PRODUCT}) REFERENCES ${ProductTable.NAME}(${ProductTable.COLUMN_ID}),'
        + 'FOREIGN KEY(${COLUMN_FK_UNIT}) REFERENCES ${UnitTable.NAME}(${UnitTable.COLUMN_ID})'
        //+ 'PRIMARY KEY (' + COLUMN_ID + ')'
        + ')';
  }

  static List<String> getColumnList(){
    return [
      COLUMN_ID,
      COLUMN_TYPE_OR_SIZE,
      COLUMN_PRICE,
      COLUMN_STATUS,
      COLUMN_FK_UNIT,
      COLUMN_FK_PRODUCT,
    ];
  }
}