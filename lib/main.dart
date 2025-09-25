import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MoodModel()),
        ChangeNotifierProvider(create: (context) => ThemeModel()),
      ],
      child: MyApp(),
    ),
  );
}

// Mood Model - The "Brain" of our app
class MoodModel with ChangeNotifier {
  String _currentMoodImage = 'assets/images/Happy.png';
  Map<String, int> _moodCounts = {
    'Happy': 0,
    'Sad': 0,
    'Excited': 0,
  };

  String get currentMoodImage => _currentMoodImage;
  Map<String, int> get moodCounts => _moodCounts;

  void setHappy() {
    _currentMoodImage = 'assets/images/Happy.png';
    _moodCounts['Happy'] = _moodCounts['Happy']! + 1;
    notifyListeners();
  }

  void setSad() {
    _currentMoodImage = 'assets/images/Sad.png';
    _moodCounts['Sad'] = _moodCounts['Sad']! + 1;
    notifyListeners();
  }

  void setExcited() {
    _currentMoodImage = 'assets/images/Excited.png';
    _moodCounts['Excited'] = _moodCounts['Excited']! + 1;
    notifyListeners();
  }

  Color getMoodColor(String currentMood, ThemeType themeType) {
    switch (themeType) {
      case ThemeType.dark:
        if (currentMood.contains('Happy')) return Colors.amber.shade700;
        if (currentMood.contains('Sad')) return Colors.blue.shade900;
        if (currentMood.contains('Excited')) return Colors.deepOrange.shade800;
        break;
      case ThemeType.pastel:
        if (currentMood.contains('Happy')) return Colors.yellow.shade100;
        if (currentMood.contains('Sad')) return Colors.blue.shade100;
        if (currentMood.contains('Excited')) return Colors.orange.shade100;
        break;
      default:
        if (currentMood.contains('Happy')) return Colors.yellow;
        if (currentMood.contains('Sad')) return Colors.blue;
        if (currentMood.contains('Excited')) return Colors.orange;
    }
    return Colors.yellow;
  }
}

// Theme Model for managing different theme packs
enum ThemeType { defaultTheme, dark, pastel }

class ThemeModel with ChangeNotifier {
  ThemeType _currentTheme = ThemeType.defaultTheme;

  ThemeType get currentTheme => _currentTheme;

  void setTheme(ThemeType theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  Color get backgroundColor {
    switch (_currentTheme) {
      case ThemeType.dark:
        return Colors.grey.shade900;
      case ThemeType.pastel:
        return Colors.pink.shade50;
      default:
        return Colors.white;
    }
  }

  Color get textColor {
    switch (_currentTheme) {
      case ThemeType.dark:
        return Colors.white;
      case ThemeType.pastel:
        return Colors.grey.shade700;
      default:
        return Colors.black;
    }
  }

  Color get cardColor {
    switch (_currentTheme) {
      case ThemeType.dark:
        return Colors.grey.shade800;
      case ThemeType.pastel:
        return Colors.white.withOpacity(0.9);
      default:
        return Colors.white.withOpacity(0.8);
    }
  }

  String get themeName {
    switch (_currentTheme) {
      case ThemeType.dark:
        return 'Dark Theme';
      case ThemeType.pastel:
        return 'Pastel Theme';
      default:
        return 'Default Theme';
    }
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
    return Consumer2<MoodModel, ThemeModel>(
      builder: (context, moodModel, themeModel, child) {
        Color moodColor = moodModel.getMoodColor(moodModel.currentMoodImage, themeModel.currentTheme);
        
        return Scaffold(
          backgroundColor: moodColor,
          appBar: AppBar(
            title: Text('Mood Toggle Challenge'),
            backgroundColor: themeModel.backgroundColor,
            foregroundColor: themeModel.textColor,
          ),
          body: Container(
            color: moodColor,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'How are you feeling?', 
                      style: TextStyle(
                        fontSize: 24, 
                        color: themeModel.textColor,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    SizedBox(height: 20),
                    ThemeSelector(),
                    SizedBox(height: 30),
                    MoodDisplay(),
                    SizedBox(height: 50),
                    MoodButtons(),
                    SizedBox(height: 30),
                    MoodCounter(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget for theme selection
class ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: themeModel.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                'Current: ${themeModel.themeName}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeModel.textColor,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      themeModel.setTheme(ThemeType.defaultTheme);
                    },
                    child: Text('Default'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      themeModel.setTheme(ThemeType.dark);
                    },
                    child: Text('Dark'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      themeModel.setTheme(ThemeType.pastel);
                    },
                    child: Text('Pastel'),
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

// Widget that displays the current mood
class MoodDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<MoodModel, ThemeModel>(
      builder: (context, moodModel, themeModel, child) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeModel.cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Image.asset(
            moodModel.currentMoodImage,
            width: 100,
            height: 100,
          ),
        );
      },
    );
  }
}

// Widget with buttons to change the mood
class MoodButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeModel.cardColor,
                foregroundColor: themeModel.textColor,
              ),
              onPressed: () {
                Provider.of<MoodModel>(context, listen: false).setHappy();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/Happy.png',
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 5),
                  Text('Happy'),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeModel.cardColor,
                foregroundColor: themeModel.textColor,
              ),
              onPressed: () {
                Provider.of<MoodModel>(context, listen: false).setSad();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/Sad.png',
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 5),
                  Text('Sad'),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: themeModel.cardColor,
                foregroundColor: themeModel.textColor,
              ),
              onPressed: () {
                Provider.of<MoodModel>(context, listen: false).setExcited();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/Excited.png',
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 5),
                  Text('Excited'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// Widget that displays mood counters
class MoodCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<MoodModel, ThemeModel>(
      builder: (context, moodModel, themeModel, child) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeModel.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Mood Counts', 
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: themeModel.textColor,
                )
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/Happy.png',
                        width: 32,
                        height: 32,
                      ),
                      Text(
                        '${moodModel.moodCounts['Happy']}', 
                        style: TextStyle(
                          fontSize: 16,
                          color: themeModel.textColor,
                        )
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/Sad.png',
                        width: 32,
                        height: 32,
                      ),
                      Text(
                        '${moodModel.moodCounts['Sad']}', 
                        style: TextStyle(
                          fontSize: 16,
                          color: themeModel.textColor,
                        )
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/Excited.png',
                        width: 32,
                        height: 32,
                      ),
                      Text(
                        '${moodModel.moodCounts['Excited']}', 
                        style: TextStyle(
                          fontSize: 16,
                          color: themeModel.textColor,
                        )
                      ),
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