import 'package:android_smartscholl/helper/constant.dart';
import 'package:android_smartscholl/helper/currencyIdr.dart';
import 'package:android_smartscholl/helper/sizeConfig.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:need_resume/need_resume.dart'; // tambahkan package intl

final today = DateUtils.dateOnly(DateTime.now());

class UangSaku extends StatefulWidget {
  @override
  State<UangSaku> createState() => _UangSakuState();
}

class _UangSakuState extends ResumableState<UangSaku> {
  List<DateTime?> _dialogCalendarPickerValue = [
    DateTime(2021, 8, 10),
    DateTime(2021, 8, 13),
  ];
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    if (_dialogCalendarPickerValue.isNotEmpty) {
      startDate = _dialogCalendarPickerValue[0];
      endDate = _dialogCalendarPickerValue.length > 1
          ? _dialogCalendarPickerValue[1]
          : null;
    }
  }

  void getList() {}

  var test = [];
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
                        "${CurencyIdr.convertToIdr(10000, 2)},",
                        style: TextStyle(
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
                          '${startDate != null ? DateFormat('MMM, dd yyyy').format(startDate!) : 'not set'}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ))),
                        Expanded(
                            child: Center(
                                child: Text(
                          '${endDate != null ? DateFormat('MMM, dd yyyy').format(endDate!) : 'not set'}',
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
                      endDate = _dialogCalendarPickerValue.length > 1
                          ? _dialogCalendarPickerValue[1]
                          : null;
                    } else {
                      startDate = null;
                      endDate = null;
                    }
                  });
                }
              },
              child: Text('pilih tanggal'),
            ),
          ],
        ),
      ),
    );
  }
}
