class SizeTable{
  static const String NAME = 'size';
  static const COLUMN_PREFIX = 'size_';
  static const String COLUMN_ID = COLUMN_PREFIX + 'id';
  static const String COLUMN_NAME = COLUMN_PREFIX + 'name';
  static const String COLUMN_STATUS = COLUMN_PREFIX + 'status';

  static String getCreateTableQuery(){
    return 'CREATE TABLE '
        + NAME + '('
        + COLUMN_ID+' INTEGER PRIMARY KEY AUTOINCREMENT, '
        + COLUMN_NAME+' TEXT, '
        + COLUMN_STATUS + ' INTEGER '
//        + 'PRIMARY KEY (' + COLUMN_ID + ')'
        + ')';
  }
}