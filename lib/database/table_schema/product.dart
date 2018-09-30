import 'package:salbang/database/table_schema/brand.dart';
import 'package:salbang/database/table_schema/size.dart';
import 'package:salbang/database/table_schema/type.dart';
import 'package:salbang/database/table_schema/unit.dart';

class ProductTable{
  static const String NAME = 'product';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_NAME = 'name';
  static const String COLUMN_PRICE = 'price';
  static const String COLUMN_STOCK = 'stock';
  static const String COLUMN_DESCRIPTION = 'description';
  static const String COLUMN_STATUS = 'status';
  static const String COLUMN_SIZE = 'size';
  static const String COLUMN_FK_BRAND = 'brand_id';
  static const String COLUMN_FK_UNIT = 'unit_id';
  static const String COLUMN_FK_TYPE = 'type_id';
  static const String COLUMN_FK_SIZE = 'size_id';
  static const int DEFAULT_VALUE_FOR_PRODUCT_WITH_NO_IMAGE = -1;

  static String getCreateTableQuery(){
    return 'CREATE TABLE '
        + NAME + '('
        + COLUMN_ID+' INTEGER AUTOINCREMENT, '
        + COLUMN_NAME+' TEXT, '
        + COLUMN_PRICE + ' REAL, '
        + COLUMN_STOCK + ' INTEGER, '
        + COLUMN_DESCRIPTION + ' TEXT, '
        + COLUMN_STATUS + ' INTEGER, '
        + COLUMN_SIZE + ' INTEGER, '
        + COLUMN_FK_BRAND + ' INTEGER, '
        + COLUMN_FK_UNIT + ' INTEGER, '
        + COLUMN_FK_TYPE + ' INTEGER, '
        + COLUMN_FK_SIZE + ' INTEGER, '
        + 'PRIMARY KEY (${COLUMN_ID}),'
        + 'FOREIGN_KEY(${COLUMN_FK_BRAND}) REFERENCES ${BrandTable.NAME}(${BrandTable.COLUMN_ID}),'
        + 'FOREIGN_KEY(${COLUMN_FK_UNIT}) REFERENCES ${UnitTable.NAME}(${UnitTable.COLUMN_ID}),'
        + 'FOREIGN_KEY(${COLUMN_FK_TYPE}) REFERENCES ${TypeTable.NAME}(${TypeTable.COLUMN_ID}),'
        + 'FOREIGN_KEY(${COLUMN_FK_SIZE}) REFERENCES ${SizeTable.NAME}(${SizeTable.COLUMN_ID})'
        + ')';
  }

  static List<String> getColumnList(){
    return [
      COLUMN_ID,
      COLUMN_NAME,
      COLUMN_PRICE,
      COLUMN_STOCK,
      COLUMN_DESCRIPTION,
      COLUMN_STATUS,
      COLUMN_SIZE,
      COLUMN_FK_BRAND,
      COLUMN_FK_TYPE,
      COLUMN_FK_UNIT,
      COLUMN_FK_SIZE,
    ];
  }
}