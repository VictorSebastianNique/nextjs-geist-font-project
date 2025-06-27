import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isTesting = false;
  String _testResult = '';

  void _testConnectivity() async {
    setState(() {
      _isTesting = true;
      _testResult = '';
    });

    // Simulate connectivity test (replace with real test logic)
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isTesting = false;
      _testResult = 'Conectividad exitosa';
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Número de teléfono de emergencia',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Dirección de correo electrónico',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isTesting ? null : _testConnectivity,
              child: _isTesting
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    )
                  : Text('Probar Conectividad'),
            ),
            SizedBox(height: 20),
            Text(
              _testResult,
              style: TextStyle(color: Colors.greenAccent, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
