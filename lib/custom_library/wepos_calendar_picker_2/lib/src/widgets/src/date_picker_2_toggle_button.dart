part of widget_library;

/// A button that used to toggle the [DatePicker2Mode] for a date picker.
///
/// This appears above the calendar grid and allows the user to toggle the
/// [DatePicker2Mode] to display either the calendar view or the year list.
class _DatePicker2ModeToggleButton extends StatefulWidget {
  const _DatePicker2ModeToggleButton({
    required this.mode,
    required this.title,
    required this.onTitlePressed,
    required this.config,
  });

  /// The current display of the calendar picker.
  final DatePicker2Mode mode;

  /// The text that displays the current month/year being viewed.
  final String title;

  /// The callback when the title is pressed.
  final VoidCallback onTitlePressed;

  /// The calendar configurations
  final CalendarDatePicker2Config config;

  @override
  _DatePicker2ModeToggleButtonState createState() =>
      _DatePicker2ModeToggleButtonState();
}

class _DatePicker2ModeToggleButtonState
    extends State<_DatePicker2ModeToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.mode == DatePicker2Mode.year ? 0.5 : 0,
      upperBound: 0.5,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_DatePicker2ModeToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode == widget.mode) {
      return;
    }

    if (widget.mode == DatePicker2Mode.year) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color controlColor = colorScheme.onSurface.withOpacity(0.60);
    double datePickerOffsetPadding = _monthNavButtonsWidth;
    if (widget.config.centerAlignModePicker == true) {
      datePickerOffsetPadding /= 2;
    }

    return Container(
      padding: widget.config.centerAlignModePicker == true
          ? EdgeInsets.zero
          : const EdgeInsetsDirectional.only(start: 16, end: 4),
      height: (widget.config.controlsHeight ?? _subHeaderHeight),
      child: Row(
        children: <Widget>[
          if (widget.mode == DatePicker2Mode.day &&
              widget.config.centerAlignModePicker == true)
            // Give space for the prev/next month buttons that are underneath this row
            SizedBox(width: datePickerOffsetPadding),
          Flexible(
            child: Semantics(
              label: MaterialLocalizations.of(context).selectYearSemanticsLabel,
              excludeSemantics: true,
              button: true,
              child: SizedBox(
                height: (widget.config.controlsHeight ?? _subHeaderHeight),
                child: InkWell(
                  onTap: widget.config.disableModePicker == true
                      ? null
                      : widget.onTitlePressed,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: widget.config.centerAlignModePicker == true
                            ? 0
                            : 8),
                    child: Row(
                      mainAxisAlignment:
                          widget.config.centerAlignModePicker == true
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            style: widget.config.controlsTextStyle ??
                                textTheme.titleSmall?.copyWith(
                                  color: controlColor,
                                ),
                          ),
                        ),
                        widget.config.disableModePicker == true
                            ? const SizedBox()
                            : RotationTransition(
                                turns: _controller,
                                child: widget.config.customModePickerIcon ??
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: widget.config.controlsTextStyle
                                              ?.color ??
                                          controlColor,
                                    ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.mode == DatePicker2Mode.day)
            // Give space for the prev/next month buttons that are underneath this row
            SizedBox(width: datePickerOffsetPadding),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
