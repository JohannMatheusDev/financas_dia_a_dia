import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/financas_provider.dart';

/// Formulário de cadastro. É StatefulWidget porque o que está sendo digitado
/// é estado local desta tela; só vai para o provider quando a pessoa salva.
class NovaTransacaoPage extends StatefulWidget {
  const NovaTransacaoPage({super.key});

  @override
  State<NovaTransacaoPage> createState() => _NovaTransacaoPageState();
}

class _NovaTransacaoPageState extends State<NovaTransacaoPage> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  bool _ehEntrada = false;
  String _categoria = FinancasProvider.categorias.first;

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    super.dispose();
  }

  // Aceita vírgula porque é o que se digita no Brasil; sem isto "12,50"
  // falharia no double.tryParse.
  double? _lerValor() =>
      double.tryParse(_valorController.text.trim().replaceAll(',', '.'));

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    context.read<FinancasProvider>().adicionar(
          descricao: _descricaoController.text.trim(),
          valor: _lerValor()!,
          ehEntrada: _ehEntrada,
          categoria: _categoria,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Movimentação adicionada!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova movimentação')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  label: Text('Saída'),
                  icon: Icon(Icons.arrow_upward),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('Entrada'),
                  icon: Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_ehEntrada},
              onSelectionChanged: (selecao) =>
                  setState(() => _ehEntrada = selecao.first),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Ex: Almoço, Uber, Salário',
                border: OutlineInputBorder(),
              ),
              validator: (texto) => (texto == null || texto.trim().isEmpty)
                  ? 'Informe uma descrição'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _valorController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
                hintText: 'Ex: 25,90',
                border: OutlineInputBorder(),
              ),
              validator: (_) {
                final valor = _lerValor();
                if (valor == null) return 'Informe um valor válido';
                if (valor <= 0) return 'O valor precisa ser maior que zero';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              items: FinancasProvider.categorias
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (valor) => setState(() => _categoria = valor!),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _salvar,
              icon: const Icon(Icons.check),
              label: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
