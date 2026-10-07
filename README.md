# Finanças do Dia a Dia

Aplicativo Flutter para organizar as finanças do dia a dia: registrar entradas e
gastos, acompanhar o saldo e ver para onde o dinheiro está indo.

Projeto individual da disciplina, usando **Provider** para gerenciamento de estado.

## Telas

- **Início** — saldo atual, total de entradas e saídas, lista de movimentações (com exclusão).
- **Nova movimentação** — cadastro de entrada ou saída com descrição, valor e categoria.
- **Resumo** — gastos agrupados por categoria com percentual, e opção de apagar tudo.

## Gerenciamento de estado

- `FinancasProvider` (`lib/providers/financas_provider.dart`) estende `ChangeNotifier`
  e guarda a lista de transações compartilhada entre as três telas.
- `adicionar`, `remover` e `limparTudo` alteram o estado e chamam `notifyListeners()`.
- O `ChangeNotifierProvider` fica acima do `MaterialApp` (`lib/main.dart`), então
  todas as rotas enxergam a mesma instância.
- As telas usam `context.watch` para reconstruir quando o estado muda e
  `context.read` nos botões que só disparam uma ação.

## Como rodar

```bash
flutter pub get
flutter run
```
