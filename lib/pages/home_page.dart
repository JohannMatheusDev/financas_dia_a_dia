import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/financas_provider.dart';
import 'nova_transacao_page.dart';
import 'resumo_page.dart';

/// Tela principal: saldo no topo e a lista de movimentações embaixo.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // watch faz esta tela reconstruir sempre que o provider chamar
    // notifyListeners(), por isso o saldo muda sozinho ao voltar do cadastro.
    final financas = context.watch<FinancasProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finanças do Dia a Dia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart),
            tooltip: 'Resumo',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ResumoPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _CartaoSaldo(
            saldo: financas.saldo,
            entradas: financas.totalEntradas,
            saidas: financas.totalSaidas,
          ),
          Expanded(
            child: financas.transacoes.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhuma movimentação ainda.\nToque no + para adicionar.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: financas.transacoes.length,
                    itemBuilder: (context, index) {
                      final t = financas.transacoes[index];
                      final cor = t.ehEntrada ? Colors.green : Colors.red;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: cor.withValues(alpha: 0.15),
                            child: Icon(
                              t.ehEntrada
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: cor,
                            ),
                          ),
                          title: Text(t.descricao),
                          subtitle: Text(
                            '${t.categoria} • '
                            '${t.data.day.toString().padLeft(2, '0')}/'
                            '${t.data.month.toString().padLeft(2, '0')}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${t.ehEntrada ? '+' : '-'} '
                                '${formatarReais(t.valor)}',
                                style: TextStyle(
                                  color: cor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                // read em vez de watch: aqui só disparamos
                                // uma ação, não precisamos ouvir mudanças.
                                onPressed: () => context
                                    .read<FinancasProvider>()
                                    .remover(t.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NovaTransacaoPage()),
        ),
      ),
    );
  }
}

class _CartaoSaldo extends StatelessWidget {
  final double saldo;
  final double entradas;
  final double saidas;

  const _CartaoSaldo({
    required this.saldo,
    required this.entradas,
    required this.saidas,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Saldo atual'),
            const SizedBox(height: 4),
            Text(
              formatarReais(saldo),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: saldo < 0 ? Colors.red : null,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Total(
                  rotulo: 'Entradas',
                  valor: entradas,
                  cor: Colors.green,
                ),
                _Total(rotulo: 'Saídas', valor: saidas, cor: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Total extends StatelessWidget {
  final String rotulo;
  final double valor;
  final Color cor;

  const _Total({required this.rotulo, required this.valor, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(rotulo),
        Text(
          formatarReais(valor),
          style: TextStyle(color: cor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
