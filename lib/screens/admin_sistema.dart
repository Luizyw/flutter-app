import 'package:flutter/material.dart';
import '../models/funcionario.dart';

class AdminSistema extends StatefulWidget {
  const AdminSistema({super.key});

  @override
  State<AdminSistema> createState() => _AdminSistemaState();
}

class ItemCardapio {
  String tipo;
  String nome;
  double meta;
  double realizado;

  ItemCardapio({
    required this.tipo,
    required this.nome,
    required this.meta,
    required this.realizado,
  });

  double get percentual {
    if (meta == 0) return 0;
    return (realizado / meta) * 100;
  }
}

class _AdminSistemaState extends State<AdminSistema> {
  final TextEditingController faturamentoController = TextEditingController();

  List<Funcionario> funcionarios = [];
  List<ItemCardapio> cardapio = [];

  double lerValor(String valor) {
    String texto = valor
        .replaceAll("R\$", "")
        .replaceAll(".", "")
        .replaceAll(",", ".")
        .trim();

    return double.tryParse(texto) ?? 0.0;
  }

  String moeda(double valor) {
    return "R\$ ${valor.toStringAsFixed(2).replaceAll(".", ",")}";
  }

  String porcentagem(double valor) {
    return "${valor.toStringAsFixed(2).replaceAll(".", ",")}%";
  }

  double get faturamento {
    return lerValor(faturamentoController.text);
  }

  double get totalFolha {
    double total = 0.0;

    for (final funcionario in funcionarios) {
      total += funcionario.total;
    }

    return total;
  }

  double get cmoPercentual {
    if (faturamento == 0) return 0.0;
    return (totalFolha / faturamento) * 100;
  }

  Map<String, List<Funcionario>> get funcionariosPorCargo {
    final Map<String, List<Funcionario>> grupos = {};

    for (final funcionario in funcionarios) {
      final cargo = funcionario.cargo.trim().toUpperCase();

      if (cargo.isEmpty) continue;

      if (!grupos.containsKey(cargo)) {
        grupos[cargo] = [];
      }

      grupos[cargo]!.add(funcionario);
    }

    return grupos;
  }

  Map<String, List<ItemCardapio>> get cardapioPorTipo {
    final Map<String, List<ItemCardapio>> grupos = {};

    for (final item in cardapio) {
      final tipo = item.tipo.trim().toUpperCase();

      if (tipo.isEmpty) continue;

      if (!grupos.containsKey(tipo)) {
        grupos[tipo] = [];
      }

      grupos[tipo]!.add(item);
    }

    return grupos;
  }

  void adicionarFuncionario() {
    final nomeController = TextEditingController();
    final cargoController = TextEditingController();
    final salarioController = TextEditingController();
    final comissaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Adicionar funcionário"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: "Nome do funcionário",
                  ),
                ),
                TextField(
                  controller: cargoController,
                  decoration: const InputDecoration(
                    labelText: "Cargo",
                    hintText: "Ex: Garçom, Cozinha, Caixa",
                  ),
                ),
                TextField(
                  controller: salarioController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Salário",
                  ),
                ),
                TextField(
                  controller: comissaoController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Comissão",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final nome = nomeController.text.trim();
                final cargo = cargoController.text.trim();

                if (nome.isEmpty || cargo.isEmpty) {
                  return;
                }

                setState(() {
                  funcionarios.add(
                    Funcionario(
                      nome: nome,
                      cargo: cargo,
                      salario: lerValor(salarioController.text),
                      comissao: lerValor(comissaoController.text),
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void adicionarProduto() {
    final tipoController = TextEditingController();
    final nomeController = TextEditingController();
    final metaController = TextEditingController();
    final realizadoController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Adicionar produto"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: tipoController,
                  decoration: const InputDecoration(
                    labelText: "Tipo / Categoria",
                    hintText: "Ex: Entrada, Bebida, Drink",
                  ),
                ),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: "Nome do produto",
                    hintText: "Ex: Batata frita",
                  ),
                ),
                TextField(
                  controller: metaController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Meta",
                  ),
                ),
                TextField(
                  controller: realizadoController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: "Realizado",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                final tipo = tipoController.text.trim();
                final nome = nomeController.text.trim();

                if (tipo.isEmpty || nome.isEmpty) {
                  return;
                }

                setState(() {
                  cardapio.add(
                    ItemCardapio(
                      tipo: tipo,
                      nome: nome,
                      meta: lerValor(metaController.text),
                      realizado: lerValor(realizadoController.text),
                    ),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  void removerFuncionario(Funcionario funcionario) {
    setState(() {
      funcionarios.remove(funcionario);
    });
  }

  void removerProduto(ItemCardapio item) {
    setState(() {
      cardapio.remove(item);
    });
  }

  @override
  void dispose() {
    faturamentoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gruposFuncionarios = funcionariosPorCargo;
    final gruposCardapio = cardapioPorTipo;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sistema do Restaurante"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titulo("RESUMO DO MÊS"),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: faturamentoController,
                      onChanged: (_) => setState(() {}),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: "Faturamento do mês",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    linhaResumo("Total da folha", moeda(totalFolha)),
                    linhaResumo("CMO automático", porcentagem(cmoPercentual)),
                  ],
                ),
              ),
            ),

            titulo("FUNCIONÁRIOS / CMO"),
            botaoAdicionar(
              texto: "Adicionar funcionário",
              icone: Icons.person_add,
              onPressed: adicionarFuncionario,
            ),
            const SizedBox(height: 8),

            if (gruposFuncionarios.isEmpty)
              aviso("Nenhum funcionário cadastrado ainda."),

            ...gruposFuncionarios.entries.map((entry) {
              final cargo = entry.key;
              final lista = entry.value;

              final totalCargo = lista.fold<double>(
                0.0,
                (soma, funcionario) => soma + funcionario.total,
              );

              return Card(
                child: ExpansionTile(
                  title: Text(
                    cargo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Total do cargo: ${moeda(totalCargo)}"),
                  children: lista.map((funcionario) {
                    return ListTile(
                      title: Text(funcionario.nome),
                      subtitle: Text(
                        "Salário: ${moeda(funcionario.salario)} | Comissão: ${moeda(funcionario.comissao)}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            moeda(funcionario.total),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () => removerFuncionario(funcionario),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }),

            titulo("CARDÁPIO / METAS POR CATEGORIA"),
            botaoAdicionar(
              texto: "Adicionar produto",
              icone: Icons.add,
              onPressed: adicionarProduto,
            ),
            const SizedBox(height: 8),

            if (gruposCardapio.isEmpty)
              aviso("Nenhum produto cadastrado ainda."),

            ...gruposCardapio.entries.map((entry) {
              final tipo = entry.key;
              final lista = entry.value;

              final totalMeta = lista.fold<double>(
                0.0,
                (soma, item) => soma + item.meta,
              );

              final totalRealizado = lista.fold<double>(
                0.0,
                (soma, item) => soma + item.realizado,
              );

              final percentualCategoria =
                  totalMeta == 0 ? 0.0 : (totalRealizado / totalMeta) * 100;

              return Card(
                child: ExpansionTile(
                  title: Text(
                    tipo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Meta: ${moeda(totalMeta)} | Realizado: ${moeda(totalRealizado)} | ${porcentagem(percentualCategoria)}",
                  ),
                  children: lista.map((item) {
                    return ListTile(
                      title: Text(item.nome),
                      subtitle: Text(
                        "Meta: ${moeda(item.meta)} | Realizado: ${moeda(item.realizado)}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            porcentagem(item.percentual),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () => removerProduto(item),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget titulo(String texto) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 18, bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget botaoAdicionar({
    required String texto,
    required IconData icone,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icone),
        label: Text(texto),
      ),
    );
  }

  Widget linhaResumo(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            valor,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget aviso(String texto) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(texto),
      ),
    );
  }
}