import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../services/auth_service.dart';

/// ==========================
/// ETAPA 1
/// ==========================
class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final emailController = TextEditingController();
  final celularController = TextEditingController();
  final cnpjController = TextEditingController();
  final responsavelController = TextEditingController();
  final restauranteController = TextEditingController();

  final celularMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  void mostrarMensagem(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void proximo() {
    if (emailController.text.isEmpty ||
        celularController.text.isEmpty ||
        cnpjController.text.isEmpty ||
        responsavelController.text.isEmpty ||
        restauranteController.text.isEmpty) {
      mostrarMensagem("Preencha todos os campos");
      return;
    }

    if (celularMask.getUnmaskedText().length < 11) {
      mostrarMensagem("Celular inválido");
      return;
    }

    if (cnpjMask.getUnmaskedText().length < 14) {
      mostrarMensagem("CNPJ inválido");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroSenhaPage(
          email: emailController.text,
          restaurante: restauranteController.text,
          celular: celularMask.getUnmaskedText(),
          cnpj: cnpjMask.getUnmaskedText(),
          responsavel: responsavelController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro - Etapa 1")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
              TextField(controller: celularController, keyboardType: TextInputType.phone, inputFormatters: [celularMask], decoration: const InputDecoration(labelText: "Celular")),
              TextField(controller: cnpjController, keyboardType: TextInputType.number, inputFormatters: [cnpjMask], decoration: const InputDecoration(labelText: "CNPJ")),
              TextField(controller: responsavelController, decoration: const InputDecoration(labelText: "Responsável")),
              TextField(controller: restauranteController, decoration: const InputDecoration(labelText: "Restaurante")),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: proximo,
                child: const Text("Próximo"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// ==========================
/// ETAPA 2
/// ==========================
class CadastroSenhaPage extends StatefulWidget {
  final String email;
  final String restaurante;
  final String celular;
  final String cnpj;
  final String responsavel;

  const CadastroSenhaPage({
    super.key,
    required this.email,
    required this.restaurante,
    required this.celular,
    required this.cnpj,
    required this.responsavel,
  });

  @override
  State<CadastroSenhaPage> createState() => _CadastroSenhaPageState();
}

class _CadastroSenhaPageState extends State<CadastroSenhaPage> {
  final senhaController = TextEditingController();
  final confirmarController = TextEditingController();

  bool obscureSenha = true;

  bool temTamanho = false;
  bool temMaiuscula = false;
  bool temNumero = false;
  bool temEspecial = false;

  void validarSenhaTempoReal(String senha) {
    setState(() {
      temTamanho = senha.length >= 8;
      temMaiuscula = senha.contains(RegExp(r'[A-Z]'));
      temNumero = senha.contains(RegExp(r'[0-9]'));
      temEspecial = senha.contains(RegExp(r'[!@#\$&*~]'));
    });
  }

  Widget buildRequisito(String texto, bool valido) {
    return Row(
      children: [
        Icon(valido ? Icons.check : Icons.close,
            color: valido ? Colors.green : Colors.red, size: 16),
        const SizedBox(width: 5),
        Text(texto,
            style: TextStyle(
                color: valido ? Colors.green : Colors.red, fontSize: 12)),
      ],
    );
  }

  bool validarSenha(String senha) {
    final regex =
        RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$');
    return regex.hasMatch(senha);
  }

  void mostrarMensagem(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void finalizarCadastro() async {
    final service = AuthService();

    if (senhaController.text != confirmarController.text) {
      mostrarMensagem("Senhas não coincidem");
      return;
    }

    if (!validarSenha(senhaController.text)) {
      mostrarMensagem("Senha inválida");
      return;
    }

    final dados = {
      "email": widget.email,
      "senha": senhaController.text,
      "celular": widget.celular,
      "cnpj": widget.cnpj,
      "responsavel": widget.responsavel,
      "restaurante": widget.restaurante,
    };

    bool sucesso = await service.cadastrarUsuario(dados);

    if (sucesso) {
      mostrarMensagem("Cadastro realizado com sucesso");
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      mostrarMensagem("Erro ao cadastrar");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro - Etapa 2")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Email: ${widget.email}"),
            Text("Restaurante: ${widget.restaurante}"),

            const SizedBox(height: 20),

            TextField(
              controller: senhaController,
              onChanged: validarSenhaTempoReal,
              obscureText: obscureSenha,
              decoration: const InputDecoration(
                labelText: "Senha",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRequisito("Mínimo 8 caracteres", temTamanho),
                buildRequisito("1 letra maiúscula", temMaiuscula),
                buildRequisito("1 número", temNumero),
                buildRequisito("1 caractere especial", temEspecial),
              ],
            ),

            const SizedBox(height: 10),

            TextField(
              controller: confirmarController,
              obscureText: obscureSenha,
              decoration: const InputDecoration(
                labelText: "Confirmar senha",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: finalizarCadastro,
              child: const Text("Finalizar Cadastro"),
            ),
          ],
        ),
      ),
    );
  }
}

