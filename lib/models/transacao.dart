/// Uma movimentação do dia a dia: um gasto (saída) ou um dinheiro que
/// entrou (entrada). O valor é sempre positivo; quem diz se soma ou
/// subtrai do saldo é o campo [ehEntrada].
class Transacao {
  final String id;
  final String descricao;
  final double valor;
  final bool ehEntrada;
  final String categoria;
  final DateTime data;

  Transacao({
    required this.id,
    required this.descricao,
    required this.valor,
    required this.ehEntrada,
    required this.categoria,
    required this.data,
  });
}
