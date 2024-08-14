import 'dart:convert';
import 'dart:io';

import 'package:android_smartscholl/bottomNavigation.dart';
import 'package:android_smartscholl/core/client/dio_client.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:android_smartscholl/helper/constant.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController tvUsername = TextEditingController();
  TextEditingController tvPassword = TextEditingController();
  bool _obscureText = true;
  bool isSuccess = false;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gambar = Hero(
      tag: 'logoict',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 100.0,
        child: Image.asset(
          'assets/images/diesel.png',
          width: 200,
          height: 200,
        ),
      ),
    );
    final username = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: tvUsername,
      decoration: InputDecoration(
        hintText: 'Masukkan Nomor Induk Koperasi',
        labelText: "Nomor Induk Koperasi",
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
        prefixIcon: const Icon(Icons.person, color: kPrimaryColor),
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
    );
    final password = TextFormField(
      autofocus: false,
      controller: tvPassword,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Masukkan Password Anda',
        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) {
            final Color color = states.contains(MaterialState.error)
                ? Theme.of(context).colorScheme.error
                : kPrimaryColor;
            return TextStyle(color: color, letterSpacing: 1.3);
          },
        ),
        // contentPadding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),

        filled: true,
        fillColor: const Color.fromARGB(255, 230, 230, 230),
        prefixIcon: const Icon(Icons.key, color: kPrimaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _togglePasswordVisibility,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: kPrimaryColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 230, 230, 230),
            width: 2.0,
          ),
        ),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            try {
              setState(() {
                isSuccess = true;
              });
              final jwt = JWT({
                'METHOD': 'LoginRequest',
                'USERNAME': tvUsername.text,
                'PASSWORD': tvPassword.text,
              });
              final token = jwt.sign(SecretKey("TokenJWT_MOBILE_ICT"));
              var response = await DioClient()
                  .apiCall(url: '?token=$token', requestType: RequestType.get);
              var arrResponse = jsonDecode(response.toString());
              var message = arrResponse['PesanRespon'];
              print(arrResponse['KodeRespon']);
              if (arrResponse['KodeRespon'] == 1) {
                setState(() {
                  isSuccess = false;
                });
                final boxToken = await Hive.openBox('myToken');
                boxToken.put('mahasiswa', arrResponse['Mahasiswa']);
                boxToken.put('jenjang', arrResponse['Jenjang']);
                boxToken.put('kelas', arrResponse['Kelas']);
                boxToken.put('kelompok', arrResponse['Kelompok']);
                boxToken.put('nova', arrResponse['NOVA']);
                boxToken.put('novasaku', arrResponse['NOVASAKU']);
                boxToken.put('keterangan', arrResponse['Keterangan']);
                boxToken.put('username', tvUsername.text);
                boxToken.put('password', tvPassword.text);

                Fluttertoast.showToast(
                    msg: "Berhasil Login",
                    backgroundColor: Colors.green,
                    webBgColor: "linear-gradient(to right, #f44336, #ff9800)",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    textColor: Colors.white,
                    fontSize: 16.0);

                print(boxToken.get('password'));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Bottomvavigation()));
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
                  isSuccess = false;
                });
              }
            } catch (e) {}
          },
          padding: const EdgeInsets.all(20),
          color: kPrimaryColor,
          child: isSuccess
              ? CircularProgressIndicator()
              : Text('LOGIN',
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)))),
    );

    const title = Text(
      style: TextStyle(fontSize: 30),
      textAlign: TextAlign.center,
      'SEKOLAH',
    );

    return WillPopScope(
        onWillPop: () async {
          // Menampilkan dialog konfirmasi sebelum keluar aplikasi
          exit(0); // Mencegah navigasi kembali
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            body: ListView(
              padding: const EdgeInsets.all(25.0),
              children: <Widget>[
                const SizedBox(height: 200.0),
                // gitar,
                // SizedBox(height: 108.0),
                gambar,
                title,
                const SizedBox(height: 40.0),
                username,
                const SizedBox(height: 20.0),
                password,
                const SizedBox(height: 24.0),
                loginButton,
                // toRegisterLabel
              ],
            ),
          ),
        ));
  }
}
