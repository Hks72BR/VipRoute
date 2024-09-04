import 'package:flutter/material.dart';
import 'location_service.dart';

class TimeTrackerPage extends StatefulWidget {
  @override
  TimeTrackerPageState createState() => TimeTrackerPageState();
}

class TimeTrackerPageState extends State<TimeTrackerPage> {
  final LocationService _locationService = LocationService();
  DateTime? _startTime;
  DateTime? _endTime;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _locationService.startTracking();
  }

  @override
  void dispose() {
    _locationService.stopTracking();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _startTrackingTime() {
    setState(() {
      _startTime = DateTime.now();
      _endTime = null;
    });
  }

  void _stopTrackingTime() {
    setState(() {
      if (_startTime != null) {
        _endTime = DateTime.now();
        _totalDuration += _endTime!.difference(_startTime!);
        _startTime = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle de Jornada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_startTime != null)
              Text(
                'Início: ${_startTime!.toLocal()}',
                style: TextStyle(fontSize: 16),
              ),
            if (_endTime != null)
              Text(
                'Fim: ${_endTime!.toLocal()}',
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 20),
            Text(
              'Total Trabalhado: ${_formatDuration(_totalDuration)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTrackingTime,
                  child: Text('Iniciar'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _stopTrackingTime,
                  child: Text('Parar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
