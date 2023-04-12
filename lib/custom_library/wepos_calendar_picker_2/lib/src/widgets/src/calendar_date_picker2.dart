part of widget_library;

class CalendarDatePicker2 extends StatefulWidget {
  CalendarDatePicker2({
    required this.value,
    required this.config,
    this.onValueChanged,
    this.onDisplayedMonthChanged,
    Key? key,
  }) : super(key: key) {
    const bool valid = true;
    const bool invalid = false;

    if (config.calendarType == CalendarDatePicker2Type.single) {
      assert(value.length < 2,
          'Error: single date picker only allows maximum one initial date');
    }

    if (config.calendarType == CalendarDatePicker2Type.range &&
        value.length > 1) {
      final bool isRangePickerValueValid = value[0] == null
          ? (value[1] != null ? invalid : valid)
          : (value[1] != null
              ? (value[1]!.isBefore(value[0]!) ? invalid : valid)
              : valid);

      assert(
        isRangePickerValueValid,
        'Error: range date picker must has start date set before setting end date, and start date must before end date.',
      );
    }
  }

  /// The initially selected [DateTime]s that the picker should display.
  final List<DateTime?> value;

  /// Called when the user selects a date in the picker.
  final ValueChanged<List<DateTime?>>? onValueChanged;

  /// Called when the user navigates to a new month/year in the picker.
  final ValueChanged<DateTime>? onDisplayedMonthChanged;

  /// The calendar UI related configurations
  final CalendarDatePicker2Config config;

  @override
  State<CalendarDatePicker2> createState() => _CalendarDatePicker2State();
}

class _CalendarDatePicker2State extends State<CalendarDatePicker2> {
  bool _announcedInitialDate = false;
  late List<DateTime?> _selectedDates;
  late DatePicker2Mode _mode;
  late DateTime _currentDisplayedMonthAndYear;
  final GlobalKey _monthPickerKey = GlobalKey();
  final GlobalKey _yearPickerKey = GlobalKey();
  late MaterialLocalizations _localizations;
  late TextDirection _textDirection;

  @override
  void initState() {
    super.initState();
    final CalendarDatePicker2Config config = widget.config;
    final DateTime initialDate =
        widget.value.isNotEmpty && widget.value[0] != null
            ? DateTime(widget.value[0]!.year, widget.value[0]!.month)
            : DateUtils.dateOnly(DateTime.now());
    _mode = config.calendarViewMode;
    _currentDisplayedMonthAndYear =
        DateTime(initialDate.year, initialDate.month);
    _selectedDates = widget.value.toList();
  }

  @override
  void didUpdateWidget(CalendarDatePicker2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.calendarViewMode != oldWidget.config.calendarViewMode) {
      _mode = widget.config.calendarViewMode;
    }
    _selectedDates = widget.value.toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    _localizations = MaterialLocalizations.of(context);
    _textDirection = Directionality.of(context);
    if (!_announcedInitialDate && _selectedDates.isNotEmpty) {
      _announcedInitialDate = true;
      for (final DateTime? date in _selectedDates) {
        if (date != null) {
          SemanticsService.announce(
            _localizations.formatFullDate(date),
            _textDirection,
          );
        }
      }
    }
  }

  void _vibrate() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        HapticFeedback.vibrate();
        break;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        break;
    }
  }

  void _handleModeChanged(DatePicker2Mode mode) {
    _vibrate();
    setState(() {
      _mode = mode;
      if (_selectedDates.isNotEmpty) {
        for (final DateTime? date in _selectedDates) {
          if (date != null) {
            SemanticsService.announce(
              _mode == DatePicker2Mode.day
                  ? _localizations.formatMonthYear(date)
                  : _localizations.formatYear(date),
              _textDirection,
            );
          }
        }
      }
    });
  }

  void _handleMonthOfDayPickerChanged(
    DateTime date, {
    bool fromYearPicker = false,
    bool fromMonthPicker = false,
  }) {
    setState(() {
      final DateTime currentDisplayedMonthDate = DateTime(
        _currentDisplayedMonthAndYear.year,
        _currentDisplayedMonthAndYear.month,
      );
      DateTime newDisplayedMonthDate = currentDisplayedMonthDate;

      if (_currentDisplayedMonthAndYear.year != date.year ||
          _currentDisplayedMonthAndYear.month != date.month) {
        newDisplayedMonthDate = DateTime(date.year, date.month);
      }

      if (fromYearPicker) {
        final List<DateTime?> selectedDatesInThisYear = _selectedDates
            .where((DateTime? d) => d?.year == date.year)
            .toList()
          ..sort((DateTime? d1, DateTime? d2) => d1!.compareTo(d2!));
        if (selectedDatesInThisYear.isNotEmpty) {
          newDisplayedMonthDate =
              DateTime(date.year, selectedDatesInThisYear[0]!.month);
        }
      }

      if (fromMonthPicker) {
        final List<DateTime?> selectedDatesInThisYear = _selectedDates
            .where((DateTime? d) => d?.month == date.month)
            .toList()
          ..sort((DateTime? d1, DateTime? d2) => d1!.compareTo(d2!));
        if (selectedDatesInThisYear.isNotEmpty) {
          newDisplayedMonthDate =
              DateTime(selectedDatesInThisYear[0]!.year, date.month);
        }
      }

      if (currentDisplayedMonthDate.year != newDisplayedMonthDate.year ||
          currentDisplayedMonthDate.month != newDisplayedMonthDate.month) {
        _currentDisplayedMonthAndYear = DateTime(
          newDisplayedMonthDate.year,
          newDisplayedMonthDate.month,
        );
        widget.onDisplayedMonthChanged?.call(_currentDisplayedMonthAndYear);
      }
    });
  }

  void _handleYearChanged(DateTime value) {
    _vibrate();

    // if (value.isBefore(widget.config.firstDate)) {
    //   value = widget.config.firstDate;
    // } else if (value.isAfter(widget.config.lastDate)) {
    //   value = widget.config.lastDate;
    // }

    setState(() {
      _mode = DatePicker2Mode.month;

      _handleMonthOfDayPickerChanged(value, fromYearPicker: true);
    });
  }

  void _handleMonthChanged(DateTime value) {
    _vibrate();

    // if (value.isBefore(widget.config.firstDate)) {
    //   value = widget.config.firstDate;
    // } else if (value.isAfter(widget.config.lastDate)) {
    //   value = widget.config.lastDate;
    // }

    setState(() {
      _mode = DatePicker2Mode.day;

      _handleMonthOfDayPickerChanged(value, fromMonthPicker: true);
    });
  }

  void _handleDayChanged(DateTime value) {
    _vibrate();
    setState(() {
      List<DateTime?> selectedDates = <DateTime?>[..._selectedDates];
      selectedDates.removeWhere((DateTime? d) => d == null);

      if (widget.config.calendarType == CalendarDatePicker2Type.single) {
        selectedDates = <DateTime?>[value];
      } else if (widget.config.calendarType == CalendarDatePicker2Type.multi) {
        final int index = selectedDates
            .indexWhere((DateTime? d) => DateUtils.isSameDay(d, value));
        if (index != -1) {
          selectedDates.removeAt(index);
        } else {
          selectedDates.add(value);
        }
      } else if (widget.config.calendarType == CalendarDatePicker2Type.range) {
        if (selectedDates.isEmpty) {
          selectedDates.add(value);
        } else {
          final bool isRangeSet =
              selectedDates.length > 1 && selectedDates[1] != null;
          final bool isSelectedDayBeforeStartDate =
              value.isBefore(selectedDates[0]!);

          if (isRangeSet || isSelectedDayBeforeStartDate) {
            selectedDates = <DateTime?>[value, null];
          } else {
            selectedDates = <DateTime?>[selectedDates[0], value];
          }
        }
      }

      selectedDates
        ..removeWhere((DateTime? d) => d == null)
        ..sort((DateTime? d1, DateTime? d2) => d1!.compareTo(d2!));

      final bool isValueDifferent =
          widget.config.calendarType != CalendarDatePicker2Type.single ||
              !DateUtils.isSameDay(selectedDates[0],
                  _selectedDates.isNotEmpty ? _selectedDates[0] : null);
      if (isValueDifferent) {
        _selectedDates = _selectedDates
          ..clear()
          ..addAll(selectedDates);
        widget.onValueChanged?.call(_selectedDates);
      }
    });
  }

  Widget _buildPicker() {
    switch (_mode) {
      case DatePicker2Mode.day:
        return DayPicker2(
          config: widget.config,
          key: _monthPickerKey,
          initialDateTime: _currentDisplayedMonthAndYear,
          selectedDates: _selectedDates,
          onChanged: _handleDayChanged,
          onDisplayedMonthChanged: _handleMonthOfDayPickerChanged,
        );

      case DatePicker2Mode.month:
        return Padding(
          padding: EdgeInsets.only(
              top: widget.config.controlsHeight ?? _subHeaderHeight),
          child: MonthPicker2(
            config: widget.config,
            key: _monthPickerKey,
            initialDateTime: _currentDisplayedMonthAndYear,
            selectedDates: _selectedDates,
            onChanged: _handleMonthChanged,
          ),
        );
      case DatePicker2Mode.year:
        return Padding(
          padding: EdgeInsets.only(
              top: widget.config.controlsHeight ?? _subHeaderHeight),
          child: YearPicker2(
            config: widget.config,
            key: _yearPickerKey,
            initialDateTime: _currentDisplayedMonthAndYear,
            selectedDates: _selectedDates,
            onChanged: _handleYearChanged,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(debugCheckHasDirectionality(context));
    return Stack(
      children: <Widget>[
        SizedBox(
          height: (widget.config.controlsHeight ?? _subHeaderHeight) +
              _maxDayPickerHeight,
          child: _buildPicker(),
        ),
        // Put the mode toggle button on top so that it won't be covered up by the _MonthPicker
        _DatePicker2ModeToggleButton(
          config: widget.config,
          mode: _mode,
          title: widget.config.modePickerTextHandler
                  ?.call(monthDate: _currentDisplayedMonthAndYear) ??
              _localizations.formatMonthYear(_currentDisplayedMonthAndYear),
          onTitlePressed: () {
            // Toggle the day/year mode.
            _handleModeChanged(_mode == DatePicker2Mode.day
                ? DatePicker2Mode.month
                : DatePicker2Mode.year);
          },
        ),
      ],
    );
  }
}
