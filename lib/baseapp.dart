import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rotak_arac/core/providers/main_provider.dart';
import 'package:rotak_arac/feature/view/control_panel_view.dart';
import 'package:rotak_arac/feature/view/homeview.dart';
import 'package:rotak_arac/feature/view/read_datas_view.dart';

class BaseApp extends StatelessWidget {
  const BaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: MaterialApp(
        title: "Rotak Araç Takip Sistemi",
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => const HomeView(),
          '/control_panel': (context) => const ControlPanelView(),
          '/read_datas': (context) => const ReadDatasView(),
        },
        initialRoute: '/home',
      ),
    );
  }
}
