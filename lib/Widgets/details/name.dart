import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gender.dart';
import 'dart:ui';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  Future<void> _saveDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', _nameController.text.trim());
    await prefs.setString('dob', _dobController.text.trim());
    await prefs.setString('weight', _weightController.text.trim());
    await prefs.setString('height', _heightController.text.trim());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Details saved successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0F0D), Color(0xFF1C1F1B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 120),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Please enter your details to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                _buildGlassContainer(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name *',
                          validationMessage: 'Please enter your full name',
                        ),
                        SizedBox(height: 15),
                        _buildDateField(),
                        SizedBox(height: 15),
                        _buildTextField(
                          controller: _weightController,
                          label: 'Weight (kg) *',
                          validationMessage: 'Please enter your weight',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 15),
                        _buildTextField(
                          controller: _heightController,
                          label: 'Height (cm) *',
                          validationMessage: 'Please enter your height',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _saveDetails().then((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GenderPage(),
                                  ),
                                );
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent.withOpacity(0.8),
                            padding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String validationMessage,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) =>
      value == null || value.isEmpty ? validationMessage : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.tealAccent.withOpacity(0.8)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.tealAccent.withOpacity(0.8)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.tealAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dobController,
      readOnly: true,
      validator: (value) =>
      value == null || value.isEmpty ? 'Please enter your date of birth' : null,
      decoration: InputDecoration(
        labelText: 'Date of Birth (YYYY-MM-DD) *',
        labelStyle: TextStyle(color: Colors.tealAccent.withOpacity(0.8)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.tealAccent.withOpacity(0.8)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.tealAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
      ),
      style: TextStyle(color: Colors.white),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            _dobController.text = "${pickedDate.toLocal()}".split(' ')[0];
          });
        }
      },
    );
  }

  Widget _buildGlassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.tealAccent.withOpacity(0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.tealAccent.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
