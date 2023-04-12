import 'package:egg_mobile_pos/custom_library/wepos_calendar_picker_2/lib/src/utils/utils_library.dart';
import 'package:flutter/material.dart';

enum CalendarDatePicker2Type { single, multi, range }

typedef CalendarDayTextStylePredicate = TextStyle? Function({
  required DateTime date,
});

typedef CalendarDayBuilder = Widget? Function({
  required DateTime date,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isToday,
});

typedef CalendarYearBuilder = Widget? Function({
  required int year,
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isCurrentYear,
});

typedef CalendarMonthBuilder = Widget? Function({
  TextStyle? textStyle,
  BoxDecoration? decoration,
  bool? isSelected,
  bool? isDisabled,
  bool? isCurrentMonth,
});

typedef CalendarModePickerTextHandler = String? Function({
  required DateTime monthDate,
});

class CalendarDatePicker2Config {
  CalendarDatePicker2Config({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePicker2Mode? calendarViewMode,
    this.weekdayLabels,
    this.weekdayLabelTextStyle,
    this.firstDayOfWeek,
    this.controlsHeight,
    this.lastMonthIcon,
    this.nextMonthIcon,
    this.controlsTextStyle,
    this.dayTextStyle,
    this.selectedDayTextStyle,
    this.selectedDayHighlightColor,
    this.disabledDayTextStyle,
    this.todayTextStyle,
    this.dayBorderRadius,
    this.selectableDayPredicate,
    this.dayTextStylePredicate,
    this.dayBuilder,
    this.disableModePicker,
    this.centerAlignModePicker,
    this.customModePickerIcon,
    this.modePickerTextHandler,
    this.yearStyleConfig,
    this.monthStyleConfig,
  })  : calendarType = calendarType ?? CalendarDatePicker2Type.single,
        firstDate = DateUtils.dateOnly(firstDate ?? DateTime(1970)),
        lastDate =
            DateUtils.dateOnly(lastDate ?? DateTime(DateTime.now().year + 50)),
        currentDate = currentDate ?? DateUtils.dateOnly(DateTime.now()),
        calendarViewMode = calendarViewMode ?? DatePicker2Mode.day;

  /// The enabled date picker mode
  final CalendarDatePicker2Type calendarType;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// The initially displayed view of the calendar picker.
  final DatePicker2Mode calendarViewMode;

  /// Custom weekday labels for the current locale, MUST starts from Sunday
  /// Examples:
  ///
  /// - US English: S, M, T, W, T, F, S
  /// - Russian: вс, пн, вт, ср, чт, пт, сб - notice that the list begins with
  ///   вс (Sunday) even though the first day of week for Russian is Monday.
  final List<String>? weekdayLabels;

  /// Custom text style for weekday labels
  final TextStyle? weekdayLabelTextStyle;

  /// Index of the first day of week, where 0 points to Sunday, and 6 points to Saturday.
  final int? firstDayOfWeek;

  /// Custom height for calendar control toggle's height
  final double? controlsHeight;

  /// Custom icon for last month button control
  final Widget? lastMonthIcon;

  /// Custom icon for next month button control
  final Widget? nextMonthIcon;

  /// Custom text style for calendar mode toggle control
  final TextStyle? controlsTextStyle;

  /// Custom text style for all calendar days
  final TextStyle? dayTextStyle;

  /// Custom text style for selected calendar day(s)
  final TextStyle? selectedDayTextStyle;

  /// The highlight color for selected day(s)
  final Color? selectedDayHighlightColor;

  /// Custom text style for disabled calendar day(s)
  final TextStyle? disabledDayTextStyle;

  /// Custom text style for today
  final TextStyle? todayTextStyle;

  /// Custom border radius for day indicator
  final BorderRadius? dayBorderRadius;

  /// Function to provide full control over which dates in the calendar can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  /// Function to provide full control over calendar days text style
  final CalendarDayTextStylePredicate? dayTextStylePredicate;

  /// Function to provide full control over day widget UI
  final CalendarDayBuilder? dayBuilder;

  /// Flag to disable mode picker and hide the mode toggle button icon
  final bool? disableModePicker;

  /// Flag to centralize year and month text label in controls
  final bool? centerAlignModePicker;

  /// Custom icon for the mode picker button icon
  final Widget? customModePickerIcon;

  /// Function to control mode picker displayed text
  final CalendarModePickerTextHandler? modePickerTextHandler;

  final YearStyleConfig? yearStyleConfig;

  final MonthStyleConfig? monthStyleConfig;

  CalendarDatePicker2Config copyWith({
    CalendarDatePicker2Type? calendarType,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? currentDate,
    DatePicker2Mode? calendarViewMode,
    List<String>? weekdayLabels,
    TextStyle? weekdayLabelTextStyle,
    int? firstDayOfWeek,
    double? controlsHeight,
    Widget? lastMonthIcon,
    Widget? nextMonthIcon,
    TextStyle? controlsTextStyle,
    TextStyle? dayTextStyle,
    TextStyle? selectedDayTextStyle,
    Color? selectedDayHighlightColor,
    TextStyle? disabledDayTextStyle,
    TextStyle? todayTextStyle,
    TextStyle? yearTextStyle,
    TextStyle? selectedYearTextStyle,
    BorderRadius? dayBorderRadius,
    BorderRadius? yearBorderRadius,
    SelectableDayPredicate? selectableDayPredicate,
    CalendarDayTextStylePredicate? dayTextStylePredicate,
    CalendarDayBuilder? dayBuilder,
    CalendarYearBuilder? yearBuilder,
    bool? disableModePicker,
    bool? centerAlignModePicker,
    Widget? customModePickerIcon,
    CalendarModePickerTextHandler? modePickerTextHandler,
    YearStyleConfig? yearStyleConfig,
    MonthStyleConfig? monthStyleConfig,
  }) {
    return CalendarDatePicker2Config(
      calendarType: calendarType ?? this.calendarType,
      firstDate: DateUtils.dateOnly(firstDate ?? this.firstDate),
      lastDate: DateUtils.dateOnly(lastDate ?? this.lastDate),
      currentDate: currentDate ?? this.currentDate,
      calendarViewMode: calendarViewMode ?? this.calendarViewMode,
      weekdayLabels: weekdayLabels ?? this.weekdayLabels,
      weekdayLabelTextStyle:
          weekdayLabelTextStyle ?? this.weekdayLabelTextStyle,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      controlsHeight: controlsHeight ?? this.controlsHeight,
      lastMonthIcon: lastMonthIcon ?? this.lastMonthIcon,
      nextMonthIcon: nextMonthIcon ?? this.nextMonthIcon,
      controlsTextStyle: controlsTextStyle ?? this.controlsTextStyle,
      dayTextStyle: dayTextStyle ?? this.dayTextStyle,
      selectedDayTextStyle: selectedDayTextStyle ?? this.selectedDayTextStyle,
      selectedDayHighlightColor:
          selectedDayHighlightColor ?? this.selectedDayHighlightColor,
      disabledDayTextStyle: disabledDayTextStyle ?? this.disabledDayTextStyle,
      todayTextStyle: todayTextStyle ?? this.todayTextStyle,
      dayBorderRadius: dayBorderRadius ?? this.dayBorderRadius,
      selectableDayPredicate:
          selectableDayPredicate ?? this.selectableDayPredicate,
      dayTextStylePredicate:
          dayTextStylePredicate ?? this.dayTextStylePredicate,
      dayBuilder: dayBuilder ?? this.dayBuilder,
      disableModePicker: disableModePicker ?? this.disableModePicker,
      centerAlignModePicker:
          centerAlignModePicker ?? this.centerAlignModePicker,
      customModePickerIcon: customModePickerIcon ?? this.customModePickerIcon,
      modePickerTextHandler:
          modePickerTextHandler ?? this.modePickerTextHandler,
      yearStyleConfig: yearStyleConfig ?? this.yearStyleConfig,
      monthStyleConfig: monthStyleConfig,
    );
  }
}

class YearStyleConfig {
  // Custom text style for years list
  final TextStyle? yearTextStyle;

  // Custom text style for selected year(s)
  final TextStyle? selectedYearTextStyle;

  /// Custom border radius for year indicator
  final BorderRadius? yearBorderRadius;

  /// Function to provide full control over year widget UI
  final CalendarYearBuilder? yearBuilder;

  final Color? disableColor;
  final Color? selectedColor;
  final Color? currentYearColor;
  final Color? baseTextColor;
  final Color? selectedBorderColor;

  const YearStyleConfig({
    this.yearTextStyle,
    this.selectedYearTextStyle,
    this.yearBorderRadius,
    this.yearBuilder,
    this.disableColor,
    this.selectedColor,
    this.currentYearColor,
    this.baseTextColor,
    this.selectedBorderColor,
  });
}

class MonthStyleConfig {
  // Custom text style for years list
  final TextStyle? monthTextStyle;

  // Custom text style for selected year(s)
  final TextStyle? selectedMonthTextStyle;

  /// Custom border radius for year indicator
  final BorderRadius? monthBorderRadius;

  /// Function to provide full control over year widget UI
  final CalendarMonthBuilder? monthBuilder;

  final Color? disableColor;
  final Color? selectedColor;
  final Color? currentYearColor;
  final Color? baseTextColor;
  final Color? selectedBorderColor;

  const MonthStyleConfig({
    this.monthBorderRadius,
    this.disableColor,
    this.selectedColor,
    this.currentYearColor,
    this.baseTextColor,
    this.monthBuilder,
    this.monthTextStyle,
    this.selectedMonthTextStyle,
    this.selectedBorderColor,
  });
}
