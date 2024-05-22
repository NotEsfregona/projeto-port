import 'package:appcmdes/screens/CalendarPage.dart';
import 'package:appcmdes/screens/LoginPage.dart';
import 'package:appcmdes/screens/MapPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? finalEmail;
  String? greeting;
  final DatabaseReference _database = FirebaseDatabase.instance.ref('users/');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _setGreeting();
  }

  Future<void> _initializeUser() async {
    await _getUserEmail();
    setState(() {});
  }

  Future<void> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    finalEmail = prefs.getString('email');
  }

  void _setGreeting() {
    var hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      greeting = 'Bom Dia';
    } else if (hour >= 12 && hour < 20) {
      greeting = 'Boa Tarde';
    } else {
      greeting = 'Boa Noite';
    }
  }

  Future<String?> _getUserName() async {
    if (finalEmail == null) return null;
    var snapshot = await _database.get();
    Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    for (var entry in data.entries) {
      var map = entry.value;
      if (finalEmail == map['email']) {
        return map['name'].split(' ')[0]; // Apenas o primeiro nome
      }
    }
    return null;
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.setBool('login', false);
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      _logout();
    } else {
      _pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/login/ipscampus.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(139, 255, 255, 255),
        body: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: PageView(
                  controller: _pageController,
                  children: [
                    _buildHomePage(),
                    const CalendarPage(),
                    Container(),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20),
                  child: GNav(
                    gap: 8,
                    padding: const EdgeInsets.all(4),
                    tabs: const [
                      GButton(
                        icon: Icons.home_outlined,
                      ),
                      GButton(
                        icon: Icons.calendar_month_outlined,
                      ),
                      GButton(
                        icon: Icons.logout_rounded,
                      ),
                    ],
                    onTabChange: _onItemTapped,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Image.asset(
            'assets/login/ips-logo.png',
            width: 70,
            height: 70,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 50.0), // Move a saudação para cima
          child: FutureBuilder<String?>(
            future: _getUserName(),
            builder: (context, snapshot) {
              final name = snapshot.data;
              final greetingText = name != null
                  ? TextSpan(
                      text: '$greeting, ',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: '$name',
                          style: const TextStyle(
                            color: Colors.red, // Nome do usuário em vermelho
                          ),
                        ),
                        const TextSpan(
                          text: '!', // Adicione o ponto de exclamação aqui
                          style: TextStyle(
                            color: Colors.black, // Altere a cor para preto
                          ),
                        ),
                      ],
                    )
                  : const TextSpan(
                      text: 'Olá, Utilizador!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
              return RichText(
                textAlign: TextAlign.center,
                text: greetingText,
              );
            },
          ),
        ),
        Expanded(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Implemente a lógica para o botão Info
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.only(
                        top: 10.0), // Move os contêineres para cima
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline, size: 50),
                        SizedBox(height: 10),
                        Text(
                          'Info',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => MapPage(),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    margin: const EdgeInsets.only(
                        top: 10), // Move os contêineres para cima
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 50),
                        SizedBox(height: 10),
                        Text(
                          'Mapa',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
