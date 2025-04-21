import 'package:flutter/material.dart';

class UserPreferencePage extends StatefulWidget {
  @override
  _UserPreferencePageState createState() => _UserPreferencePageState();
}

class _UserPreferencePageState extends State<UserPreferencePage> {
  int selectedThemeIndex = 0;
  String selectedLanguage = 'Filipino';

  final List<Color> themeColors = [
    Color(0xFFD99BA2),
    Color(0xFFC3A7E4),
    Color(0xFF4464AC),
  ];

  final List<String> languages = ['Filipino', 'English'];

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(themeColors.length, (index) {
                return Column(
                  children: [
                    Container(
                      height: 100,
                      width: 50,
                      decoration: BoxDecoration(
                        color: themeColors[index],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColors[index],
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedThemeIndex = index;
                        });
                      },
                      child: Text(
                        selectedThemeIndex == index ? "Current" : "Choose",
                        style: TextStyle(
                          color: index == 2 ? Colors.white : Colors.black,
                        ),
                      ),
                    )
                  ],
                );
              }),
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
                  // Save selectedLanguage and selectedThemeIndex
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
