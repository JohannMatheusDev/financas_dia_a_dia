import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/financas_provider.dart';

/// Mostra para onde o dinheiro está indo, somando os gastos por categoria.
/// Usa os mesmos dados da tela inicial, vindos do provider.
class ResumoPage extends StatelessWidget {
  const ResumoPage({super.key});

  Future<void> _confirmarLimpeza(BuildContext context) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Apagar tudo?'),
        content: const Text('Todas as movimentações serão removidas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
    if (confirmou == true && context.mounted) {
      context.read<FinancasProvider>().limparTudo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final financas = context.watch<FinancasProvider>();
    final gastos = financas.gastosPorCategoria.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Apagar tudo',
            onPressed: financas.transacoes.isEmpty
                ? null
                : () => _confirmarLimpeza(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Movimentações registradas'),
              trailing: Text(
                '${financas.transacoes.length}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Saldo'),
              trailing: Text(
                formatarReais(financas.saldo),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Gastos por categoria',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (gastos.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Nenhum gasto registrado ainda.'),
            )
          else
            ...gastos.map((g) {
              final percentual = g.value / financas.totalSaidas;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(g.key),
                        Text(
                          '${formatarReais(g.value)} '
                          '(${(percentual * 100).toStringAsFixed(0)}%)',
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentual,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
