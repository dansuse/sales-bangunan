

class BrandTable{
  static String NAME = 'brand';
  static String COLUMN_ID = 'id';
  static String COLUMN_NAME = 'name';
  static String COLUMN_DESCRIPTION = 'description';
  static String COLUMN_STATUS = 'status';

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