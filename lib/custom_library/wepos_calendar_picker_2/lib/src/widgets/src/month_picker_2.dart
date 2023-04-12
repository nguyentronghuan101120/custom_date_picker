part of widget_library;

class MonthPicker2 extends StatefulWidget {
  /// Creates a year picker.
  const MonthPicker2({
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
  State<MonthPicker2> createState() => _MonthPicker2State();
}

class _MonthPicker2State extends State<MonthPicker2> {
  Widget _buildItem(BuildContext context, int index) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    // Backfill the _YearPicker with disabled years if necessary.
    final int currentMonth = widget.initialDateTime.month - 1;
    final bool isSelected = widget.selectedDates.any(
            (DateTime? element) => element!.year != widget.initialDateTime.year)
        ? false
        : index == currentMonth;
    final bool isCurrentMonth = index == ClientConstant.currentDate.month - 1 &&
        widget.initialDateTime.year == ClientConstant.currentDate.year;
    final bool isDisabled =
        widget.initialDateTime.year < ClientConstant.currentDate.year
            ? false
            : index > widget.config.currentDate.month - 1;
    const double decorationHeight = 36.0;
    const double decorationWidth = 72.0;

    final Color textColor;
    if (isSelected) {
      textColor = widget.config.monthStyleConfig?.selectedColor ??
          colorScheme.onPrimary;
    } else if (isDisabled) {
      textColor = widget.config.monthStyleConfig?.disableColor ??
          colorScheme.onSurface.withOpacity(0.38);
    } else if (isCurrentMonth) {
      textColor =
          widget.config.monthStyleConfig?.selectedColor ?? colorScheme.primary;
    } else {
      textColor = widget.config.monthStyleConfig?.baseTextColor ??
          colorScheme.onSurface.withOpacity(0.87);
    }
    TextStyle? itemStyle = widget.config.monthStyleConfig?.monthTextStyle
            ?.apply(color: textColor) ??
        textTheme.bodyLarge?.apply(color: textColor);
    if (isSelected) {
      itemStyle = widget.config.monthStyleConfig?.selectedMonthTextStyle
              ?.apply(color: textColor) ??
          itemStyle;
    }

    BoxDecoration? decoration;
    if (isSelected) {
      decoration = BoxDecoration(
        color: widget.config.monthStyleConfig?.selectedBorderColor ??
            colorScheme.primary,
        borderRadius: widget.config.monthStyleConfig?.monthBorderRadius ??
            BorderRadius.circular(decorationHeight / 2),
      );
    } else if (isCurrentMonth) {
      decoration = BoxDecoration(
        border: Border.all(
          color: widget.config.monthStyleConfig?.selectedBorderColor ??
              colorScheme.primary,
        ),
        borderRadius: widget.config.monthStyleConfig?.monthBorderRadius ??
            BorderRadius.circular(decorationHeight / 2),
      );
    }

    Widget item = widget.config.monthStyleConfig?.monthBuilder?.call(
          decoration: decoration,
          isSelected: isSelected,
          isDisabled: isDisabled,
          isCurrentMonth: isCurrentMonth,
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
                  index.monthName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: itemStyle,
                ),
              ),
            ),
          ),
        );

    if (isDisabled) {
      item = ExcludeSemantics(
        child: item,
      );
    } else {
      item = InkWell(
        key: ValueKey<int>(currentMonth),
        onTap: () => widget.onChanged(
          DateTime(
            widget.initialDateTime.year,
            index + 1,
          ),
        ),
        child: item,
      );
    }

    return item;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    return Column(
      children: <Widget>[
        const Divider(),
        Expanded(
          child: GridView.builder(
            dragStartBehavior: widget.dragStartBehavior,
            gridDelegate: _monthPickerGridDelegate,
            itemBuilder: _buildItem,
            itemCount: 12,
            padding: const EdgeInsets.symmetric(horizontal: _yearPickerPadding),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class _MonthPickerGridDelegate extends SliverGridDelegate {
  const _MonthPickerGridDelegate();

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
  bool shouldRelayout(_MonthPickerGridDelegate oldDelegate) => false;
}

const _MonthPickerGridDelegate _monthPickerGridDelegate =
    _MonthPickerGridDelegate();
