import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart'; // Import the AppState

class UserPreferencePage extends StatefulWidget {
  @override
  _UserPreferencePageState createState() => _UserPreferencePageState();
}

class _UserPreferencePageState extends State<UserPreferencePage> {
  // Variables to store the current selections
  Color? selectedThemeColor;
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Preferences"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Theme Selection
            Text("Select Theme Color", style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedThemeColor = Color(0xFFC3A7E4); // Light Pink
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC3A7E4), // Light Pink
                    side: selectedThemeColor == Color(0xFFC3A7E4)
                        ? BorderSide(color: Colors.black, width: 2) // Highlight border
                        : BorderSide.none,
                  ),
                  child: Text("Color 1"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedThemeColor = Color(0xFF4464AC); // Blue
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4464AC), // Blue
                    side: selectedThemeColor == Color(0xFF4464AC)
                        ? BorderSide(color: Colors.black, width: 2) // Highlight border
                        : BorderSide.none,
                  ),
                  child: Text("Color 2"),
                ),
              ],
            ),
            SizedBox(height: 40),

            // Language Selection (English/Filipino)
            Text("Select Language", style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedLanguage = "English";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    side: selectedLanguage == "English"
                        ? BorderSide(color: Colors.black, width: 2) // Highlight border
                        : BorderSide.none,
                  ),
                  child: Text("English"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedLanguage = "Filipino";
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    side: selectedLanguage == "Filipino"
                        ? BorderSide(color: Colors.black, width: 2) // Highlight border
                        : BorderSide.none,
                  ),
                  child: Text("Filipino"),
                ),
              ],
            ),
            SizedBox(height: 40),

            // Save Changes Button
            ElevatedButton(
              onPressed: () {
                if (selectedThemeColor != null && selectedLanguage != null) {
                  // Save the selected theme color and language to AppState
                  Provider.of<AppState>(context, listen: false)
                      .changeThemeColor(selectedThemeColor!);
                  Provider.of<AppState>(context, listen: false)
                      .changeLanguage(selectedLanguage!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Changes saved!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select both theme and language.")),
                  );
                }
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
