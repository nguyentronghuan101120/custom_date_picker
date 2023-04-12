library widget_library;

import 'package:egg_mobile_pos/custom_library/wepos_calendar_picker_2/lib/src/models/calendar_date_picker2_config.dart';
import 'package:egg_mobile_pos/src/constant/client_constant.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../utils/utils_library.dart';

part 'src/calendar_date_picker2.dart';
part 'src/month_picker_2.dart';
part 'src/year_picker_2.dart';
part 'src/day_picker_2.dart';
part 'src/date_picker_2_toggle_button.dart';

const int _yearPickerColumnCount = 3;
const double _yearPickerRowHeight = 52.0;
const double _yearPickerPadding = 16.0;
const double _yearPickerRowSpacing = 8.0;
const Duration _monthScrollDuration = Duration(milliseconds: 200);

const double _dayPickerRowHeight = 42.0;
const int _maxDayPickerRowCount = 6; // A 31 day month that starts on Saturday.
// One extra row for the day-of-week header.
const double _maxDayPickerHeight =
    _dayPickerRowHeight * (_maxDayPickerRowCount + 1);
const double _monthPickerHorizontalPadding = 8.0;

const double _subHeaderHeight = 52.0;
const double _monthNavButtonsWidth = 108.0;

T? _ambiguate<T>(T? value) => value;
