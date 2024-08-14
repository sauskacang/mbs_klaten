import 'package:android_smartscholl/helper/constant.dart';
import 'package:android_smartscholl/helper/sizeConfig.dart';
import 'package:flutter/material.dart';

class Notif extends StatefulWidget {
  const Notif({Key? key}) : super(key: key);

  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
          title: const Text(
            'Berita',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: kPrimaryColor),
          ),
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 4.0, color: kPrimaryColor),
              insets: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(100)),
            ),
            labelColor: kPrimaryColor,
            tabs: const [
              Tab(text: 'Berita Umum'),
              Tab(text: 'Berita Individu'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TabContent(apiUrl: true),
            TabContent(apiUrl: false),
          ],
        ),
      ),
    );
  }
}

class TabContent extends StatefulWidget {
  final bool apiUrl;

  TabContent({required this.apiUrl});

  @override
  _TabContentState createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  late Future<Map<String, dynamic>> futureData;

  @override
  Widget build(BuildContext context) {
    return widget.apiUrl
        ? ListView(
            children: [
              Container(
                  margin: EdgeInsets.all(getProportionateScreenWidth(10)),
                  child: Card(
                    
                    child: Container(
                      margin: EdgeInsets.all(getProportionateScreenWidth(10)),
                      padding: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(10)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TEST Pemberitahuan PTS Ganjil 21/22 SMP-SMA Putri 1 dan Putra (Tahfidzh)",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            "2021-09-23 02:09:53",
                            style: TextStyle(fontSize: 15),
                          ),
                          Divider(),
                          Text(
                            "Bismillahirohman rohim, allahuma sholi 'ala Muhammad. Menginformasikan bahwa PTS Ganjir 2021/2022 untuk jenjang SMP-SMA akan dilaksanakan mulai TGL 27 September 2021 dampai 1 Oktober 2021",
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ))
            ],
          )
        : const Center(child: Text('tidak ada data'));
  }
}
