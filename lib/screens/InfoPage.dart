import 'package:appcmdes/screens/MainPage.dart';
import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 150),
                      _buildContainer('assets/icons/campo-ips.jpg', 'Campo', '• Horário: 9:30 da manhã às 22:30 da noite\n• Possibilidade de reserva durante esse horário'),
                      const SizedBox(height: 20),
                      _buildContainer('assets/icons/sala-fitness.jpg', 'Sala de Fitness', '• Horário: 9:30 da manhã às 22:30 da noite\n• Possibilidade de reserva durante esse horário'),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                    );
                  },
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(String imagePath, String label, String info) {
    return SingleChildScrollView(
      child: Container(
        width: 360,
        height: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Image.asset(
                imagePath,
                width: 180,
                height: 130,
              ),
              const SizedBox(height: 8),
              Text(
                info,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
