import 'package:flutter/material.dart';
import 'background_model.dart';
import 'language_model.dart';
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47), // Dark Background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Create Account",
              style: TextStyle(
                fontSize: 28,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            // Name Input
            _buildTextField(label: "Name"),
            const SizedBox(height: 10),

            // Email Input
            _buildTextField(label: "Email"),
            const SizedBox(height: 10),

            // Password Input
            _buildTextField(label: "Password", obscureText: true),
            const SizedBox(height: 10),

            // Confirm Password Input
            _buildTextField(label: "Confirm Password", obscureText: true),
            const SizedBox(height: 20),

            // Sign Up Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // TODO: Handle Sign Up Logic
                },
                child: const Text("Sign Up", style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 15),

            // Back to Log In
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Already have an account? Log In",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.pinkAccent),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
