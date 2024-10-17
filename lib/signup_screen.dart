import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:first_app/validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> with Validator {
  final formKey = GlobalKey<FormState>();

  // Define controllers for input fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Jangan lupa dispose controller setelah selesai digunakan
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final email = emailController.text;
    final password = passwordController.text;

    try {
      // Sign up menggunakan Supabase
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.session != null) {
        // Jika sign-up berhasil, arahkan ke halaman login atau berikan notifikasi sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-up berhasil. Silakan login.')),
        );
        Navigator.pop(
            context); // Kembali ke halaman login setelah sign-up berhasil
      }
    } on Supabase catch (e) {
      // Tangkap error dan tampilkan pesan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              emailField(),
              passwordField(),
              signUpButton(),
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

  Widget signUpButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
      ),
      onPressed: () {
        if (formKey.currentState?.validate() == true) {
          _signUp(); // Memanggil fungsi sign-up Supabase
        }
      },
      child: const Text(
        'Sign Up',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
