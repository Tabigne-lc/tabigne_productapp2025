import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'background_model.dart';
import 'language_model.dart';

class UserPreferencePage extends StatefulWidget {
  @override
  _UserPreferencePageState createState() => _UserPreferencePageState();
}

class _UserPreferencePageState extends State<UserPreferencePage> {
  Color? selectedThemeColor;
  String? selectedLanguage;

  @override
  Widget build(BuildContext context) {
    final backgroundModel = Provider.of<Backgroundmodel>(context);
    final languageModel = Provider.of<LanguageModel>(context);
    final isFilipino = languageModel.isFilipino(); // Make sure this returns a bool

    // Translation strings for Filipino and English
    final titleText = isFilipino ? "Mga Kagustuhan" : "User Preferences";
    final selectThemeText = isFilipino ? "Piliin ang Tema" : "Select Theme Color";
    final selectLanguageText = isFilipino ? "Piliin ang Wika" : "Select Language";
    final saveChangesText = isFilipino ? "I-save ang mga pagbabago" : "Save Changes";
    final missingSelectionText =
        isFilipino ? "Pumili ng parehas na tema at wika." : "Please select both theme and language.";
    final color1Label = isFilipino ? "Kulay 1" : "Color 1";
    final color2Label = isFilipino ? "Kulay 2" : "Color 2";

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        backgroundColor: backgroundModel.appBar,
      ),
      backgroundColor: backgroundModel.background,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(selectThemeText, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildThemeButton(Color(0xFFC3A7E4), color1Label),
                const SizedBox(width: 20),
                _buildThemeButton(Color(0xFF4464AC), color2Label),
              ],
            ),
            const SizedBox(height: 40),
            Text(selectLanguageText, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLanguageButton("English"),
                const SizedBox(width: 20),
                _buildLanguageButton("Filipino"),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                backgroundColor: backgroundModel.buyBtn,
              ),
              onPressed: () {
                if (selectedThemeColor != null && selectedLanguage != null) {
                  // Apply selected theme
                  if (selectedThemeColor == const Color(0xFFC3A7E4)) {
                    backgroundModel.reset();
                  } else if (selectedThemeColor == const Color(0xFF4464AC)) {
                    backgroundModel.applyPurpleTheme();
                  }

                  // Apply selected language
                  languageModel.setLanguage(selectedLanguage!);

                  // Delay to allow state update before checking new language
                  Future.delayed(Duration.zero, () {
                    final updatedLang = Provider.of<LanguageModel>(context, listen: false);
                    final confirmationText = updatedLang.isFilipino()
                        ? "Mga pagbabago ay na-save!"
                        : "Changes saved!";

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(confirmationText)),
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(missingSelectionText)),
                  );
                }
              },
              child: Text(saveChangesText),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeButton(Color color, String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedThemeColor = color;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        side: selectedThemeColor == color
            ? const BorderSide(color: Colors.black, width: 2)
            : BorderSide.none,
      ),
      child: Text(label),
    );
  }

  Widget _buildLanguageButton(String lang) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedLanguage = lang;
        });
      },
      style: ElevatedButton.styleFrom(
        side: selectedLanguage == lang
            ? const BorderSide(color: Colors.black, width: 2)
            : BorderSide.none,
      ),
      child: Text(lang),
    );
  }
}
