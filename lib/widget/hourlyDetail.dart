import 'package:flutter/material.dart';

class HourlyDetail extends StatefulWidget {
  final List<String> hourlyTimes;
  final List<double> hourlyApparentTemperature;
  final List<double> hourlyHumidity;
  final List<double> hourlyPrecipitation;
  final List<double> hourlyCloudCover;

  const HourlyDetail({
    super.key,
    required this.hourlyTimes,
    required this.hourlyApparentTemperature,
    required this.hourlyHumidity,
    required this.hourlyPrecipitation,
    required this.hourlyCloudCover,
  });

  @override
  _HourlyDetailState createState() => _HourlyDetailState();
}

class _HourlyDetailState extends State<HourlyDetail> {
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    double newPosition = _scrollController.position.pixels - 150;
    if (newPosition < 0) newPosition = 0;
    _scrollController.animateTo(newPosition,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void _scrollRight() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double newPosition = _scrollController.position.pixels + 150;
    if (newPosition > maxScroll) newPosition = maxScroll;
    _scrollController.animateTo(newPosition,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.hourlyTimes.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Données horaires (intervalle choisi):',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _scrollLeft,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Déterminer le nombre d'éléments visibles : au maximum 9 ou moins si le nombre d'items est inférieur.
                  int visibleItems = widget.hourlyTimes.length > 9 ? 9 : widget.hourlyTimes.length;
                  double containerWidth = constraints.maxWidth / visibleItems;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    child: Row(
                      children: List.generate(
                        widget.hourlyTimes.length,
                        (index) => Container(
                          width: containerWidth,
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.hourlyTimes[index],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Temp. ressentie: ${widget.hourlyApparentTemperature[index]}°C',
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Humidité: ${widget.hourlyHumidity[index]}%',
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Précip: ${widget.hourlyPrecipitation[index]} mm',
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Nuages: ${widget.hourlyCloudCover[index]}%',
                                textAlign: TextAlign.center,
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
    );
  }
}