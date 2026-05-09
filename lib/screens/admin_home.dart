import 'package:flutter/material.dart';
import 'admin_planilha.dart';
import 'admin_sistema.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  final List<String> restaurantes = const [
    "Bar do Lulu",
    "Restaurante Exemplo",
    "Pizzaria Modelo",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel do Administrador"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: Colors.black87,
            child: ListTile(
              leading: const Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              title: const Text(
                "Sistema inteligente",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                "Funcionários, CMO, cardápio e metas por categoria",
                style: TextStyle(color: Colors.white70),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminSistema(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Planilhas antigas por restaurante",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...restaurantes.map((restaurante) {
            return Card(
              child: ListTile(
                title: Text(restaurante),
                subtitle: const Text("Acessar planilha financeira"),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminPlanilha(
                        nomeRestaurante: restaurante,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}