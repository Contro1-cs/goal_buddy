import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routine_app/hard2.dart';
import 'package:routine_app/riverpod/riverpod.dart';

class HardPage extends ConsumerWidget {
  const HardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future(
      () async {
        final deviceInfoPlugin = DeviceInfoPlugin();
        final deviceInfo = await deviceInfoPlugin.androidInfo;
        final allInfo = deviceInfo.androidId;

        // ref.read(userIdProvider).setUserId(allInfo);
      },
    );
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
      ),
      appBar: AppBar(title: Text('1')),
      body: Center(
        child: Text(
          ref.watch(userIdProvider).userId,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
