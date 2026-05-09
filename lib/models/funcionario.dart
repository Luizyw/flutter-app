class Funcionario {
  String nome;
  String cargo;
  double salario;
  double comissao;

  Funcionario({
    required this.nome,
    required this.cargo,
    required this.salario,
    required this.comissao,
  });

  double get total {
    return salario + comissao;
  }
}