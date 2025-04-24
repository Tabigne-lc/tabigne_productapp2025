import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class UserPreferencePage extends StatefulWidget {
  @override
  _UserPreferencePageState createState() => _UserPreferencePageState();
}

class _UserPreferencePageState extends State<UserPreferencePage> {
  late int selectedThemeIndex;
  late String selectedLanguage;

  final List<Color> themeColors = [
    Color(0xFFD99BA2),
    Color(0xFFC3A7E4),
    Color(0xFF4464AC),
  ];

  final List<String> languages = ['Filipino', 'English'];

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    selectedThemeIndex = appState.selectedThemeIndex;
    selectedLanguage = appState.selectedLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3DCE3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Theme & Language",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose theme",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFD99BA2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<int>(
                value: selectedThemeIndex,
                dropdownColor: Color(0xFFD99BA2),
                iconEnabledColor: Colors.white,
                underline: SizedBox(),
                isExpanded: true,
                items: themeColors.asMap().entries.map((entry) {
                  int index = entry.key;
                  Color color = entry.value;
                  return DropdownMenuItem<int>(
                    value: index,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedThemeIndex = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Language",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFD99BA2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: selectedLanguage,
                dropdownColor: Color(0xFFD99BA2),
                iconEnabledColor: Colors.white,
                underline: SizedBox(),
                isExpanded: true,
                items: languages.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang,
                    child: Text(
                      lang,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD99BA2),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {
                  final appState = Provider.of<AppState>(context, listen: false);
                  appState.selectedThemeIndex = selectedThemeIndex;
                  appState.selectedLanguage = selectedLanguage;
                  appState.notifyListeners();
                  Navigator.pop(context); // Optional: go back after saving
                },
                child: Text(
                  "Save Changes",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
