import 'package:flutter/foundation.dart';

import '../models/transacao.dart';

/// Estado compartilhado do app. As três páginas leem daqui: a inicial mostra
/// o saldo e a lista, a de cadastro adiciona, e a de resumo agrupa por
/// categoria. Como todas olham para a mesma instância, uma transação
/// cadastrada aparece nas outras páginas sem precisar passar nada por
/// parâmetro de rota.
class FinancasProvider extends ChangeNotifier {
  final List<Transacao> _transacoes = [];

  static const categorias = [
    'Alimentação',
    'Transporte',
    'Lazer',
    'Contas',
    'Salário',
    'Outros',
  ];

  // A lista é exposta só para leitura. Se a página pudesse dar add() direto
  // nela, o notifyListeners() não seria chamado e a tela não atualizaria.
  List<Transacao> get transacoes => List.unmodifiable(_transacoes);

  double get totalEntradas => _transacoes
      .where((t) => t.ehEntrada)
      .fold(0.0, (soma, t) => soma + t.valor);

  double get totalSaidas => _transacoes
      .where((t) => !t.ehEntrada)
      .fold(0.0, (soma, t) => soma + t.valor);

  double get saldo => totalEntradas - totalSaidas;

  /// Quanto foi gasto em cada categoria. Entradas ficam de fora porque o
  /// resumo serve para ver para onde o dinheiro está indo.
  Map<String, double> get gastosPorCategoria {
    final mapa = <String, double>{};
    for (final t in _transacoes.where((t) => !t.ehEntrada)) {
      mapa[t.categoria] = (mapa[t.categoria] ?? 0) + t.valor;
    }
    return mapa;
  }

  void adicionar({
    required String descricao,
    required double valor,
    required bool ehEntrada,
    required String categoria,
  }) {
    // A mais recente entra no topo, que é onde a pessoa espera ver o que
    // acabou de cadastrar.
    _transacoes.insert(
      0,
      Transacao(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        descricao: descricao,
        valor: valor,
        ehEntrada: ehEntrada,
        categoria: categoria,
        data: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void remover(String id) {
    _transacoes.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void limparTudo() {
    _transacoes.clear();
    notifyListeners();
  }
}

/// Formata em reais sem depender do pacote intl, para manter o projeto
/// só com o Provider como dependência extra.
String formatarReais(double valor) {
  return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
}
