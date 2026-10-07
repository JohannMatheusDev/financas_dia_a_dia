import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'providers/financas_provider.dart';

void main() {
  // O provider fica acima do MaterialApp para que todas as rotas
  // (inclusive as abertas com Navigator.push) enxerguem o mesmo estado.
  runApp(
    ChangeNotifierProvider(
      create: (_) => FinancasProvider(),
      child: const MeuApp(),
    ),
  );
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finanças do Dia a Dia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
