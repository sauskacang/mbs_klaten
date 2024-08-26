import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbs_klaten/core/client/dio_client.dart';
import 'package:mbs_klaten/helper/constant.dart';
import 'package:mbs_klaten/helper/currencyIdr.dart';
import 'package:mbs_klaten/helper/sizeConfig.dart';
import 'package:mbs_klaten/home/keuangan/lihatTagihan.dart';
import 'package:mbs_klaten/home/keuangan/panduanPembayaran.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mbs_klaten/models/tagihanModel.dart';
import 'package:need_resume/need_resume.dart';

class KonfirmasiPembayaran extends StatefulWidget {
  const KonfirmasiPembayaran({Key? key, this.dataTagihan}) : super(key: key);

  final TagihanModel? dataTagihan;
  @override
  _KonfirmasiPembayaranState createState() => _KonfirmasiPembayaranState();
}

class _KonfirmasiPembayaranState extends ResumableState<KonfirmasiPembayaran> {
  late int? test; // Declare the variable with the correct type
  var nova = "";
  var nama = "";
  int saldoSpp = 0;
  bool readOnly = true;
  bool isLoading = false;
  late TextEditingController tvNominal = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    getList();
    tvNominal = TextEditingController(
      text: '${widget.dataTagihan?.totalNominal ?? 0}',
    );
  }

  @override
  void onResume() {
    super.onResume();
    getList();
  }

  void getList() async {
    final dataMhs = await Hive.openBox('myToken');
    var password = dataMhs.get('password');
    var username = dataMhs.get('username');
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
      saldoSpp = saldo;
      if (widget.dataTagihan!.allow == 'DAPAT DI CICIL') {
        readOnly = false;
      } else if (widget.dataTagihan!.allow == 'TIDAK DAPAT DI CICIL') {
        readOnly = true;
      }

      nova = dataMhs.get('nova');
      nama = dataMhs.get('mahasiswa');
      tvNominal.text =
          '${widget.dataTagihan?.totalNominal ?? 0}'; // Update the text in controller
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LihatTagihan()));
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(5)),
                child: Image.asset('assets/images/diesel.png')),
            title: const Text(
              'Halaman Bayar SPP',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: kPrimaryColor),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: getProportionateScreenHeight(200),
                    width: getProportionateScreenHeight(200),
                    child: Image.asset(
                      'assets/images/wallet.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: getProportionateScreenHeight(450),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30.0), // Mengatur kelengkungan sudut
                      ),
                      color: Colors.white,
                      child: SizedBox(
                        width: getProportionateScreenWidth(340),
                        height: getProportionateScreenHeight(250),
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  Container(
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.center,
                                        // padding: const EdgeInsets.all(11.0),
                                        child: Text('Nama',
                                            style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15),
                                                color: Colors.grey)),
                                      ),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                              nama.length > 26
                                                  ? nama.substring(0, 23) +
                                                      '...'
                                                  : nama,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      getProportionateScreenWidth(
                                                          17)))),
                                    ]),
                                  ),
                                  Divider(),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: getProportionateScreenHeight(10)),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.center,
                                        // padding: const EdgeInsets.all(11.0),
                                        child: Text('Nama Tagihan',
                                            style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15),
                                                color: Colors.grey)),
                                      ),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child: Text(
                                                    '${widget.dataTagihan!.namaTagihan}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            getProportionateScreenWidth(
                                                                17)),
                                                  )),
                                            ],
                                          )),
                                    ]),
                                  ),
                                  Divider(),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: getProportionateScreenHeight(10)),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.center,
                                        // padding: const EdgeInsets.all(11.0),
                                        child: Text('jenis Tagihan',
                                            style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15),
                                                color: Colors.grey)),
                                      ),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child: Text(
                                                    '${widget.dataTagihan!.allow}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            getProportionateScreenWidth(
                                                                17)),
                                                  )),
                                            ],
                                          )),
                                    ]),
                                  ),
                                  Divider(),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: getProportionateScreenHeight(10)),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.center,
                                        // padding: const EdgeInsets.all(11.0),
                                        child: Text('Tahun Akademik',
                                            style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15),
                                                color: Colors.grey)),
                                      ),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child: Text(
                                                    '${widget.dataTagihan!.tahunAkademik}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            getProportionateScreenWidth(
                                                                17)),
                                                  )),
                                            ],
                                          )),
                                    ]),
                                  ),
                                  Divider(),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: getProportionateScreenHeight(10)),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.center,
                                        // padding: const EdgeInsets.all(11.0),
                                        child: Text('Saldo',
                                            style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15),
                                                color: Colors.grey)),
                                      ),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0),
                                                  child: Text(
                                                    '${CurencyIdr.convertToIdr(saldoSpp, 0)}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            getProportionateScreenWidth(
                                                                17)),
                                                  )),
                                            ],
                                          )),
                                    ]),
                                  ),
                                  Divider(),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: getProportionateScreenHeight(10)),
                                    child: Column(children: [
                                      Align(
                                        alignment: Alignment.center,
                                        // padding: const EdgeInsets.all(11.0),
                                        child: Text('Nominal',
                                            style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        15),
                                                color: Colors.grey)),
                                      ),
                                      Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 0),
                                            child: TextFormField(
                                              controller: tvNominal,
                                              readOnly: readOnly,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                          )),
                                    ]),
                                  ),
                                ])), //Padding
                      ), //SizedBox
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: getProportionateScreenWidth(10),
                            right: getProportionateScreenWidth(10)),
                        child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LihatTagihan()));
                            },
                            padding: const EdgeInsets.all(20),
                            color: Colors.red,
                            child: const Text('Batal',
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1)))),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: getProportionateScreenWidth(10),
                            right: getProportionateScreenWidth(10)),
                        child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () async {
                              try {
                                setState(() {
                                  isLoading = true;
                                });

                                var openBox = await Hive.openBox('myToken');
                                var password = openBox.get('password');
                                var username = openBox.get('username');
                                final jwt = JWT({
                                  'METHOD': readOnly
                                      ? 'PaymentExeV2'
                                      : 'PaymentExeCicilV2',
                                  'KodeTagihan':
                                      '${widget.dataTagihan!.billId}',
                                  'PASSWORD': password,
                                  'USERNAME': username,
                                  'Nominal': tvNominal.text,
                                });
                                final token =
                                    jwt.sign(SecretKey("TokenJWT_MOBILE_ICT"));
                                var response = await DioClient().apiCall(
                                    url: '?token=$token',
                                    requestType: RequestType.get);
                                var arrResponse =
                                    jsonDecode(response.toString());
                                print(arrResponse[0]['STATUS']);

                                var message = arrResponse[0]['RESULT'];
                                if (arrResponse[0]['STATUS'] == 'NOTOK') {
                                  Fluttertoast.showToast(
                                      msg: message,
                                      backgroundColor: Colors.red,
                                      webBgColor:
                                          "linear-gradient(to right, #f44336, #ff9800)",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 3,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  Fluttertoast.showToast(
                                      msg: message,
                                      backgroundColor: Colors.green,
                                      webBgColor:
                                          "linear-gradient(to right, #f44336, #ff9800)",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 3,
                                      textColor: Colors.white,
                                      fontSize: 16.0);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LihatTagihan()));
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            padding: const EdgeInsets.all(20),
                            color: kPrimaryColor,
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Bayar',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 1)))),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
