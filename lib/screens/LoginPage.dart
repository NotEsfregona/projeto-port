import 'package:appcmdes/screens/MainPage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:appcmdes/screens/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  String warningText = 'Introduza o seu email.';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _submitting = false;

  String? emailValidator(String? value) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (value == null || value.isEmpty) {
      return warningText;
    } else if (!emailRegex.hasMatch(value)) {
      return 'Introduza um email válido.';
    }
    return null;
  }




  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _submitting = true;
      });

      try {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', _emailController.text.trim());
        prefs.setBool('login', true);

        final DatabaseReference _database =FirebaseDatabase.instance.ref('users/');
        
        

         if (!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MainPage(),
        ));
      } 
        on FirebaseAuthException catch (e) {
        
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: "Erro ",
            desc: 'A password ou o email estão incorretos.',
            btnOkOnPress: () {},
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red,
          ).show();
        

        setState(() {
          _submitting = false;
        });
      }
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
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16.0, 0.0, 16.0, 100.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset("assets/login/ips-logo.png",
                                height: 250),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType:
                                          TextInputType.emailAddress,
                                      textInputAction:
                                          TextInputAction.next,
                                      cursorColor: const Color.fromARGB(
                                          189, 0, 0, 0),
                                      cursorErrorColor:
                                          const Color.fromARGB(
                                              189, 0, 0, 0),
                                      controller: _emailController,
                                      validator: emailValidator,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Defina o raio da borda conforme desejado
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Defina o raio da borda conforme desejado
                                        ),
                                        floatingLabelStyle:
                                            const TextStyle(
                                                color: Colors.black),
                                        suffixStyle: const TextStyle(
                                            color: Colors.black),
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        iconColor: Colors.black,
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            162, 255, 255, 255),
                                        labelText: 'E-mail',
                                        prefixIcon: const Icon(
                                            Icons.email_rounded),
                                        errorMaxLines: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textInputAction:
                                          TextInputAction.done,
                                      cursorColor: const Color.fromARGB(
                                          189, 0, 0, 0),
                                      cursorErrorColor:
                                          const Color.fromARGB(
                                              189, 0, 0, 0),
                                      controller: _passwordController,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          return 'Introduza a password.';
                                        }

                                        // Verificar o comprimento da password
                                        if (value.length < 8 ||
                                            value.length > 12) {
                                          return 'A password deve conter entre 8 e 12 caracteres.';
                                        }

                                        // Verificar se a password contém pelo menos uma letra maiúscula e um número
                                        if (!RegExp(
                                                r'^(?=.*[A-Z])(?=.*\d).*$')
                                            .hasMatch(value)) {
                                          return 'A password deve conter pelo menos uma letra maiúscula e um número.';
                                        }

                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Defina o raio da borda conforme desejado
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Defina o raio da borda conforme desejado
                                        ),
                                        labelText: 'Password',
                                        errorMaxLines: 2,
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            162, 255, 255, 255),
                                        floatingLabelStyle:
                                            const TextStyle(
                                                color: Colors.black),
                                        suffixStyle: const TextStyle(
                                            color: Colors.black),
                                        counterStyle: const TextStyle(
                                            color: Colors.black),
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        iconColor: Colors.black,
                                        prefixIcon:
                                            const Icon(Icons.lock),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureText =
                                                  !_obscureText;
                                            });
                                          },
                                          child: Icon(
                                            _obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.black,
                                            size: 27,
                                          ),
                                        ),
                                      ),
                                      obscureText: _obscureText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _login();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.red, // Cor de fundo do botão
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Raio de borda do botão
                                  ),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const Registerpage(),
                                    ),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Não possui conta? ",
                                      style:
                                          TextStyle(color: Colors.black),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text: 'Registe-se',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          decoration:
                                              TextDecoration.underline,
                                          decorationColor: Colors.black,
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
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
