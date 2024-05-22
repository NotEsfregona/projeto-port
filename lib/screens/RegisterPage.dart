import 'package:appcmdes/screens/LoginPage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({Key? key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  bool _obscureText = true;
  String? selectedSchool;
  String? selectedUserType;
  String warningText = 'Por favor, preencha este campo.';
  String warningTextEmail = 'Introduza o seu email.';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _submitting = false;

  final DatabaseReference _database = FirebaseDatabase.instance.ref('users/');


  Future<void> _registerUser() async {
    setState(() {
      _submitting = true;
    });

    try {
        final DatabaseEvent event = await _database
          .orderByChild('email')
          .equalTo(_emailController.text)
          .once();

      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title:"Erro" ,
          desc: 'O Email já existe.',
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red,
        ).show();

        setState(() {
          _submitting = false;
        });

        return;
      }

      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      _database.push().set({
        'name': _nameController.text.trim(),
        'school': selectedSchool,
        'usertype': selectedUserType,
        'email': _emailController.text.trim(),
      });



        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title:"Sucesso" ,
          desc: "O utilizador foi registado com sucesso!",
          btnOkOnPress: () {
            Navigator.of(context).pushReplacement(
            MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
          },
        ).show();

        setState(() {
          _submitting = false;
        });
      } catch (e) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          title:"Erro " ,
          desc: 'Não foi possivel registar o utilizador.',
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red,
        ).show();
        
        setState(() {
          _submitting = false;
        });
      }
  }

   String? emailValidator(String? value) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    if (value == null || value.isEmpty) {
      return warningTextEmail;
    } else if (!emailRegex.hasMatch(value)) {
      return 'Introduza um email válido.';
    }
    return null;
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
            child: _submitting
                ? const Center(child: CircularProgressIndicator( color: Colors.red,))
                : Center(
                    child: SingleChildScrollView(
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 100.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Image.asset("assets/login/ips-logo.png",
                                      height: 200),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: TextFormField(
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      controller: _nameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Introduza o seu nome completo.';
                                        }
                                        return null;
                                      },
                                      cursorColor:
                                          const Color.fromARGB(189, 0, 0, 0),
                                      cursorErrorColor:
                                          const Color.fromARGB(189, 0, 0, 0),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'Nome Completo',
                                        prefixIcon: const Icon(Icons.person),
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            162, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      controller: _emailController,
                                      validator: emailValidator,
                                      cursorColor:
                                          const Color.fromARGB(189, 0, 0, 0),
                                      cursorErrorColor:
                                          const Color.fromARGB(189, 0, 0, 0),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'E-mail',
                                        prefixIcon:
                                            const Icon(Icons.email_rounded),
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            162, 255, 255, 255),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      controller: _passwordController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Introduza a password.';
                                        }
                          
                                        // Verificar o comprimento da password
                                        if (value.length < 8 ||
                                            value.length > 12) {
                                          return 'A password deve conter entre 8 e 12 caracteres.';
                                        }
                          
                                        // Verificar se a password contém pelo menos uma letra maiúscula e um número
                                        if (!RegExp(r'^(?=.*[A-Z])(?=.*\d).*$')
                                            .hasMatch(value)) {
                                          return 'A password deve conter pelo menos uma letra maiúscula e um número.';
                                        }
                          
                                        return null;
                                      },
                                      obscureText: _obscureText,
                                      cursorColor:
                                          const Color.fromARGB(189, 0, 0, 0),
                                      cursorErrorColor:
                                          const Color.fromARGB(189, 0, 0, 0),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        labelText: 'Password',
                                        labelStyle: const TextStyle(
                                            color: Colors.black),
                                        filled: true,
                                        fillColor: const Color.fromARGB(
                                            162, 255, 255, 255),
                                        prefixIcon: const Icon(Icons.lock),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
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
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: DropdownButtonFormField<String>(
                                        value: selectedSchool,
                                        items: const [
                                          DropdownMenuItem(
                                            value: "ESTS",
                                            child: Text("ESTS"),
                                          ),
                                          DropdownMenuItem(
                                            value: "ESE",
                                            child: Text("ESE"),
                                          ),
                                          DropdownMenuItem(
                                            value: "ESS",
                                            child: Text("ESS"),
                                          ),
                                          DropdownMenuItem(
                                            value: "ESTB",
                                            child: Text("ESTB"),
                                          ),
                                          DropdownMenuItem(
                                            value: "ESCE",
                                            child: Text("ESCE"),
                                          ),
                                          DropdownMenuItem(
                                            value: "SCentrais",
                                            child: Text("S.Centrais"),
                                          ),
                                          DropdownMenuItem(
                                            value: "Externos",
                                            child: Text("Externos"),
                                          ),
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return warningText;
                                          }
                                          return null;
                                        },
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedSchool = newValue;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          labelText: 'Selecione uma escola',
                                          prefixIcon:
                                              const Icon(Icons.school_rounded),
                                          labelStyle: const TextStyle(
                                              color: Colors.black),
                                          filled: true,
                                          fillColor: const Color.fromARGB(
                                              164, 255, 255, 255),
                                        ),
                                      )),
                                  const SizedBox(height: 20),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: DropdownButtonFormField<String>(
                                        value: selectedUserType,
                                        items: const [
                                          DropdownMenuItem(
                                            value: "Bolseiro",
                                            child: Text("Bolseiro"),
                                          ),
                                          DropdownMenuItem(
                                            value: "NaoBolseiro",
                                            child: Text("Não Bolseiro"),
                                          ),
                                          DropdownMenuItem(
                                            value: "NaoDocentes",
                                            child: Text("Não Docentes"),
                                          ),
                                          DropdownMenuItem(
                                            value: "SocioAAIPS",
                                            child: Text("Sócio AAIPS"),
                                          ),
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return warningText;
                                          }
                                          return null;
                                        },
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedUserType = newValue;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          labelText:
                                              'Selecione o tipo de utilizador',
                                          prefixIcon: const Icon(
                                              Icons.supervised_user_circle),
                                          labelStyle: const TextStyle(
                                              color: Colors.black),
                                          filled: true,
                                          fillColor: const Color.fromARGB(
                                              164, 255, 255, 255),
                                        ),
                                      )),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        registerBtn();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        "Registar",
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
                                                const LoginPage(),
                                          ),
                                        );
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Já possui conta? ",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: 'Login',
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
        )
      );
    
    }

    void registerBtn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _submitting = true;
      });

      await _registerUser();
    }
  }

   @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}


