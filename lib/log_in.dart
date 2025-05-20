import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  String errorMessage = '';
  bool _isLoginMode = true; // toggle between login and signup mode

  // Login Controllers
  final TextEditingController _loginUsernameController =
      TextEditingController();

  final TextEditingController _loginPasswordController =
      TextEditingController();

  // Sign Up Controllers
  final TextEditingController _signUpNameController = TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();
  final TextEditingController _signUpConfirmPasswordController =
      TextEditingController();

  Future<void> _login() async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/api/auth/login'); // Use your actual base URL

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _loginUsernameController
              .text, // Previously: _loginEmailController
          'password': _loginPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userId = responseData['user']['id'];
        final username = responseData['user']['username'];
        final email = responseData['user']['email'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', userId);
        await prefs.setString('user_name', username ?? 'User Name');
        await prefs.setString('user_email', email ?? 'user@example.com');

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          errorMessage = data['message'] ?? 'Invalid credentials';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Connection error. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signUp() async {
    final url = Uri.parse('${AppConfig.baseUrl}/api/auth/register');

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _signUpNameController.text,
          'email': _signUpEmailController.text,
          'password': _signUpPasswordController.text,
          'confirmPassword': _signUpConfirmPasswordController.text,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          errorMessage = data['message'] ?? 'Sign up failed';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.pinkAccent),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2A47),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Shopaholic',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            if (_isLoginMode) ...[
             _buildTextField('Username', _loginUsernameController),
              const SizedBox(height: 20),
              _buildTextField('Password', _loginPasswordController,
                  obscureText: true),
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                      value: false,
                      onChanged: (value) {},
                      activeColor: Colors.pinkAccent),
                  const Text('Remember me',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
              if (errorMessage.isNotEmpty) ...[
                Text(errorMessage, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 10),
              ],
              ElevatedButton(
                onPressed: isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Log In',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
              ),
            ] else ...[
              _buildTextField('Name', _signUpNameController),
              const SizedBox(height: 10),
              _buildTextField('Email', _signUpEmailController),
              const SizedBox(height: 10),
              _buildTextField('Password', _signUpPasswordController,
                  obscureText: true),
              const SizedBox(height: 10),
              _buildTextField(
                  'Confirm Password', _signUpConfirmPasswordController,
                  obscureText: true),
              const SizedBox(height: 20),
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
                  onPressed: isLoading ? null : _signUp,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign Up", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoginMode = !_isLoginMode;
                });
              },
              child: Text(
                _isLoginMode
                    ? "Don't have an account? Sign up"
                    : "Already have an account? Log In",
                style: const TextStyle(
                    color: Colors.white, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
