import 'package:flutter/material.dart';
import 'package:meteo_app/widget/appColors.dart';

class TimeInterval extends StatefulWidget {
  final ValueChanged<DateTime?>? onStartDateChanged;
  final ValueChanged<DateTime?>? onEndDateChanged;
  final VoidCallback? onDateRangeSelected; // nouveau callback

  const TimeInterval({
    Key? key,
    this.onStartDateChanged,
    this.onEndDateChanged,
    this.onDateRangeSelected,

  }) : super(key: key);

  // Méthode utilitaire pour formater la date
  static String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  _TimeIntervalState createState() => _TimeIntervalState();
}

class _TimeIntervalState extends State<TimeInterval> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDateRange() async {
    final DateTime now = DateTime.now();
    final DateTime firstAllowedDate = now.subtract(const Duration(days: 1)) ;
    final DateTime lastAllowedDate = now.add(const Duration(days: 1));
  
    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : DateTimeRange(start: now, end: now),
      firstDate: firstAllowedDate,
      lastDate: lastAllowedDate,
    );
    if (pickedRange != null) {
      setState(() {
        _startDate = pickedRange.start;
        _endDate = pickedRange.end;
      });
      widget.onStartDateChanged?.call(pickedRange.start);
      widget.onEndDateChanged?.call(pickedRange.end);
      widget.onDateRangeSelected?.call();
      }
    }
  
@override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: _selectDateRange,
          child: const Icon(
            Icons.calendar_today,
            size: 30,
            color: AppColors.calendar,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
 
}