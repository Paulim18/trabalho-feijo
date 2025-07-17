import 'package:flutter/material.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? loginError;

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (_formKey.currentState!.validate()) {
      if (email == 'admin@email.com' && password == '123456') {
        setState(() {
          loginError = null;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } else {
        setState(() {
          loginError = "Email ou senha inválidos";
        });
      }
    } else {
      setState(() {
        loginError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TaskList")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text(
                  'Realize o login para acessar o TaskList',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // cor mais visível
                  ),
                ),
              ),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  errorStyle: TextStyle(
                    color: Color(0xFFD32F2F), // vermelho vibrante
                    fontWeight: FontWeight.bold,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty ? "Informe o email" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Senha",
                  errorStyle: TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? "Informe a senha" : null,
              ),
              const SizedBox(height: 16),

              if (loginError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    loginError!,
                    style: const TextStyle(
                      color: Color(0xFFD32F2F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ElevatedButton(
                onPressed: _login,
                child: const Text("Entrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
