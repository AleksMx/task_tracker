import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_tracker/services/LocalizationService.dart';

enum PlatformType {
  web,
  android,
  ios,
  unknown
}

class Utils {
  static int getTime() {
    return (DateTime
        .now()
        .millisecondsSinceEpoch / 1000).round();
  }

  static int getTimeMs() {
    return DateTime
        .now()
        .millisecondsSinceEpoch;
  }

  static PlatformType? _platformType;
  static getPlatformType() {
    if (_platformType != null) {
      return _platformType;
    }
    try {
      if (Platform.isIOS) {
        return PlatformType.ios;
      }
      if (Platform.isAndroid) {
        return PlatformType.android;
      }
    }
    catch (e) {
      return PlatformType.web;
    }
    return PlatformType.unknown;
  }

  static isAndroid() {
    return (getPlatformType()==PlatformType.android);
  }

  static isIOS() {
    return (getPlatformType()==PlatformType.ios);
  }

  static isWeb() {
    return (getPlatformType()==PlatformType.web);
  }

  static showToast(String msg, {bool isLong = false}) {
    if (!Utils.isWeb()) {
      try {
        Fluttertoast.cancel();
      }
      catch(_) {
      }
    }

    //
    Fluttertoast.showToast(
      msg: msg,
      toastLength: isLong?Toast.LENGTH_LONG:Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      //timeInSecForIos: 5,
      backgroundColor: const Color(0x99000000),
      webBgColor: "#777",
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  static String formatTimeToFinishEx (int time) {
    if (time < 0) {
      time = 0;
    }

    int h = (time / 3600).truncate();
    int m = ((time - h * 3600) / 60).floor();
    int s  = time % 60;

    String t = '';
    if (h > 0) {
      t += '$h ${'time.h'.tr()} ';
    }
    if (m > 0) {
      t += '$m ${'time.m'.tr()} ';
    }
    t += '$s ${'time.s'.tr()}';
    return t;
  }

  static String formatZNumber(int val) {
    if (val >= 10) {
      return val.toString();
    }
    return '0$val';
  }

  static String formatFullTime(DateTime dt) {
    return '${formatZNumber(dt.year)}-${formatZNumber(dt.month)}-${formatZNumber(dt.day)} '
        '${formatZNumber(dt.hour)}:${formatZNumber(dt.minute)}:${formatZNumber(dt.second)}';
  }

  static String formatSmartTime(DateTime dtNow, DateTime dt) {
    String time = DateFormat.jm(LocalizationService.getCurrentDateLocale()).format(dt);

    if (dtNow.day == dt.day && dtNow.month == dt.month && dtNow.year == dt.year) {
      String today = 'Today';
      if (LocalizationService().getLanguage().key == 'russian') {
        today = 'Сегодня в';
      }
      return '$today $time';
    }

    String at = 'at';
    if (LocalizationService().getLanguage().key == 'russian') {
      at = 'в';
    }

    String date = DateFormat('d MMMM', LocalizationService.getCurrentDateLocale()).format(dt);
    return '$date $at $time';
  }
}