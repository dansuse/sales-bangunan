

class BrandTable{
  static String NAME = 'brand';
  static String COLUMN_PREFIX = 'brand_';
  static String COLUMN_ID = COLUMN_PREFIX + 'id';
  static String COLUMN_NAME = COLUMN_PREFIX + 'name';
  static String COLUMN_DESCRIPTION = COLUMN_PREFIX + 'description';
  static String COLUMN_STATUS = COLUMN_PREFIX + 'status';

  static String getCreateTableQuery(){
    return 'CREATE TABLE '
        + NAME + '('
        + COLUMN_ID+' INTEGER PRIMARY KEY AUTOINCREMENT, '
        + COLUMN_NAME+' TEXT, '
        + COLUMN_DESCRIPTION + ' TEXT, '
        + COLUMN_STATUS + ' INTEGER '
        //+ 'PRIMARY KEY (' + COLUMN_ID + ')'
        + ')';
  }

  static List<String> getColumnList(){
    return [
      COLUMN_ID,
      COLUMN_NAME,
      COLUMN_DESCRIPTION,
      COLUMN_STATUS,
    ];
  }
}