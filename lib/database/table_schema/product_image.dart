import 'package:salbang/database/table_schema/product.dart';

class ProductImageTable{
  static const String NAME = 'product_image';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_URL = 'url';
  static const String COLUMN_STATUS = 'status';
  static const String COLUMN_FK_PRODUCT = 'product_id';

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