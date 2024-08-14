import 'dart:convert';

import 'package:android_smartscholl/core/client/dio_client.dart';
import 'package:android_smartscholl/helper/constant.dart';
import 'package:android_smartscholl/helper/currencyIdr.dart';
import 'package:android_smartscholl/helper/sizeConfig.dart';
import 'package:android_smartscholl/models/detailTagihanModel.dart';
import 'package:android_smartscholl/models/tagihanModel.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:need_resume/need_resume.dart';

class LihatTagihan extends StatefulWidget {
  const LihatTagihan({Key? key}) : super(key: key);

  @override
  _LihatTagihanState createState() => _LihatTagihanState();
}

class _LihatTagihanState extends ResumableState<LihatTagihan> {
  bool isLoading = false;
  var tagihanData;
  int totalDetailTagihan = 0;
  List<TagihanModel>? tagihanLnd = [];
  List<DetailTagihanModel>? detailTagihanLnd = [];

  var totalTagihan = 0;

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
    }
    setState(() {
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

      totalTagihan =
          tagihanLnd!.fold(0, (sum, item) => sum + item.totalNominal);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kPrimaryColor),
        title: const Text(
          'Lihat Tagihan',
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
              child: Column(
                children: [
                  Card(
                    color: kPrimaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.monetization_on,
                            size: 50.0,
                            color: Colors.white,
                          ),
                          SizedBox(width: getProportionateScreenWidth(25)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sisa Tagihan 1 Tahun',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${CurencyIdr.convertToIdr(totalTagihan, 2)}',
                                style: const TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                        itemCount: tagihanLnd!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              tagihanLnd!.length > 0
                                  ? Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.book,
                                                  size: 30.0,
                                                ),
                                                SizedBox(
                                                    width:
                                                        getProportionateScreenWidth(
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
                                                      '${tagihanLnd![index].namaTagihan}',
                                                      style: const TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_month,
                                                  size: 30.0,
                                                ),
                                                SizedBox(
                                                    width:
                                                        getProportionateScreenWidth(
                                                            25)),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Tahun Akademik',
                                                      style: TextStyle(
                                                          fontSize: 17.0,
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      '${tagihanLnd![index].tahunAkademik}',
                                                      style: const TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        10)),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.wallet,
                                                  size: 30.0,
                                                ),
                                                SizedBox(
                                                    width:
                                                        getProportionateScreenWidth(
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
                                                      '${CurencyIdr.convertToIdr(tagihanLnd![index].totalNominal, 2)}',
                                                      style: const TextStyle(
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      10),
                                            ),
                                            ExpansionTile(
                                              title: const Text("Lihat Detail"),
                                              children: [
                                                ListView.builder(
                                                    itemCount:
                                                        tagihanLnd![index]
                                                            .detailTagihan
                                                            .length,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (contextT, indexX) {
                                                      return Column(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            Text(
                                                                      "${tagihanLnd![index].detailTagihan[indexX].namaPost}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          color:
                                                                              Colors.grey),
                                                                    )),
                                                                    Expanded(
                                                                        child:
                                                                            Text(
                                                                      "${CurencyIdr.convertToIdr(tagihanLnd![index].detailTagihan[indexX].detailNominal, 2)}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    )),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Detail for'),
                                                          content: Text(
                                                              'This is some detailed information for.'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child:
                                                                  Text('Close'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Text('View'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : const Center(
                                      child: Text('tidak ada data'),
                                    )
                            ],
                          );
                        }),
                  ),
                ],
              )),
    );
  }
}
