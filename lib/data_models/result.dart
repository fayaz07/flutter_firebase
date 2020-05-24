class Result<T> {
  int statusCode;
  String message;
  bool success;
  T data;

  Result({this.statusCode, this.message, this.success = false, this.data});

  Result.success({this.statusCode, this.message, this.data}) {
    this.success = true;
  }

  Result.fail({this.statusCode, this.message}) {
    this.success = false;
  }

  Result.internalServerError({this.message}) {
    this.success = false;
    this.statusCode = 500;
  }

  Result.exception({this.message}) {
    this.success = false;
  }

  @override
  String toString() {
    return 'Result{statusCode: $statusCode, message: $message,'
        ' success: $success, data: $data}';
  }
}
