import 'package:flutter/material.dart';
import '../widgets/gyro_parallax.dart';

class GyroPage extends StatefulWidget {
  const GyroPage({super.key});

  @override
  State<GyroPage> createState() => _GyroPageState();
}

class _GyroPageState extends State<GyroPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.fromLTRB(6.0, 12, 6, 12),
            child: Text(
              'Gyro visualizer',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
            )),
      ),
      body: Center(
        child: GyroParallaxWidget(),
      ),
    );
  }
}
