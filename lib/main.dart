import 'package:flutter/material.dart';

void main() {
  runApp(AplicacaoBancaria());
}

class AplicacaoBancaria extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicação Bancária',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: TelaFormulario(),
    );
  }
}

class TelaFormulario extends StatefulWidget {
  @override
  _TelaFormularioState createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  List<Map<String, String>> _dadosTransacoes = [];

  void _adicionarTransacao() {
    setState(() {
      _dadosTransacoes.add({
        'nome': _nomeController.text,
        'valor': _valorController.text,
      });
      _nomeController.clear();
      _valorController.clear();
    });
  }

  void _navegarParaLista(BuildContext context) async {
    // A função push retorna um valor quando a tela chamada é fechada
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaLista(dadosTransacoes: _dadosTransacoes),
      ),
    );

    if (resultado != null) {
      setState(() {
        _dadosTransacoes = resultado;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome da Transação'),
            ),
            TextField(
              controller: _valorController,
              decoration: InputDecoration(labelText: 'Valor da Transação'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _adicionarTransacao,
              child: Text('Adicionar Transação'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _navegarParaLista(context),
              child: Text('Ver Transações'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelaLista extends StatelessWidget {
  final List<Map<String, String>> dadosTransacoes;

  TelaLista({required this.dadosTransacoes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Transações'),
      ),
      body: ListView.builder(
        itemCount: dadosTransacoes.length,
        itemBuilder: (context, index) {
          final transacao = dadosTransacoes[index];
          return Card(
            child: ListTile(
              title: Text(transacao['nome'] ?? ''),
              subtitle: Text('Valor: R\$${transacao['valor'] ?? ''}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Remove o item da lista e retorna a nova lista para a tela anterior
                  Navigator.pop(context, _removerTransacao(index));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _removerTransacao(int index) {
    dadosTransacoes.removeAt(index);
    return dadosTransacoes;
  }
}
