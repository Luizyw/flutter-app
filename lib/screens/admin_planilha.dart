import 'package:flutter/material.dart';

class AdminPlanilha extends StatefulWidget {
  final String nomeRestaurante;

  const AdminPlanilha({
    super.key,
    required this.nomeRestaurante,
  });

  @override
  State<AdminPlanilha> createState() => _AdminPlanilhaState();
}

class _AdminPlanilhaState extends State<AdminPlanilha> {
  final clienteController = TextEditingController();
  final metaMensalController = TextEditingController();
  final faturamentoController = TextEditingController();

  final List<TextEditingController> semanaMeta =
      List.generate(4, (_) => TextEditingController());
  final List<TextEditingController> semanaRealizado =
      List.generate(4, (_) => TextEditingController());

  final estoqueInicialAlimento = TextEditingController();
  final comprasAlimento = TextEditingController();
  final estoqueFinalAlimento = TextEditingController();

  final estoqueInicialBebida = TextEditingController();
  final comprasBebida = TextEditingController();
  final estoqueFinalBebida = TextEditingController();

  final List<Map<String, TextEditingController>> funcionarios = List.generate(
    8,
    (_) => {
      "nome": TextEditingController(),
      "cargo": TextEditingController(),
      "salario": TextEditingController(),
      "comissao": TextEditingController(),
    },
  );

  final materiaisGerais = TextEditingController();
  final pessoal = TextEditingController();
  final administrativas = TextEditingController();
  final financeiras = TextEditingController();
  final outras = TextEditingController();

  final List<TextEditingController> metasDiarias =
      List.generate(31, (_) => TextEditingController());
  final List<TextEditingController> realizadoDiario =
      List.generate(31, (_) => TextEditingController());

  double ler(TextEditingController c) {
    String texto = c.text
        .replaceAll("R\$", "")
        .replaceAll(".", "")
        .replaceAll(",", ".")
        .trim();

    return double.tryParse(texto) ?? 0.0;
  }

  String moeda(double valor) {
    return "R\$ ${valor.toStringAsFixed(2).replaceAll(".", ",")}";
  }

  String percentual(double valor) {
    return "${valor.toStringAsFixed(2).replaceAll(".", ",")}%";
  }

  double perc(double meta, double realizado) {
    if (meta == 0) return 0.0;
    return (realizado / meta) * 100;
  }

  void atualizar() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final double faturamento = ler(faturamentoController);
    final double metaMensal = ler(metaMensalController);

    final double faltaMeta = metaMensal - faturamento;
    final double metaPercentual = perc(metaMensal, faturamento);

    final double cmvAlimento =
        ler(estoqueInicialAlimento) + ler(comprasAlimento) - ler(estoqueFinalAlimento);

    final double cmvBebida =
        ler(estoqueInicialBebida) + ler(comprasBebida) - ler(estoqueFinalBebida);

    final double cmvGeral = cmvAlimento + cmvBebida;

    final double cmvPercentual =
        faturamento > 0 ? (cmvGeral / faturamento) * 100 : 0.0;

    double totalFolha = 0.0;
    for (final f in funcionarios) {
      totalFolha += ler(f["salario"]!) + ler(f["comissao"]!);
    }

    final double cmoPercentual =
        faturamento > 0 ? (totalFolha / faturamento) * 100 : 0.0;

    final double totalDespesas = ler(materiaisGerais) +
        ler(pessoal) +
        ler(administrativas) +
        ler(financeiras) +
        ler(outras);

    final double resultadoOperacional =
        faturamento - cmvGeral - totalFolha - totalDespesas;

    final double lucroPercentual =
        faturamento > 0 ? (resultadoOperacional / faturamento) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("DRE - ${widget.nomeRestaurante}"),
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            secao("1. RESUMO DO MÊS"),
            tabelaResumo([
              linhaCampo("Cliente / Restaurante", clienteController),
              linhaCampo("Faturamento", faturamentoController),
              linhaCampo("Meta mensal", metaMensalController),
              linhaResultado("Falta para bater meta", moeda(faltaMeta)),
              linhaResultado("Meta atingida", percentual(metaPercentual)),
              linhaResultado("CMV geral", percentual(cmvPercentual)),
              linhaResultado("CMO geral", percentual(cmoPercentual)),
              linhaResultado(
                "Lucro / Prejuízo",
                moeda(resultadoOperacional),
                cor: resultadoOperacional >= 0 ? Colors.green : Colors.red,
              ),
            ]),

            secao("2. METAS SEMANAIS"),
            tabelaMetasSemanais(),

            secao("3. CMV DETALHADO"),
            tabelaCMV("ALIMENTO", estoqueInicialAlimento, comprasAlimento,
                estoqueFinalAlimento, cmvAlimento),
            tabelaCMV("BEBIDAS", estoqueInicialBebida, comprasBebida,
                estoqueFinalBebida, cmvBebida),
            tabelaResumo([
              linhaResultado("CMV geral automático", moeda(cmvGeral)),
              linhaResultado("CMV geral %", percentual(cmvPercentual)),
            ]),

            secao("4. FUNCIONÁRIOS / CMO"),
            tabelaFuncionarios(totalFolha, cmoPercentual),

            secao("5. DESPESAS"),
            tabelaResumo([
              linhaCampo("Materiais gerais", materiaisGerais),
              linhaCampo("Pessoal", pessoal),
              linhaCampo("Administrativas", administrativas),
              linhaCampo("Financeiras", financeiras),
              linhaCampo("Outras despesas", outras),
              linhaResultado("Total de despesas", moeda(totalDespesas)),
            ]),

            secao("6. DRE FINAL"),
            tabelaResumo([
              linhaResultado("Faturamento", moeda(faturamento)),
              linhaResultado("CMV", moeda(cmvGeral)),
              linhaResultado("CMO / Folha", moeda(totalFolha)),
              linhaResultado("Despesas", moeda(totalDespesas)),
              linhaResultado("Resultado operacional",
                  moeda(resultadoOperacional),
                  cor: resultadoOperacional >= 0
                      ? Colors.green
                      : Colors.red),
              linhaResultado(
                  "Lucro percentual", percentual(lucroPercentual),
                  cor:
                      lucroPercentual >= 0 ? Colors.green : Colors.red),
            ]),

            secao("7. VENDAS DIÁRIAS"),
            tabelaVendasDiarias(),
          ],
        ),
      ),
    );
  }

  Widget secao(String titulo) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 18, bottom: 6),
      padding: const EdgeInsets.all(10),
      color: Colors.grey.shade800,
      child: Text(
        titulo,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget tabelaResumo(List<Widget> linhas) {
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      child: Column(children: linhas),
    );
  }

  Widget linhaCampo(String nome, TextEditingController controller) {
    return Row(
      children: [
        Expanded(child: Text(nome)),
        SizedBox(
          width: 140,
          child: TextField(
            controller: controller,
            onChanged: (_) => atualizar(),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget linhaResultado(String nome, String valor, {Color? cor}) {
    return Row(
      children: [
        Expanded(child: Text(nome)),
        Text(valor,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: cor ?? Colors.black)),
      ],
    );
  }

  Widget tabelaMetasSemanais() {
    return Column(
      children: List.generate(4, (i) {
        final meta = ler(semanaMeta[i]);
        final real = ler(semanaRealizado[i]);

        return Row(
          children: [
            Text("Semana ${i + 1}"),
            Expanded(
                child: TextField(
                    controller: semanaMeta[i],
                    onChanged: (_) => atualizar())),
            Expanded(
                child: TextField(
                    controller: semanaRealizado[i],
                    onChanged: (_) => atualizar())),
            Text(percentual(perc(meta, real))),
          ],
        );
      }),
    );
  }

  Widget tabelaCMV(String titulo, TextEditingController i,
      TextEditingController c, TextEditingController f, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        linhaCampo("Inicial", i),
        linhaCampo("Compras", c),
        linhaCampo("Final", f),
        linhaResultado("CMV", moeda(total)),
      ],
    );
  }

  Widget tabelaFuncionarios(double total, double perc) {
    return Column(
      children: [
        ...funcionarios.map((f) {
          final soma = ler(f["salario"]!) + ler(f["comissao"]!);

          return Column(
            children: [
              linhaCampo("Nome", f["nome"]!),
              linhaCampo("Cargo", f["cargo"]!),
              linhaCampo("Salário", f["salario"]!),
              linhaCampo("Comissão", f["comissao"]!),
              linhaResultado("Total", moeda(soma)),
              const Divider(),
            ],
          );
        }),
        linhaResultado("Total folha", moeda(total)),
        linhaResultado("CMO %", percentual(perc)),
      ],
    );
  }

  Widget tabelaVendasDiarias() {
    return Column(
      children: List.generate(31, (i) {
        final meta = ler(metasDiarias[i]);
        final real = ler(realizadoDiario[i]);

        return Row(
          children: [
            Text("${i + 1}"),
            Expanded(
                child: TextField(
                    controller: metasDiarias[i],
                    onChanged: (_) => atualizar())),
            Expanded(
                child: TextField(
                    controller: realizadoDiario[i],
                    onChanged: (_) => atualizar())),
            Text(percentual(perc(meta, real))),
          ],
        );
      }),
    );
  }
}