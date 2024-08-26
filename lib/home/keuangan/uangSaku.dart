import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mbs_klaten/core/client/dio_client.dart';
import 'package:mbs_klaten/helper/constant.dart';
import 'package:mbs_klaten/helper/currencyIdr.dart';
import 'package:mbs_klaten/helper/sizeConfig.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbs_klaten/models/transaksiModel.dart';
import 'package:need_resume/need_resume.dart'; // tambahkan package intl

final today = DateUtils.dateOnly(DateTime.now());

class UangSaku extends StatefulWidget {
  @override
  State<UangSaku> createState() => _UangSakuState();
}

class _UangSakuState extends ResumableState<UangSaku> {
  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime.now(),
    DateTime.now(),
  ];
  DateTime? startDate;
  DateTime? endDate;

  bool isLoading = false;
  List<TransaksiModel>? transaksiLnd = [];
  var transaksi;
  int page = 1;
  bool isPaginate = false;
  int totalSaldo = 0;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _dialogCalendarPickerValue[0] = DateTime(
      _dialogCalendarPickerValue[0]!.year,
      _dialogCalendarPickerValue[0]!.month - 1,
      _dialogCalendarPickerValue[0]!.day,
    );
    _dialogCalendarPickerValue[1] = DateTime(
      _dialogCalendarPickerValue[1]!.year,
      _dialogCalendarPickerValue[1]!.month,
      _dialogCalendarPickerValue[1]!.day,
    );
    if (_dialogCalendarPickerValue.isNotEmpty) {
      startDate = _dialogCalendarPickerValue[0];
      endDate = _dialogCalendarPickerValue.length > 1
          ? _dialogCalendarPickerValue[1]
          : null;
    }
  }

  @override
  void onReady() {
    super.onReady();
    getList();
    scrollController.addListener(_scrolListener);
  }

  @override
  void onResume() {
    super.onResume();
    getList();
    scrollController.addListener(_scrolListener);
  }

  Future<void> getList() async {
    setState(() {
      page = 1;
      isLoading = true;
    });
    final dataMhs = await Hive.openBox('myToken');
    var password = dataMhs.get('password');
    var username = dataMhs.get('username');

    final jwtTagihan = JWT({
      'METHOD': 'TransaksiRequest',
      'USERNAME': username,
      'PASSWORD': password,
      'startDate': '${startDate}',
      'endDate': '${endDate}',
    });
    final transaksiJwt = jwtTagihan.sign(SecretKey("TokenJWT_MOBILE_ICT"));
    var responseTransaksi = await DioClient().apiCall(
        url: '?page=$page&token=$transaksiJwt', requestType: RequestType.get);
    var arrresponseTransaksi = jsonDecode(responseTransaksi.toString());
    transaksi = arrresponseTransaksi['datas'] as List;

    setState(() {
      transaksiLnd = (transaksi as List<dynamic>).map((element) {
        String inputDate = element['TGL'].toString();
        DateTime parsedDate = DateTime.parse(inputDate);
        String formattedDate =
            DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(parsedDate);
        return TransaksiModel(
          debit: int.parse(element['DEBET'].replaceAll('.', '')),
          kredit: int.parse(element['KREDIT'].replaceAll('.', '')),
          trxDate: formattedDate,
          keterangan: element['KETERANGAN'].toString(),
        );
      }).toList();
      totalSaldo = arrresponseTransaksi['total'] == null
          ? 0
          : int.parse(arrresponseTransaksi['total']);
      isLoading = false;
    });
  }

  Future<void> getPaginate() async {
    setState(() {
      isPaginate = true;
    });
    final dataMhs = await Hive.openBox('myToken');
    var password = dataMhs.get('password');
    var username = dataMhs.get('username');
    final jwtTagihan = JWT({
      'METHOD': 'TransaksiRequest',
      'USERNAME': username,
      'PASSWORD': password,
      'startDate': '${startDate}',
      'endDate': '${endDate}',
    });
    final transaksiJwt = jwtTagihan.sign(SecretKey("TokenJWT_MOBILE_ICT"));
    var responseTransaksi = await DioClient().apiCall(
        url: '?page=$page&token=$transaksiJwt', requestType: RequestType.get);
    var arrresponseTransaksi = jsonDecode(responseTransaksi.toString());
    transaksi = arrresponseTransaksi['datas'] as List;

    setState(() {
      transaksiLnd = transaksiLnd! +
          (transaksi as List<dynamic>).map((element) {
            String inputDate = element['TGL'].toString();
            DateTime parsedDate = DateTime.parse(inputDate);
            String formattedDate =
                DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(parsedDate);
            return TransaksiModel(
              debit: int.parse(element['DEBET'].replaceAll('.', '')),
              kredit: int.parse(element['KREDIT'].replaceAll('.', '')),
              trxDate: formattedDate,
              keterangan: element['KETERANGAN'].toString(),
            );
          }).toList();
      totalSaldo = int.parse(arrresponseTransaksi['total']);

      isPaginate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kPrimaryColor),
        title: const Text(
          "Lihat Transaksi Uang Saku",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: kPrimaryColor),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Card(
              child: Container(
                height: getProportionateScreenHeight(150),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: getProportionateScreenHeight(15)),
                      child: Text(
                        CurencyIdr.convertToIdr(totalSaldo, 0),
                        style: const TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                            child: Center(
                                child: Text(
                          'Dari Tanggal',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ))),
                        Expanded(child: _buildCalendarDialogButton()),
                        const Expanded(
                            child: Center(
                                child: Text(
                          'Ke Tanggal',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Center(
                                child: Text(
                          '${startDate != null ? DateFormat('dd MMMM yyyy', 'id_ID').format(startDate!) : 'not set'}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ))),
                        Expanded(
                            child: Center(
                                child: Text(
                          '${endDate != null ? DateFormat('dd MMMM yyyy', 'id_ID').format(endDate!) : 'not set'}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ))),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
                height: getProportionateScreenHeight(540),
                padding: const EdgeInsets.all(8.0),
                child: !isLoading
                    ? RefreshIndicator(
                        onRefresh: getList,
                        child: Container(
                          child: ListView.builder(
                              itemCount: transaksiLnd!.length,
                              controller: scrollController,
                              shrinkWrap: true,
                              itemBuilder:
                                  // if (transaksiLnd )
                                  (context, index) {
                                if (index < transaksiLnd!.length) {
                                  return Card(
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
                                                  Text(
                                                    transaksiLnd![index]
                                                        .keterangan,
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    transaksiLnd![index]
                                                        .trxDate,
                                                    style: const TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              Spacer(),
                                              transaksiLnd![index].debit == 0
                                                  ? Text(
                                                      CurencyIdr.convertToIdr(
                                                          transaksiLnd![index]
                                                                  .kredit -
                                                              transaksiLnd![
                                                                      index]
                                                                  .debit,
                                                          0),
                                                      style: const TextStyle(
                                                          color: Colors.green),
                                                    )
                                                  : Text(
                                                      "- ${CurencyIdr.convertToIdr(transaksiLnd![index].debit - transaksiLnd![index].kredit, 0)}",
                                                      style: const TextStyle(
                                                          color: Colors.red),
                                                    ),
                                              SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          10))
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                getProportionateScreenHeight(
                                                    10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              }),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ))
          ],
        ),
      ),
    );
  }

  _buildCalendarDialogButton() {
    const dayTextStyle =
        TextStyle(color: Colors.black, fontWeight: FontWeight.w700);
    final weekendTextStyle =
        TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600);
    final anniversaryTextStyle = TextStyle(
      color: Colors.red[400],
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
    );
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarViewScrollPhysics: const NeverScrollableScrollPhysics(),
      dayTextStyle: dayTextStyle,
      calendarType: CalendarDatePicker2Type.range,
      selectedDayHighlightColor: Colors.purple[800],
      closeDialogOnCancelTapped: true,
      firstDayOfWeek: 1,
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      centerAlignModePicker: true,
      customModePickerIcon: const SizedBox(),
      selectedDayTextStyle: dayTextStyle.copyWith(color: Colors.white),
      dayTextStylePredicate: ({required date}) {
        TextStyle? textStyle;
        if (date.weekday == DateTime.saturday ||
            date.weekday == DateTime.sunday) {
          textStyle = weekendTextStyle;
        }
        if (DateUtils.isSameDay(date, DateTime(2021, 1, 25))) {
          textStyle = anniversaryTextStyle;
        }
        return textStyle;
      },
      dayBuilder: ({
        required date,
        textStyle,
        decoration,
        isSelected,
        isDisabled,
        isToday,
      }) {
        Widget? dayWidget;
        if (date.day % 3 == 0 && date.day % 9 != 0) {
          dayWidget = Container(
            decoration: decoration,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Text(
                    MaterialLocalizations.of(context).formatDecimal(date.day),
                    style: textStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 27.5),
                    child: Container(
                      height: 4,
                      width: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: isSelected == true
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return dayWidget;
      },
      yearBuilder: ({
        required year,
        decoration,
        isCurrentYear,
        isDisabled,
        isSelected,
        textStyle,
      }) {
        return Center(
          child: Container(
            decoration: decoration,
            height: 36,
            width: 72,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: textStyle,
                    ),
                    if (isCurrentYear == true)
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final values = await showCalendarDatePicker2Dialog(
                  context: context,
                  config: config,
                  dialogSize: const Size(325, 370),
                  borderRadius: BorderRadius.circular(15),
                  value: _dialogCalendarPickerValue,
                  dialogBackgroundColor: Colors.white,
                );
                if (values != null) {
                  setState(() {
                    _dialogCalendarPickerValue = values;
                    if (_dialogCalendarPickerValue.isNotEmpty) {
                      startDate = _dialogCalendarPickerValue[0];
                      endDate = _dialogCalendarPickerValue.length >= 1
                          ? _dialogCalendarPickerValue[1]
                          : null;
                    } else {
                      startDate = null;
                      endDate = null;
                    }
                  });
                }
                getList();
              },
              child: Text('pilih tanggal'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scrolListener() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isPaginate = true;
        page = page + 1;
      });
      getPaginate();
      print("atah");
      print("${page}");
      setState(() {
        isPaginate = false;
      });
    }
  }
}
