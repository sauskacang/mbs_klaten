import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:android_smartscholl/core/client/dio_client.dart';
import 'package:android_smartscholl/helper/constant.dart';
import 'package:android_smartscholl/helper/currencyIdr.dart';
import 'package:android_smartscholl/helper/sizeConfig.dart';
import 'package:android_smartscholl/helper/skeleton.dart';
import 'package:android_smartscholl/home/gantipassword/gantiPassword.dart';
import 'package:android_smartscholl/models/detailTagihanModel.dart';
import 'package:android_smartscholl/models/tagihanModel.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:need_resume/need_resume.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ResumableState<HomeScreen> {
  var vaspp = "";
  String mahasiswa = "";
  String vasaku = "";
  String jenjang = "";
  String kelas = "";
  int saldoUangSaku = 0;
  bool bSaldoUangSaku = false;

  int saldoSpp = 0;
  bool bSaldo = false;

  bool isSuccess = false;
  var tagihanData;
  int totaltagihan = 0;
  int totalBayar = 0;
  bool isTagihan = true;
  List<TagihanModel>? tagihanLnd = [];
  bool bTagihanLnd = false;

  @override
  void onReady() {
    super.onReady();
    getList();
  }

  @override
  void onResume() {
    super.onResume();
    // ini untuk ketika update biar langsung
    getList();
  }

  Future<void> getList() async {
    final dataMhs = await Hive.openBox('myToken');
    var password = dataMhs.get('password');
    var username = dataMhs.get('username');
    setState(() {
      isSuccess = true;
      mahasiswa = dataMhs.get('mahasiswa');
      vasaku = dataMhs.get('novasaku');
      vaspp = dataMhs.get('nova');
      jenjang = dataMhs.get('jenjang');
      kelas = dataMhs.get('kelas');
      isSuccess = false;
    });

    final jwtSaldo = JWT({
      'METHOD': 'SaldoRequest',
      'USERNAME': username,
      'PASSWORD': password,
    });
    final tokenSaldo = jwtSaldo.sign(SecretKey("TokenJWT_MOBILE_ICT"));
    var responseSaldo = await DioClient()
        .apiCall(url: '?token=$tokenSaldo', requestType: RequestType.get);
    var arrResponseSaldo = jsonDecode(responseSaldo.toString());
    var saldo = int.parse(arrResponseSaldo['SALDO'].replaceAll('.', ''));

    setState(() {
      bSaldo = true;
      saldoSpp = saldo;
    });

    final jwtSaku = JWT({
      'METHOD': 'SaldoRequestSaku',
      'USERNAME': username,
      'PASSWORD': password,
    });
    final tokenSaku = jwtSaku.sign(SecretKey("TokenJWT_MOBILE_ICT"));
    var responseSaku = await DioClient()
        .apiCall(url: '?token=$tokenSaku', requestType: RequestType.get);
    var arrResponseSaku = jsonDecode(responseSaku.toString());
    var saku = int.parse(arrResponseSaku['SALDOSAKU'].replaceAll('.', ''));

    setState(() {
      bSaldoUangSaku = true;
      saldoUangSaku = saku;
    });
    final jwtTagihan = JWT({
      'METHOD': 'BillRequest',
      'USERNAME': username,
      'PASSWORD': password,
    });
    final tagihanJwt = jwtTagihan.sign(SecretKey("TokenJWT_MOBILE_ICT"));
    var responseTagihan = await DioClient()
        .apiCall(url: '?token=$tagihanJwt', requestType: RequestType.get);
    var arrResponseTagihan = jsonDecode(responseTagihan.toString());
    if (arrResponseTagihan['KodeRespon'] == 1) {
      tagihanData = arrResponseTagihan['datas'] as List;
      print(tagihanData);
      setState(() {
        isTagihan = true;
      });
    }

    setState(() {
      if (isTagihan) {
        tagihanLnd = tagihanLnd! +
            (tagihanData as List<dynamic>).map((element) {
              var detailTagihanData = element['det'] as List<dynamic>;
              List<DetailTagihanModel> detailTagihanList = detailTagihanData
                  .map(
                    (detailElement) => DetailTagihanModel(
                      kodePost: detailElement['KodePost'].toString(),
                      namaPost: detailElement['NamaPost'].toString(),
                      detailNominal: int.parse(
                          detailElement['DetailNominal'].replaceAll('.', '')),
                    ),
                  )
                  .toList();

              return TagihanModel(
                namaTagihan: element['NamaTagihan'].toString(),
                kodeTagihan: element['KodeTagihan'].toString(),
                tahunAkademik: element['TahunAkademik'].toString(),
                totalNominal:
                    int.parse(element['TotalNominal'].replaceAll('.', '')),
                detailTagihan: detailTagihanList,
              );
            }).toList();

        totaltagihan =
            tagihanLnd!.fold(0, (sum, item) => sum + item.totalNominal);
      }
    });
    setState(() {
      totalBayar = totaltagihan - saldoSpp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final header = Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(4, 6), // Shadow position
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    height: getProportionateScreenWidth(60),
                    width: getProportionateScreenWidth(60),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/avatar.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // padding: const EdgeInsets.all(10),
                      child: Text(
                        "Hi $mahasiswa",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 19),
                      ),
                    ),
                    Container(
                      // padding: const EdgeInsets.all(0),
                      child: Text(
                        '$vasaku',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
    final himbauan = Center(
      /** Card Widget **/
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(30.0), // Mengatur kelengkungan sudut
            ),
            color: Colors.white,
            child: Container(
              width: getProportionateScreenWidth(340),
              // height: getProportionateScreenHeight(250),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      // physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Tagihan Belum Terbayar : ',
                                style: TextStyle(
                                    fontSize: getProportionateScreenWidth(12),
                                    color: Colors.grey)),
                          ),
                          const Divider(
                            // thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ]),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: tagihanLnd!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 9, bottom: 9, left: 20),
                                        child: Text(
                                            ' ${tagihanLnd![index].namaTagihan}  ${CurencyIdr.convertToIdr(tagihanLnd![index].totalNominal, 0)}',
                                            style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15))),
                                      )),
                                  const Divider(
                                    // thickness: 1,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                ],
                              );
                            }),
                        Column(children: [
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 9, bottom: 9, left: 20),
                                child: Text(
                                    'Tagihan Akan Lunas Jika Saldo SPP lebih besar atau sama dengan tagihan ',
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(15))),
                              )),
                          const Divider(
                            // thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ]),
                        Column(children: [
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 9, bottom: 9, left: 20),
                                child: Text(
                                    'Bayar sejumlah ${CurencyIdr.convertToIdr(totalBayar, 0)} untuk melunasi tagihan',
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(15))),
                              )),
                          const Divider(
                            // thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ]),
                      ])), //Padding
            ), //SizedBox
          ),
        ],
      ), //Card
    );
    final button = Container(
      margin: EdgeInsets.all(20),
      child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GantiPassword()));
          },
          padding: const EdgeInsets.all(20),
          color: kPrimaryColor,
          child: const Text('Ganti Password',
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)))),
    );

    final data = Center(
      /** Card Widget **/
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(30.0), // Mengatur kelengkungan sudut
            ),
            color: Colors.white,
            child: SizedBox(
              width: getProportionateScreenWidth(340),
              height: getProportionateScreenHeight(400),
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            // padding: const EdgeInsets.all(11.0),
                            child: Text('No Va SPP',
                                style: TextStyle(
                                    fontSize: getProportionateScreenWidth(12),
                                    color: Colors.grey)),
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 9, bottom: 9, left: 20),
                                    child: Text('$vaspp',
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(
                                                    15))),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.copy),
                                    onPressed: () {
                                      _copyToClipboard(context, '$vaspp');
                                    },
                                  ),
                                ],
                              )),
                          const Divider(
                            // thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ]),
                        Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            // padding: const EdgeInsets.all(11.0),
                            child: Text('No Va Saku',
                                style: TextStyle(
                                    fontSize: getProportionateScreenWidth(12),
                                    color: Colors.grey)),
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 9, bottom: 9, left: 20),
                                    child: Text('$vasaku',
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(
                                                    15))),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.copy),
                                    onPressed: () {
                                      _copyToClipboard(context, '$vasaku');
                                    },
                                  ),
                                ],
                              )),
                          const Divider(
                            // thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ]),
                        Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            // padding: const EdgeInsets.all(11.0),
                            child: Text('Jenjang',
                                style: TextStyle(
                                    fontSize: getProportionateScreenWidth(12),
                                    color: Colors.grey)),
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 9, bottom: 9, left: 20),
                                child: Text('$jenjang',
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(15))),
                              )),
                          const Divider(
                            // thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ]),
                        Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            // padding: const EdgeInsets.all(11.0),
                            child: Text('Kelas',
                                style: TextStyle(
                                    fontSize: getProportionateScreenWidth(12),
                                    color: Colors.grey)),
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 9, bottom: 9, left: 20),
                                child: Text('$kelas',
                                    style: TextStyle(
                                        fontSize:
                                            getProportionateScreenWidth(15))),
                              )),
                          const Divider(
                            // thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ]),
                        // Column(children: [
                        //   Align(
                        //     alignment: Alignment.centerLeft,
                        //     // padding: const EdgeInsets.all(11.0),
                        //     child: Text('Saldo Uang Saku',
                        //         style: TextStyle(
                        //             fontSize: getProportionateScreenWidth(12),
                        //             color: Colors.grey)),
                        //   ),
                        //   Align(
                        //       alignment: Alignment.bottomLeft,
                        //       child: Padding(
                        //         padding: const EdgeInsets.only(
                        //             top: 9, bottom: 9, left: 20),
                        //         child: bSaldoUangSaku
                        //             ? Text(
                        //                 '${CurencyIdr.convertToIdr(saldoUangSaku, 0)}',
                        //                 style: TextStyle(
                        //                     fontSize:
                        //                         getProportionateScreenWidth(
                        //                             15)))
                        //             : CustomShimmer(
                        //                 height:
                        //                     getProportionateScreenHeight(20),
                        //                 width: getProportionateScreenWidth(150),
                        //               ),
                        //       )),
                        //   const Divider(
                        //     // thickness: 1,
                        //     indent: 10,
                        //     endIndent: 10,
                        //   ),
                        // ]),
                        Column(children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            // padding: const EdgeInsets.all(11.0),
                            child: Text('Saldo SPP',
                                style: TextStyle(
                                    fontSize: getProportionateScreenWidth(12),
                                    color: Colors.grey)),
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 9, bottom: 9, left: 20),
                                child: bSaldo
                                    ? Text(
                                        '${CurencyIdr.convertToIdr(saldoSpp, 0)}',
                                        style: TextStyle(
                                            fontSize:
                                                getProportionateScreenWidth(
                                                    15)))
                                    : CustomShimmer(
                                        height:
                                            getProportionateScreenHeight(20),
                                        width: getProportionateScreenWidth(150),
                                      ),
                              )),
                          const Divider(
                            // thickness: 1,
                            indent: 10,
                            endIndent: 10,
                          ),
                        ]),
                      ])), //Padding
            ), //SizedBox
          ),
        ],
      ), //Card
    );

    return ListView(
        children: [header, data, SizedBox(height: 20), himbauan, button]);
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
      ),
    );
  }
}
