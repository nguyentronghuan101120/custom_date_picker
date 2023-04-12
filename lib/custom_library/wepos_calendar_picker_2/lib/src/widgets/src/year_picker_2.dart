part of widget_library;

class YearPicker2 extends StatefulWidget {
  /// Creates a year picker.
  const YearPicker2({
    required this.config,
    required this.selectedDates,
    required this.onChanged,
    required this.initialDateTime,
    this.dragStartBehavior = DragStartBehavior.start,
    Key? key,
  }) : super(key: key);

  /// The calendar configurations
  final CalendarDatePicker2Config config;

  /// The currently selected dates.
  ///
  /// Selected dates are highlighted in the picker.
  final List<DateTime?> selectedDates;

  /// Called when the user picks a year.
  final ValueChanged<DateTime> onChanged;

  /// The initial month to display.
  final DateTime initialDateTime;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  @override
  State<YearPicker2> createState() => _YearPicker2State();
}

class _YearPicker2State extends State<YearPicker2> {
  late ScrollController _scrollController;

  // The approximate number of years necessary to fill the available space.
  static const int minYears = 18;

  @override
  void initState() {
    super.initState();
    final double scrollOffset =
        widget.selectedDates.isNotEmpty && widget.selectedDates[0] != null
            ? _scrollOffsetForYear(widget.initialDateTime)
            : _scrollOffsetForYear(DateUtils.dateOnly(DateTime.now()));
    _scrollController = ScrollController(initialScrollOffset: scrollOffset);
  }

  @override
  void didUpdateWidget(YearPicker2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDates != oldWidget.selectedDates) {
      final double scrollOffset =
          widget.selectedDates.isNotEmpty && widget.selectedDates[0] != null
              ? _scrollOffsetForYear(widget.selectedDates[0]!)
              : _scrollOffsetForYear(DateUtils.dateOnly(DateTime.now()));
      _scrollController.jumpTo(scrollOffset);
    }
  }

  double _scrollOffsetForYear(DateTime date) {
    final int initialYearIndex = date.year - widget.config.firstDate.year;
    final int initialYearRow = initialYearIndex ~/ _yearPickerColumnCount;
    // Move the offset down by 2 rows to approximately center it.
    final int centeredYearRow = initialYearRow - 2;
    return _itemCount < minYears ? 0 : centeredYearRow * _yearPickerRowHeight;
  }

  Widget _buildYearItem(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Backfill the _YearPicker with disabled years if necessary.
    final int offset = _itemCount < minYears ? (minYears - _itemCount) ~/ 2 : 0;
    final int year = widget.config.firstDate.year + index - offset;
    final bool isSelected = year == widget.initialDateTime.year;
    final bool isCurrentYear = year == widget.config.currentDate.year;
    final bool isDisabled = year < widget.config.firstDate.year ||
        year > widget.config.lastDate.year;
    const double decorationHeight = 36.0;
    const double decorationWidth = 72.0;

    final Color textColor;
    if (isSelected) {
      textColor =
          widget.config.yearStyleConfig?.selectedColor ?? colorScheme.onPrimary;
    } else if (isDisabled) {
      textColor = widget.config.yearStyleConfig?.disableColor ??
          colorScheme.onSurface.withOpacity(0.38);
    } else if (isCurrentYear) {
      textColor =
          widget.config.yearStyleConfig?.selectedColor ?? colorScheme.primary;
    } else {
      textColor = widget.config.yearStyleConfig?.baseTextColor ??
          colorScheme.onSurface.withOpacity(0.87);
    }
    TextStyle? itemStyle =
        widget.config.yearStyleConfig?.yearTextStyle?.apply(color: textColor) ??
            textTheme.bodyLarge?.apply(color: textColor);
    if (isSelected) {
      itemStyle =
          widget.config.yearStyleConfig?.selectedYearTextStyle ?? itemStyle;
    }

    BoxDecoration? decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: widget.config.yearStyleConfig?.selectedBorderColor ??
            colorScheme.primary,
        borderRadius: widget.config.yearStyleConfig?.yearBorderRadius ??
            BorderRadius.circular(decorationHeight / 2),
      );
    } else if (isCurrentYear && !isDisabled) {
      decoration = BoxDecoration(
        border: Border.all(
          color: widget.config.yearStyleConfig?.selectedBorderColor ??
              colorScheme.primary,
        ),
        borderRadius: widget.config.yearStyleConfig?.yearBorderRadius ??
            BorderRadius.circular(decorationHeight / 2),
      );
    }

    Widget yearItem = widget.config.yearStyleConfig?.yearBuilder?.call(
          year: year,
          textStyle: itemStyle,
          decoration: decoration,
          isSelected: isSelected,
          isDisabled: isDisabled,
          isCurrentYear: isCurrentYear,
        ) ??
        Center(
          child: Container(
            decoration: decoration,
            height: decorationHeight,
            width: decorationWidth,
            child: Center(
              child: Semantics(
                selected: isSelected,
                button: true,
                child: Text(
                  year.toString(),
                  style: itemStyle,
                ),
              ),
            ),
          ),
        );

    if (isDisabled) {
      yearItem = ExcludeSemantics(
        child: yearItem,
      );
    } else {
      yearItem = InkWell(
        key: ValueKey<int>(year),
        onTap: () => widget.onChanged(
          DateTime(
            year,
            widget.initialDateTime.month,
          ),
        ),
        child: yearItem,
      );
    }

    return yearItem;
  }

  int get _itemCount {
    return widget.config.lastDate.year - widget.config.firstDate.year + 4;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Column(
      children: <Widget>[
        const Divider(),
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            dragStartBehavior: widget.dragStartBehavior,
            gridDelegate: _yearPickerGridDelegate,
            itemBuilder: _buildYearItem,
            itemCount: math.max(_itemCount, minYears),
            padding: const EdgeInsets.symmetric(horizontal: _yearPickerPadding),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _YearPickerGridDelegate extends SliverGridDelegate {
  const _YearPickerGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent -
            (_yearPickerColumnCount - 1) * _yearPickerRowSpacing) /
        _yearPickerColumnCount;
    return SliverGridRegularTileLayout(
      childCrossAxisExtent: tileWidth,
      childMainAxisExtent: _yearPickerRowHeight,
      crossAxisCount: _yearPickerColumnCount,
      crossAxisStride: tileWidth + _yearPickerRowSpacing,
      mainAxisStride: _yearPickerRowHeight,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_YearPickerGridDelegate oldDelegate) => false;
}

const _YearPickerGridDelegate _yearPickerGridDelegate =
    _YearPickerGridDelegate();
