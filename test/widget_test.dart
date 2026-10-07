import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:financas_dia_a_dia/main.dart';
import 'package:financas_dia_a_dia/providers/financas_provider.dart';

void main() {
  testWidgets('App abre com saldo zerado', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FinancasProvider(),
        child: const MeuApp(),
      ),
    );
    expect(find.text('Saldo atual'), findsOneWidget);
    expect(find.text('R\$ 0,00'), findsWidgets);
  });
}
