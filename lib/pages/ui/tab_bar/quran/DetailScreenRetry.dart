import 'package:flutter/material.dart';

class DetailScreenRetry extends StatelessWidget {
  final Function onRetry;

  const DetailScreenRetry({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off,
              size: 100,
            ),
            const SizedBox(height: 10),
            const Text(
              'Gagal memuat surah',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onRetry();
              },
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
