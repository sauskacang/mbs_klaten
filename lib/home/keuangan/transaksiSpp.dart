import 'dart:convert';

import 'package:android_smartscholl/core/client/dio_client.dart';
import 'package:android_smartscholl/helper/constant.dart';
import 'package:android_smartscholl/helper/currencyIdr.dart';
import 'package:android_smartscholl/helper/sizeConfig.dart';
import 'package:android_smartscholl/models/detailPembayaranSPPModel.dart';
import 'package:android_smartscholl/models/pembayaranSPPModel.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:need_resume/need_resume.dart';

class TransaksiSpp extends StatefulWidget {
  const TransaksiSpp({Key? key}) : super(key: key);

  @override
  _TransaksiSppState createState() => _TransaksiSppState();
}

class _TransaksiSppState extends ResumableState<TransaksiSpp> {
  bool isLoading = false;
  var pembayaranSPPData;
  int totalDetailTagihan = 0;
  List<PembayaranSPPModel>? pembayaranSPPnLnd = [];
  List<DetailPembayaranSPPModel>? detailPembayaranSPPnLnd = [];

  var totalPembayaranSPP = 0;

  @override
  void onReady() {
    super.onReady();
    getList();
  }

  @override
  void onResume() {
    super.onResume();
    getList();
  }

  Future<void> getList() async {
    setState(() {
      isLoading = true;
    });
    final dataMhs = await Hive.openBox('myToken');
    var password = dataMhs.get('password');
    var username = dataMhs.get('username');
    final jwtTagihan = JWT({
      'METHOD': 'PaymentRequestThnAka',
      'USERNAME': username,
      'PASSWORD': password,
      "TahunAkademik": "2020/2021"
    });
    final pembayaranSPPJwt = jwtTagihan.sign(SecretKey("TokenJWT_MOBILE_ICT"));
    var responsePembayaranSPP = await DioClient()
        .apiCall(url: '?token=$pembayaranSPPJwt', requestType: RequestType.get);
    var arrResponsePembayaranSPP = jsonDecode(responsePembayaranSPP.toString());
    if (arrResponsePembayaranSPP['KodeRespon'] == 1) {
      pembayaranSPPData = arrResponsePembayaranSPP['datas'] as List;
    }
    setState(() {
      if (arrResponsePembayaranSPP['KodeRespon'] == 1) {
        pembayaranSPPnLnd = pembayaranSPPnLnd! +
            (pembayaranSPPData as List<dynamic>).map((element) {
              var detailTagihanData = element['det'] as List<dynamic>;
              List<DetailPembayaranSPPModel> detailTagihanList =
                  detailTagihanData
                      .map(
                        (detailElement) => DetailPembayaranSPPModel(
                          kodePost: detailElement['KodePost'].toString(),
                          namaPost: detailElement['NamaPost'].toString(),
                          detailNominal:
                              int.parse(detailElement['DetailNominal']),
                        ),
                      )
                      .toList();
              return PembayaranSPPModel(
                namaTagihan: element['NamaTagihan'].toString(),
                kodeTagihan: element['KodeTagihan'].toString(),
                tahunAkademik: element['TahunAkademik'].toString(),
                totalNominal: int.parse(element['TotalNominal']),
                detailTagihan: detailTagihanList,
              );
            }).toList();
      }
      totalPembayaranSPP =
          pembayaranSPPnLnd!.fold(0, (sum, item) => sum + item.totalNominal);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kPrimaryColor),
        title: const Text(
          'Lihat Pembayaran SPP',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: kPrimaryColor),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : pembayaranSPPnLnd!.isEmpty
              ? const Center(
                  child: Text('tidak ada data'),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: pembayaranSPPnLnd!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(10)),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.book,
                                          size: 30.0,
                                        ),
                                        SizedBox(
                                            width: getProportionateScreenWidth(
                                                25)),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Nama Tagihan',
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              'Bulan Februari',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(10)),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          size: 30.0,
                                        ),
                                        SizedBox(
                                            width: getProportionateScreenWidth(
                                                25)),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tahun Akademik',
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              '2022/2023',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(10)),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month,
                                          size: 30.0,
                                        ),
                                        SizedBox(
                                            width: getProportionateScreenWidth(
                                                25)),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tanggal Bayar',
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              '11 Januari 2021',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            getProportionateScreenHeight(10)),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.wallet,
                                          size: 30.0,
                                        ),
                                        SizedBox(
                                            width: getProportionateScreenWidth(
                                                25)),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Jumlah Tagihan',
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              '${CurencyIdr.convertToIdr(250000, 2)}',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(10),
                                    ),
                                    ExpansionTile(
                                      title: const Text("Lihat Detail"),
                                      children: [
                                        Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                    "SPP",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.grey),
                                                  )),
                                                  Expanded(
                                                      child: Text(
                                                    "${CurencyIdr.convertToIdr(250000, 2)}",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    textAlign: TextAlign.right,
                                                  )),
                                                ],
                                              ),
                                            ),
                                            // Tambahkan lebih banyak Row atau widget lain jika diperlukan
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      })),
    );
    ;
  }
}
