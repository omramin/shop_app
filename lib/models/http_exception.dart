// We forced to implement all functions this class has
class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    // Returning our custom string, the message
    return message;
    // return super.toString(); // Instance of HttpException
  }
}

/**
 * The HTTP exception class is configured to ALWAYS print the message when we call our [ourExceptionClass.toString()]
 * OR when we type [ print(ourExceptionClass-name) ]
 */