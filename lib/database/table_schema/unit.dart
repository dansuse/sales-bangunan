class UnitTable{
  static const String NAME = 'unit';
  static const String COLUMN_PREFIX = 'unit_';
  static const String COLUMN_ID = COLUMN_PREFIX + 'id';
  static const String COLUMN_NAME = COLUMN_PREFIX + 'name';
  static const String COLUMN_DESCRIPTION = COLUMN_PREFIX + 'description';
  static const String COLUMN_STATUS = COLUMN_PREFIX + 'status';

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
}