import 'package:antrian_wiradadi/src/confg/size_config.dart';
import 'package:antrian_wiradadi/src/confg/style.dart';
import 'package:antrian_wiradadi/src/pages/components/menu_home_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/poliklinik_widget.dart';
import 'package:antrian_wiradadi/src/pages/components/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({
    super.key,
    required this.nama,
  });

  final String nama;

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  final _filter = TextEditingController();
  String? greeting;

  @override
  void initState() {
    super.initState();
    greet();
  }

  void greet() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = 'Pagi';
    } else if (hour < 15) {
      greeting = 'Siang';
    } else if (hour < 18) {
      greeting = 'Sore';
    } else {
      greeting = 'Malam';
    }
    setState(() {});
  }

  void _showSearch() {
    showMaterialModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
            child: TextField(
              controller: _filter,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.grey,
                hintText: 'Pencarian poliklinik',
                hintStyle: TextStyle(color: Colors.grey[400]!),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _filter.clear(),
                      icon: Icon(
                        Icons.remove_circle_outline_rounded,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(
                      width: 4.0,
                    ),
                    const Icon(Icons.search),
                  ],
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => Navigator.pop(context),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.grey[50],
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    kPrimaryColor,
                    kSecondaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat $greeting,',
                            style: const TextStyle(
                                fontSize: 20.0, color: kTextGreetingsColor),
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Text(
                            widget.nama,
                            style: const TextStyle(
                              fontSize: 22.0,
                              color: kTextGreetingsColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Semoga Anda lekas sembuh',
                    style: TextStyle(
                      color: kTextGreetingsColor.withAlpha(150),
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: SizeConfig.blockSizeVertical * 79,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, bottom: 18.0),
                      child: SearchWidget(
                        filter: _filter,
                        hint: 'Pencarian Poliklinik',
                        onTap: _showSearch,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18),
                            topLeft: Radius.circular(18),
                          ),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(-3, 2.0),
                              blurRadius: 12.0,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MenuHomeWidget(),
                            Expanded(
                              child: PoliklinikWidget(
                                filter: _filter,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({
    super.key,
    this.icon,
    this.title,
    this.onTap,
  });

  final String? title;
  final Widget? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? const SizedBox(),
            const SizedBox(
              height: 15.0,
            ),
            SizedBox(
              width: 80,
              child: Center(
                child: Text(
                  '$title',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
