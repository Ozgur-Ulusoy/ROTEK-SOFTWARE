import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rotak_arac/core/providers/main_provider.dart';
import 'package:rotak_arac/feature/view/homeview.dart';

class BaseApp extends StatelessWidget {
  const BaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: const MaterialApp(
        title: "Rotak Araç Takip Sistemi",
        debugShowCheckedModeBanner: false,
        home: HomeView(),
      ),
    );
  }
}
