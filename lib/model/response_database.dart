class ResponseDatabase<T>{
  static const int SUCCESS = 1;
  static const int SUCCESS_EMPTY = 2;
  static const int ERROR_SHOULD_RETRY = -1;
  static const int ERROR_DO_NOTHING = -2;
  static const int LOADING = 0;
  T data;
  int result;
  String message;
  ResponseDatabase({this.data, this.result, this.message});

}