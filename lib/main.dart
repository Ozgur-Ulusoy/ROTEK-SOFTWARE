import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rotak_arac/baseapp.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(1070, 600));
    // WindowManager.instance.setMaximumSize(const Size(1200, 600));
  }

  runApp(const BaseApp());
}

