class ResponseSalbang<T>{
  int httpStatusCode;
  int result;
  String errorMessage;
  T data;
  ResponseSalbang({this.httpStatusCode, this.result, this.data, this.errorMessage});
}
class ResultResponseSalbang{
  static int INSERT_SQFLITE_SUCCCESS = 1;
  static int INSERT_SQFLITE_FAIL = -1;
  static int UPDATE_SQFLITE_SUCCESS = 2;
  static int UPDATE_SQFLITE_FAIL = -2;
  static int GET_SQFLITE_SUCCESS = 3;
  static int GET_SQFLITE_FAIL = -3;
}