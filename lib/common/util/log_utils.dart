import 'package:logger/logger.dart';

/// 日志工具类
class LogUtils {
  LogUtils._();
  static Logger _logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
        ),
  );

  static void d(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _logger.d(message, error, stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _logger.i(message, error, stackTrace);
  }

  static void e(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _logger.e(message, error, stackTrace);
  }

  static void v(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _logger.v(message, error, stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace stackTrace]) {
    _logger.w(message, error, stackTrace);
  }

  static void log(Level level, dynamic message,
      [dynamic error, StackTrace stackTrace]) {
    _logger.log(level, message, error, stackTrace);
  }
}
