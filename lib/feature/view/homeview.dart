import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:provider/provider.dart';
import 'package:rotak_arac/core/Mixins/dialogMixin.dart';
import 'package:rotak_arac/core/providers/main_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with CustomShowDialogMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            //* BACKGROUND IMAGE
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.fill,
              ),
            ),

            //* LAYOUT
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        child: Image.asset(
                          "assets/images/Teknofest_logo.png",
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  //! PROD
                                  // if (context
                                  //     .read<MainProvider>()
                                  //     .availablePorts
                                  //     .isEmpty) {
                                  //   showCustomDialog(
                                  //     context: context,
                                  //     title: "Hata !",
                                  //     message: "Bağlantı noktası bulunamadı.",
                                  //     positiveButtonText: "Kapat",
                                  //   );
                                  // } else {
                                  //   Navigator.pushNamed(
                                  //       context, "/control_panel");
                                  // }

                                  //! DEV
                                  Navigator.pushNamed(
                                      context, "/control_panel");
                                },
                                child: const Text(
                                  "Bağlantıyı Başlat",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, "/read_datas");
                                },
                                child: const Text(
                                  "Verileri Görüntüle",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(
                  flex: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        child: Image.asset(
                          "assets/images/rotek_logo.png",
                          width: MediaQuery.of(context).size.width * 0.22,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setPorts();
    });
  }

  Future setPorts() async {
    Provider.of<MainProvider>(context, listen: false)
        .setAvailablePorts(SerialPort.availablePorts);
  }
}
