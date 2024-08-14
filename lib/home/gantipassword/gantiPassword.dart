import 'dart:convert';

import 'package:android_smartscholl/bottomNavigation.dart';
import 'package:android_smartscholl/core/client/dio_client.dart';
import 'package:android_smartscholl/helper/constant.dart';
import 'package:android_smartscholl/login.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:need_resume/need_resume.dart';

class GantiPassword extends StatefulWidget {
  const GantiPassword({Key? key}) : super(key: key);

  @override
  _GantiPasswordState createState() => _GantiPasswordState();
}

class _GantiPasswordState extends ResumableState<GantiPassword> {
  bool _obscureText = true;
  bool _obscureTextConfirmation = true;
  bool isSuccess = false;
  TextEditingController tvPasswordConfirmation = TextEditingController();
  TextEditingController tvPassword = TextEditingController();
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _togglePasswordConfirmation() {
    setState(() {
      _obscureTextConfirmation = !_obscureTextConfirmation;
    });
  }

  @override
  Widget build(BuildContext context) {
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

    final passwordConfirmation = TextFormField(
      autofocus: false,
      controller: tvPasswordConfirmation,
      obscureText: _obscureTextConfirmation,
      decoration: InputDecoration(
        labelText: 'Konfirmasi Password',
        hintText: 'Masukkan Password Kinfirmasi Anda',
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
            _obscureTextConfirmation ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: _togglePasswordConfirmation,
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

    final changeButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            try {
              setState(() {
                isSuccess = true;
              });
              var openBox = await Hive.openBox('myToken');
              var password = openBox.get('password');
              var username = openBox.get('username');
              final jwt = JWT({
                'METHOD': 'RequestNewPassword',
                'NEWPASSWORD2': tvPasswordConfirmation.text,
                'NEWPASSWORD': tvPassword.text,
                'PASSWORD': password,
                'USERNAME': username,
              });
              final token = jwt.sign(SecretKey("TokenJWT_MOBILE_ICT"));
              var response = await DioClient()
                  .apiCall(url: '?token=$token', requestType: RequestType.get);
              var arrResponse = jsonDecode(response.toString());
              var message = arrResponse['PesanRespon'];
              if (arrResponse['KodeRespon'] == 1) {
                setState(() {
                  isSuccess = false;
                });

                Fluttertoast.showToast(
                    msg: "Silahkan Login Ulang",
                    backgroundColor: Colors.green,
                    webBgColor: "linear-gradient(to right, #f44336, #ff9800)",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    textColor: Colors.white,
                    fontSize: 16.0);
                final boxToken = await Hive.openBox('myToken');
                await boxToken.clear();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
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
            } catch (e) {
              setState(() {
                isSuccess = false;
              });
            }
          },
          padding: const EdgeInsets.all(20),
          color: kPrimaryColor,
          child: isSuccess
              ? const CircularProgressIndicator()
              : const Text('Ganti Password',
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)))),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ganti Password',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: kPrimaryColor),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(25),
        children: [
          const SizedBox(height: 15.0),
          password,
          const SizedBox(height: 24.0),
          passwordConfirmation,
          const SizedBox(height: 24.0),
          changeButton
        ],
      ),
    );
  }
}
