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

  ResponseDatabase.fromAnotherResponse(ResponseDatabase anotherResponse){
    result = anotherResponse.result;
    message = anotherResponse.message;
  }

  ResponseDatabase.fromAnotherResponseWithCustomMessage(ResponseDatabase anotherResponse, this.message){
    result = anotherResponse.result;
  }

  ResponseDatabase.createShouldRetryResponseWithMessage(this.message){
    result = ERROR_SHOULD_RETRY;
  }

  ResponseDatabase.createRequestInProgressResponse(){
    result = LOADING;
  }

  ResponseDatabase.createEmptyResponse({this.message}){
    result = SUCCESS_EMPTY;
  }

}