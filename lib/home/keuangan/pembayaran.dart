import 'dart:convert';

import 'package:android_smartscholl/core/client/dio_client.dart';
import 'package:android_smartscholl/helper/constant.dart';
import 'package:android_smartscholl/helper/currencyIdr.dart';
import 'package:android_smartscholl/helper/sizeConfig.dart';
import 'package:android_smartscholl/models/detailPembayaranModel.dart';
import 'package:android_smartscholl/models/pembayaranModel.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:need_resume/need_resume.dart';

class Pembayaran extends StatefulWidget {
  const Pembayaran({Key? key}) : super(key: key);

  @override
  _PembayaranState createState() => _PembayaranState();
}

class _PembayaranState extends ResumableState<Pembayaran> {
  bool isLoading = false;
  var pembayaranData;
  int totalDetailPembayaran = 0;
  List<PembayaranModel>? pembayaranLnd = [];
  List<DetailPembayaranModel>? detailPembayaranLnd = [];

  var totalPembayaran = 0;

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
      'METHOD': 'PaymentRequest',
      'USERNAME': username,
      'PASSWORD': password,
    });
    final tagihanJwt = jwtTagihan.sign(SecretKey("TokenJWT_MOBILE_ICT"));
    var responseTagihan = await DioClient()
        .apiCall(url: '?token=$tagihanJwt', requestType: RequestType.get);
    var arrResponseTagihan = jsonDecode(responseTagihan.toString());
    if (arrResponseTagihan['KodeResponse'] == 0 ||
        arrResponseTagihan['KodeResponse'] == '0') {
      pembayaranData = arrResponseTagihan['datas'] as List;
    }
    setState(() {
      if (arrResponseTagihan['KodeResponse'] == 0 ||
          arrResponseTagihan['KodeResponse'] == '0') {
        pembayaranLnd = pembayaranLnd! +
            (pembayaranData as List<dynamic>).map((element) {
              var detailPembayaranData = element['det'] as List<dynamic>;
              List<DetailPembayaranModel> detailPembayaranList =
                  detailPembayaranData
                      .map(
                        (detailElement) => DetailPembayaranModel(
                          kodePost: detailElement['KodePost'].toString(),
                          namaPost: detailElement['NamaPost'].toString(),
                          detailNominal: int.parse(
                              detailElement['DetailNominal']
                                  .replaceAll('.', '')),
                        ),
                      )
                      .toList();

              String inputDate = element['TanggalBayar'].toString();
              DateTime parsedDate = DateTime.parse(inputDate);
              String formattedDate =
                  DateFormat('d MMMM yyyy, HH:mm').format(parsedDate);
              return PembayaranModel(
                namaTagihan: element['NamaTagihan'].toString(),
                tahunAkademik: element['TahunAkademik'].toString(),
                tanggalBayar: formattedDate.toString(),
                totalNominal: int.parse(element['TotalNominal']),
                detailPembayaran: detailPembayaranList,
              );
            }).toList();

        totalPembayaran =
            pembayaranLnd!.fold(0, (sum, item) => sum + item.totalNominal);
      }

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kPrimaryColor),
        title: const Text(
          'Lihat Pembayaran',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: kPrimaryColor),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: pembayaranLnd!.length > 0
                  ? ListView.builder(
                      itemCount: pembayaranLnd!.length,
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Nama Tagihan',
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              '${pembayaranLnd![index].namaTagihan}',
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500,
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
                                        Column(
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
                                              '${pembayaranLnd![index].tahunAkademik}',
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500,
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
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Tanggal Bayar',
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              '${pembayaranLnd![index].tanggalBayar}',
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500,
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
                                            const Text(
                                              'Jumlah Tagihan',
                                              style: TextStyle(
                                                  fontSize: 17.0,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              '${CurencyIdr.convertToIdr(pembayaranLnd![index].totalNominal, 2)}',
                                              style: const TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.w500,
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
                                        ListView.builder(
                                            itemCount: pembayaranLnd![index]
                                                .detailPembayaran
                                                .length,
                                            shrinkWrap: true,
                                            itemBuilder: (contexX, indexX) {
                                              return Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                          "${pembayaranLnd![index].detailPembayaran[indexX].namaPost}",
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              color: Colors
                                                                  .grey[600],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )),
                                                        Expanded(
                                                            child: Text(
                                                          "${CurencyIdr.convertToIdr(pembayaranLnd![index].detailPembayaran[indexX].detailNominal, 2)}",
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.right,
                                                        )),
                                                      ],
                                                    ),
                                                  ),
                                                  // Tambahkan lebih banyak Row atau widget lain jika diperlukan
                                                ],
                                              );
                                            })
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                  : Center(child: Text('Tidak Ada Data'))),
    );
  }
}
