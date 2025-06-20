import 'package:flutter/material.dart';
import 'appColors.dart';
import 'timeInterval.dart'; // Import du widget TimeInterval

class HourlyDetail extends StatefulWidget {
  final List<String> hourlyTimes;
  final List<double> hourlyApparentTemperature;
  final List<double> hourlyHumidity;
  final List<double> hourlyPrecipitation;
  final List<double> hourlyCloudCover;
  final VoidCallback onGetHourlyWeather;
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final void Function(DateTime start, DateTime end)? onDateRangeChanged;

  const HourlyDetail({
    super.key,
    required this.hourlyTimes,
    required this.hourlyApparentTemperature,
    required this.hourlyHumidity,
    required this.hourlyPrecipitation,
    required this.hourlyCloudCover,
    required this.onGetHourlyWeather,
    required this.initialStartDate,
    required this.initialEndDate,
    this.onDateRangeChanged,
  });

  @override
  _HourlyDetailState createState() => _HourlyDetailState();
}

class _HourlyDetailState extends State<HourlyDetail> {
  final ScrollController _scrollController = ScrollController();

  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    // Initialisation avec les valeurs passées depuis main
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollLeft() {
    double newPosition = _scrollController.position.pixels - 150;
    if (newPosition < 0) newPosition = 0;
    _scrollController.animateTo(newPosition,
        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  void _scrollRight() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double newPosition = _scrollController.position.pixels + 150;
    if (newPosition > maxScroll) newPosition = maxScroll;
        _scrollController.animateTo(newPosition,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  String formatDateFr(String isoDate) {
    try {
      final DateTime date = DateTime.parse(isoDate);
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().padLeft(4, '0')} -- ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hourlyTimes.isEmpty) {
      return const SizedBox();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.box,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Données horaires',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              //TimeInterval met à jour _startDate et _endDate via son callback
              TimeInterval(
                onStartDateChanged: (formatDate) {
                  
                  setState(() {
                    _startDate = formatDate!;
                  });
                },
                onEndDateChanged: (formatDate) {
                  setState(() {
                    _endDate = formatDate!;
                  });
                },
                onDateRangeSelected: () {
                  // Remonte la plage sélectionnée au parent
                  if (widget.onDateRangeChanged != null) {
                    widget.onDateRangeChanged!(_startDate, _endDate);
                  }
                  widget.onGetHourlyWeather();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _scrollLeft,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: Row(
                        children: List.generate(
                          widget.hourlyTimes.length,
                          (index) => Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  formatDateFr(widget.hourlyTimes[index]),  
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Temp. ressentie ',
                                        style: TextStyle(
                                          color: AppColors.textSecondaire,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${widget.hourlyApparentTemperature[index]} °C',
                                        style: const TextStyle(
                                          color: AppColors.text, 
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Humidité ',
                                        style: TextStyle(
                                          color: AppColors.textSecondaire,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${widget.hourlyHumidity[index]}%',
                                        style: const TextStyle(
                                          color: AppColors.text, 
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Précip ',
                                        style: TextStyle(
                                          color: AppColors.textSecondaire,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${widget.hourlyPrecipitation[index]} mm',
                                        style: const TextStyle(
                                          color: AppColors.text,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Nuages ',
                                        style: TextStyle(
                                          color: AppColors.textSecondaire,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${widget.hourlyCloudCover[index]}%',
                                        style: const TextStyle(
                                          color: AppColors.text, 
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _scrollRight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}