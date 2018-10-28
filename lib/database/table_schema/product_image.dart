import 'package:salbang/database/table_schema/product.dart';

class ProductImageTable{
  static const String NAME = 'product_image';
  static const String COLUMN_PREFIX = 'product_image_';
  static const String COLUMN_ID = COLUMN_PREFIX + 'id';
  static const String COLUMN_URL = COLUMN_PREFIX + 'url';
  static const String COLUMN_STATUS = COLUMN_PREFIX + 'status';
  static const String COLUMN_FK_PRODUCT = COLUMN_PREFIX + 'product_id';

  static String getCreateTableQuery(){
    return 'CREATE TABLE '
        + NAME + '('
        + COLUMN_ID+' INTEGER PRIMARY KEY AUTOINCREMENT, '
        + COLUMN_URL+' TEXT, '
        + COLUMN_STATUS + ' INTEGER, '
        + COLUMN_FK_PRODUCT + ' INTEGER, '
        //+ 'PRIMARY KEY (${COLUMN_ID} , ${COLUMN_FK_PRODUCT}),'
        + 'FOREIGN KEY (${COLUMN_FK_PRODUCT}) REFERENCES ${ProductTable.NAME}(${ProductTable.COLUMN_ID})'
        + ')';
  }
}