class NetworkResponse {
  late bool response;
  late String message;
  Object? responseObject;

  NetworkResponse(this.response, this.message, this.responseObject);

  @override
  String toString() {
    return 'NetworkResponse{response: $response, message: $message, responseObject: $responseObject}';
  }
}
