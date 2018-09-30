class TypeTable{
  static const String NAME = 'type';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_NAME = 'name';
  static const String COLUMN_STATUS = 'status';

  static String getCreateTableQuery(){
    return 'CREATE TABLE '
        + NAME + '('
        + COLUMN_ID+' INTEGER PRIMARY KEY AUTOINCREMENT, '
        + COLUMN_NAME+' TEXT, '
        + COLUMN_STATUS + ' INTEGER '
        //+ 'PRIMARY KEY (' + COLUMN_ID + ')'
        + ')';
  }
}