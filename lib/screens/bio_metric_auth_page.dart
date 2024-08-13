
import 'package:dars_95/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    List<BiometricType> availableBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      availableBiometrics = await auth.getAvailableBiometrics();
    } catch (e) {
      canCheckBiometrics = false;
      availableBiometrics = [];
    }
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
      _availableBiometrics = availableBiometrics;
    });

    if (_canCheckBiometrics && _availableBiometrics.isNotEmpty) {
      _authenticate();
    } else {
      _showPinInput();
      _promptBiometricSetup();
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Biometrik autentifikatsiyadan o\'ting',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      authenticated = false;
    }
    setState(() {
      _isAuthenticated = authenticated;
    });

    if (authenticated) {
      _navigateToHomePage();
    } else {
      _showPinInput();
    }
  }

  void _showPinInput() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PinInputPage(),
    ));
  }

  void _promptBiometricSetup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Biometrik autentifikatsiyani sozlang'),
        content: Text('Biometrik autentifikatsiyani sozlashni xohlaysizmi? '
            'Bu orqali keyingi kirishlarda qulaylik yaratishingiz mumkin.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Yo\'q'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _setupBiometrics();
            },
            child: Text('Ha'),
          ),
        ],
      ),
    );
  }

  void _setupBiometrics() async {
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (canCheckBiometrics && availableBiometrics.isNotEmpty) {
        _authenticate();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Biometrik autentifikatsiya mavjud emas yoki sozlanmagan.')),
        );
      }
    } catch (e) {
      print("Biometrik autentifikatsiyani sozlashda xato: $e");
    }
  }

  void _navigateToHomePage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => GameScreen(setupBiometrics: _setupBiometrics),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kirish')),
      body: Center(
        child: Text(
            'Iltimos, kirish uchun biometrik autentifikatsiyadan o\'ting yoki PIN kod kiriting.'),
      ),
    );
  }
}

class PinInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PIN Kiritish')),
      body: Center(
        child: Pinput(
          length: 4,
          onCompleted: (pin) {
            // PIN kiritilganda bajariladigan amallar
            print('Kiritilgan PIN: $pin');
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => GameScreen(
                setupBiometrics: () {},
              ),
            ));
          },
        ),
      ),
    );
  }
}
