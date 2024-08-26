import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:mbs_klaten/bottomNavigation.dart';
import 'package:mbs_klaten/core/client/dio_client.dart';
import 'package:mbs_klaten/helper/constant.dart';
import 'package:mbs_klaten/helper/currencyIdr.dart';
import 'package:mbs_klaten/helper/sizeConfig.dart';
import 'package:mbs_klaten/models/detailPembayaranSPPModel.dart';
import 'package:mbs_klaten/models/pembayaranSPPModel.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:need_resume/need_resume.dart';

class infaqDanTabungan extends StatefulWidget {
  const infaqDanTabungan({Key? key}) : super(key: key);

  @override
  _infaqDanTabunganState createState() => _infaqDanTabunganState();
}

class _infaqDanTabunganState extends ResumableState<infaqDanTabungan> {
  final GlobalKey<FormState> _tabunganForm = GlobalKey<FormState>();
  final GlobalKey<FormState> _infaqForm = GlobalKey<FormState>();
  TextEditingController tvNominalTabungan = TextEditingController();
  TextEditingController tvNominalInfaq = TextEditingController();
  bool btnTabungan = false;
  bool btnInfaq = false;

  @override
  Widget build(BuildContext context) {
    final nominalTabungan = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      controller: tvNominalTabungan,
      decoration: InputDecoration(
        hintText: 'Nominal Tabungan',
        labelText: "Nominal Tabungan",
        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) {
            final Color color = states.contains(MaterialState.error)
                ? Theme.of(context).colorScheme.error
                : kPrimaryColor;
            return TextStyle(color: color, letterSpacing: 1.3);
          },
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 230, 230, 230),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: const Icon(Icons.tab, color: kPrimaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 230, 230, 230),
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == "") {
          return "Nominal Harus di isi";
        }
      },
    );

    final tabunganButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            if (_tabunganForm.currentState!.validate()) {
              var token = await Hive.openBox('myToken');
              var password = token.get('password');
              var username = token.get('username');
              try {
                setState(() {
                  btnTabungan = true;
                });
                final jwt = JWT({
                  'METHOD': 'PaymentExeTabungan',
                  'USERNAME': username,
                  'PASSWORD': password,
                  'NOMINAL': tvNominalTabungan.text,
                });
                final token = jwt.sign(SecretKey("TokenJWT_MOBILE_ICT"));
                var response = await DioClient().apiCall(
                    url: '?token=$token', requestType: RequestType.get);
                var arrResponse = jsonDecode(response.toString());
                var message = arrResponse[0]['RESULT'];
                if (arrResponse[0]['STATUS'] == 'OK') {
                  setState(() {
                    btnTabungan = false;
                  });

                  Fluttertoast.showToast(
                      msg: 'Terimakasih sudah Menabung',
                      backgroundColor: Colors.green,
                      webBgColor: "linear-gradient(to right, #f44336, #ff9800)",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => Bottomvavigation()));
                } else {
                  Fluttertoast.showToast(
                      msg: message,
                      backgroundColor: Colors.red,
                      webBgColor: "linear-gradient(to right, #f44336, #ff9800)",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  setState(() {
                    btnTabungan = false;
                  });
                }
              } catch (e) {
                setState(() {
                  btnTabungan = false;
                });
              }
            }
          },
          padding: const EdgeInsets.all(10),
          color: kPrimaryColor,
          child: btnTabungan
              ? const CircularProgressIndicator()
              : const Text('Tabungan',
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)))),
    );
    final nominalInfaq = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      controller: tvNominalInfaq,
      decoration: InputDecoration(
        hintText: 'Nominal Infaq',
        labelText: "Nominal Infaq",
        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) {
            final Color color = states.contains(MaterialState.error)
                ? Theme.of(context).colorScheme.error
                : kPrimaryColor;
            return TextStyle(color: color, letterSpacing: 1.3);
          },
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 230, 230, 230),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: const Icon(Icons.wallet_rounded, color: kPrimaryColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 230, 230, 230),
            width: 2.0,
          ),
        ),
      ),
      validator: (value) {
        if (value == "") {
          return "Nominal Harus di isi";
        }
      },
      // onSaved: (value) => _email = value,
    );

    final infaqButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            setState(() {
              btnInfaq = true;
            });
            if (_infaqForm.currentState!.validate()) {
              var token = await Hive.openBox('myToken');
              var password = token.get('password');
              var username = token.get('username');
              try {
                final jwt = JWT({
                  'METHOD': 'PaymentExeInfaq',
                  'USERNAME': username,
                  'PASSWORD': password,
                  'NOMINAL': tvNominalInfaq.text,
                });
                final token = jwt.sign(SecretKey("TokenJWT_MOBILE_ICT"));
                var response = await DioClient().apiCall(
                    url: '?token=$token', requestType: RequestType.get);
                var arrResponse = jsonDecode(response.toString());
                var message = arrResponse[0]['RESULT'];
                if (arrResponse[0]['STATUS'] == 'OK') {
                  setState(() {
                    btnInfaq = false;
                  });

                  Fluttertoast.showToast(
                      msg: 'Terimakasih sudah Infaq',
                      backgroundColor: Colors.green,
                      webBgColor: "linear-gradient(to right, #f44336, #ff9800)",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  Fluttertoast.showToast(
                      msg: message,
                      backgroundColor: Colors.red,
                      webBgColor: "linear-gradient(to right, #f44336, #ff9800)",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      textColor: Colors.white,
                      fontSize: 16.0);

                  setState(() {
                    btnInfaq = false;
                  });
                }
                setState(() {
                  btnInfaq = false;
                });
              } catch (e) {
                setState(() {
                  btnInfaq = false;
                });
              }
            }
          },
          padding: const EdgeInsets.all(10),
          color: kPrimaryColor,
          child: btnInfaq
              ? const CircularProgressIndicator()
              : const Text('Infaq',
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)))),
    );
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kPrimaryColor),
        title: const Text(
          'Infaq dan Tabungan',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: kPrimaryColor),
        ),
      ),
      body: Scaffold(
          backgroundColor: Colors.white,
          extendBodyBehindAppBar: true,
          body: ListView(
            padding: const EdgeInsets.all(25.0),
            children: <Widget>[
              const SizedBox(height: 40.0),
              Form(
                child: nominalTabungan,
                key: _tabunganForm,
              ),
              tabunganButton,
              const SizedBox(height: 40),
              Form(
                child: nominalInfaq,
                key: _infaqForm,
              ),
              infaqButton,
              // toRegisterLabel
            ],
          )),
    );
  }
}
