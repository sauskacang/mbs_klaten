import 'package:android_smartscholl/bottomNavigation.dart';
import 'package:android_smartscholl/helper/sizeConfig.dart';
import 'package:android_smartscholl/home/homeScreen.dart';
import 'package:android_smartscholl/login.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CheckingAuth extends StatefulWidget {
  const CheckingAuth({Key? key}) : super(key: key);

  @override
  _CheckingAuthState createState() => _CheckingAuthState();
}

class _CheckingAuthState extends State<CheckingAuth> {
  @override
  void initState() {
    super.initState();
    loginChecking();
    Hive.openBox('myToken');
  }

  @override
  void dispose() {
    // Closes all Hive boxes
    super.dispose();
  }

  Future<void> loginChecking() async {
    final mahasiswa = await Hive.openBox('myToken');
    print(mahasiswa);
    if (mahasiswa.isNotEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Bottomvavigation()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/diesel.png',
              fit: BoxFit.cover,
              height: getProportionateScreenHeight(70),
              width: getProportionateScreenWidth(70),
            ),
            SizedBox(
              height: getProportionateScreenHeight(50),
            ),
            const Text(
              "checking Auth",
              style: TextStyle(
                fontSize: 19,
              ),
            ),
            SizedBox(
              height: getProportionateScreenWidth(50),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
