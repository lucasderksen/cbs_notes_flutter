import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../services/gyro_service.dart';

class GyroParallaxWidget extends StatefulWidget {
  const GyroParallaxWidget({super.key});

  @override
  State<GyroParallaxWidget> createState() => GyroParallaxWidgetState();
}

class GyroParallaxWidgetState extends State<GyroParallaxWidget> {
  static const double _widgetSize = 150.0;
  static const double _translationScale = 50.0;
  static const String _gyroDataPattern =
      r'azimuth:\s*(-?\d*\.?\d+),\s*pitch:\s*(-?\d*\.?\d+),\s*roll:\s*(-?\d*\.?\d+)';

  double _offsetX = 0;
  double _offsetY = 0;
  double _rotation = 0;
  Timer? _timer;
  final RegExp _regex = RegExp(_gyroDataPattern);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      String data = await GyroService.getGyroData();
      try {
        final match = _regex.firstMatch(data);

        if (match != null) {
          final double azimuth = double.parse(match.group(1)!);
          final double pitch = double.parse(match.group(2)!);
          final double roll = double.parse(match.group(3)!);

          setState(() {
            // Use pitch for vertical offset and roll for horizontal offset
            _offsetX = roll * _translationScale;
            _offsetY = pitch * _translationScale;
            // Use azimuth for rotation angle (already in radians)
            _rotation = azimuth;
          });
        } else {
          if (kDebugMode) {
            debugPrint("Failed to parse gyro data: $data");
          }
          throw FormatException("Data format did not match expected pattern");
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint("Error processing gyro data: $e");
        }
        setState(() {
          _offsetX = 0.0;
          _offsetY = 0.0;
          _rotation = 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _widgetSize,
      height: _widgetSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: _widgetSize,
            height: _widgetSize,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color.fromARGB(255, 255, 255, 255), width: 1),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(_offsetX, _offsetY),
              child: Transform.rotate(
                angle: _rotation,
                child: const Icon(
                  Icons.blur_on,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
