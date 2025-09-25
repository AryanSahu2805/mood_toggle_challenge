import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MoodModel(),
      child: MyApp(),
    ),
  );
}

// Mood Model - The "Brain" of our app
class MoodModel with ChangeNotifier {
  String _currentMood = '😊';
  Color _backgroundColor = Colors.yellow;
  Map<String, int> _moodCounts = {
    'Happy': 0,
    'Sad': 0,
    'Excited': 0,
  };

  String get currentMood => _currentMood;
  Color get backgroundColor => _backgroundColor;
  Map<String, int> get moodCounts => _moodCounts;

  void setHappy() {
    _currentMood = '😊';
    _backgroundColor = Colors.yellow;
    _moodCounts['Happy'] = _moodCounts['Happy']! + 1;
    notifyListeners();
  }

  void setSad() {
    _currentMood = '😢';
    _backgroundColor = Colors.blue;
    _moodCounts['Sad'] = _moodCounts['Sad']! + 1;
    notifyListeners();
  }

  void setExcited() {
    _currentMood = '🎉';
    _backgroundColor = Colors.orange;
    _moodCounts['Excited'] = _moodCounts['Excited']! + 1;
    notifyListeners();
  }
}

// Main App Widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Toggle Challenge',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Scaffold(
          backgroundColor: moodModel.backgroundColor,
          appBar: AppBar(title: Text('Mood Toggle Challenge')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('How are you feeling?', style: TextStyle(fontSize: 24)),
                SizedBox(height: 30),
                MoodDisplay(),
                SizedBox(height: 50),
                MoodButtons(),
                SizedBox(height: 30),
                MoodCounter(),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget that displays the current mood
class MoodDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Text(moodModel.currentMood, style: TextStyle(fontSize: 100));
      },
    );
  }
}

// Widget with buttons to change the mood
class MoodButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setHappy();
          },
          child: Text('Happy 😊'),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setSad();
          },
          child: Text('Sad 😢'),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<MoodModel>(context, listen: false).setExcited();
          },
          child: Text('Excited 🎉'),
        ),
      ],
    );
  }
}

// Widget that displays mood counters
class MoodCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MoodModel>(
      builder: (context, moodModel, child) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text('Mood Counts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('😊', style: TextStyle(fontSize: 24)),
                      Text('${moodModel.moodCounts['Happy']}', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('😢', style: TextStyle(fontSize: 24)),
                      Text('${moodModel.moodCounts['Sad']}', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  Column(
                    children: [
                      Text('🎉', style: TextStyle(fontSize: 24)),
                      Text('${moodModel.moodCounts['Excited']}', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}