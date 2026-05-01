import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'cadastro.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool obscureSenha = true;

  void mostrarMensagem(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void loginCliente() async {
    final service = AuthService();

    String email = emailController.text.trim();
    String senha = senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      mostrarMensagem("Preencha todos os campos");
      return;
    }

    bool sucesso = await service.login(email, senha);

    if (sucesso) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeCliente(),
        ),
      );
    } else {
      mostrarMensagem("Email ou senha inválidos");
    }
  }

  void loginAdmin() {
    mostrarMensagem("Área de administrador em desenvolvimento");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // EMAIL
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // SENHA
            TextField(
              controller: senhaController,
              obscureText: obscureSenha,
              decoration: InputDecoration(
                labelText: "Senha",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureSenha
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureSenha = !obscureSenha;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loginCliente,
              child: const Text("Entrar como Cliente"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: loginAdmin,
              child: const Text("Entrar como Administrador"),
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadastroPage(),
                  ),
                );
              },
              child: const Text("Não tem conta? Criar conta"),
            ),
          ],
        ),
      ),
    );
  }
}

// TELA CLIENTE
class HomeCliente extends StatelessWidget {
  const HomeCliente({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Área do Cliente"),
      ),
      body: const Center(
        child: Text("Bem-vindo, cliente!"),
      ),
    );
  }
}