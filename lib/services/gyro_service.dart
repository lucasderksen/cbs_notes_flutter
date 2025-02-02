import 'package:flutter/services.dart';

class GyroService {
  static const MethodChannel _channel = MethodChannel('com.example/gyro');

  static Future<String> getGyroData() async {
    try {
      final String result = await _channel.invokeMethod('getGyroData');
      return result;
    } on PlatformException catch (e) {
      return 'Failed to get gyro data: ${e.message}';
    }
  }
}
