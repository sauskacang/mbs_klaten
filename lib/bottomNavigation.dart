import 'dart:io';

import 'package:android_smartscholl/helper/constant.dart';
import 'package:android_smartscholl/helper/sizeConfig.dart';
import 'package:android_smartscholl/home/homeScreen.dart';
import 'package:android_smartscholl/home/kuangan.dart';
import 'package:android_smartscholl/home/notification/notif.dart';
import 'package:android_smartscholl/login.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class Bottomvavigation extends StatefulWidget {
  const Bottomvavigation({Key? key}) : super(key: key);

  @override
  _BottomvavigationState createState() => _BottomvavigationState();
}

class _BottomvavigationState extends State<Bottomvavigation> {
  int _selectedIndex = 0;
  static const List _pages = [
    HomeScreen(),
    Keuangan(),
    Icon(
      Icons.chat,
      size: 150,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Menampilkan dialog konfirmasi sebelum keluar aplikasi
          bool shouldExit = await _showExitConfirmationDialog(context);
          if (shouldExit) {
            exit(0); // Keluar dari aplikasi
          }
          return false; // Mencegah navigasi kembali
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(5)),
                child: Image.asset('assets/images/diesel.png')),
            title: const Text(
              'Sekolah Diesel',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  color: kPrimaryColor),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notif()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  _showLogoutConfirmationDialog(context);
                },
              ),
            ],
          ),
          body: Center(
            child: _pages.elementAt(_selectedIndex), //New
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wallet),
                label: 'Keuangan',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                ),
                label: 'Chats',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: kPrimaryColor, // Warna label saat aktif
            onTap: _onItemTapped,
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Keluar App'),
            content: Text('Apakah anda yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Tidak'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Ya'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Keluar'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('Keluar'),
              onPressed: () async {
                final boxToken = await Hive.openBox('myToken');
                await boxToken.clear();
                exit(0);
              },
            ),
          ],
        );
      },
    );
  }
}
