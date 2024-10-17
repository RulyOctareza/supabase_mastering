import 'package:first_app/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:first_app/digital_quran.dart';
import 'package:first_app/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with Validator {
  final formKey = GlobalKey<FormState>();

  // Define variable
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      // Login menggunakan Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        // Berhasil login, arahkan ke halaman berikutnya
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DigitalQuran()),
        );
      }
    } on Supabase catch (e) {
      // Jika terjadi error login, tangkap dan tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              emailField(),
              passwordField(),
              loginButton(),
              signUpScreen(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'email@example.com',
      ),
      controller: emailController,
      validator: (value) => validateEmail(value ?? ''),
    );
  }

  Widget passwordField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
        hintText: 'Enter Password',
      ),
      controller: passwordController,
      validator: (value) => validatePassword(value ?? ''),
    );
  }

  Widget loginButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
      ),
      onPressed: () {
        if (formKey.currentState?.validate() == true) {
          _login(); // Memanggil fungsi login Supabase
        }
      },
      child: const Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

Widget signUpScreen(BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueAccent,
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
    },
    child: const Text(
      'SignUp',
      style: TextStyle(color: Colors.white),
    ),
  );
}
