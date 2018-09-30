

class BrandTable{
  static const String NAME = 'brand';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_NAME = 'name';
  static const String COLUMN_DESCRIPTION = 'description';
  static const String COLUMN_STATUS = 'status';

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