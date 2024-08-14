import 'package:android_smartscholl/helper/constant.dart';
import 'package:android_smartscholl/home/keuangan/lihatTagihan.dart';
import 'package:android_smartscholl/home/keuangan/panduanPembayaran.dart';
import 'package:android_smartscholl/home/keuangan/pembayaran.dart';
import 'package:android_smartscholl/home/keuangan/transaksiSpp.dart';
import 'package:android_smartscholl/home/keuangan/uangSaku.dart';
import 'package:android_smartscholl/login.dart';
import 'package:flutter/material.dart';

class Keuangan extends StatelessWidget {
  const Keuangan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 5, top: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LihatTagihan()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27),
                        ),
                        elevation: 5,
                        color: Colors.red,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          height: 1 / 5 * MediaQuery.of(context).size.height,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_sharp,
                                size: 50,
                                color: Colors.white,
                              ),
                              Text(
                                'Lihat Tagihan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 5, top: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Pembayaran()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                      elevation: 5,
                      color: Colors.blue,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        height: 1 / 5 * MediaQuery.of(context).size.height,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wallet,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              'Pembayaran',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 5, top: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransaksiSpp()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27),
                        ),
                        elevation: 5,
                        color: Colors.yellow,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          height: 1 / 5 * MediaQuery.of(context).size.height,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.money,
                                size: 50,
                                color: Colors.white,
                              ),
                              Text(
                                'Lihat Transaksi \n SPP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 5, top: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => UangSaku()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                      elevation: 5,
                      color: Colors.green,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        height: 1 / 5 * MediaQuery.of(context).size.height,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.store,
                              size: 50,
                              color: Colors.white,
                            ),
                            Text(
                              'Lihat Transaksi \n Uang Saku',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                    margin: const EdgeInsets.only(left: 5, top: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PanduanPembayaran()));
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27),
                        ),
                        elevation: 5,
                        color: Colors.grey,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          height: 1 / 5 * MediaQuery.of(context).size.height,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.book,
                                size: 50,
                                color: Colors.white,
                              ),
                              Text(
                                'Panduan Pembayaran',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
