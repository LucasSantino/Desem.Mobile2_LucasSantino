import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  final String destino;
  final int nDiarias;
  final int nPessoas;
  final int valorDiaria;
  final int valorPessoa;

  const Checkout({
    Key? key,
    required this.destino,
    required this.nDiarias,
    required this.nPessoas,
    required this.valorDiaria,
    required this.valorPessoa,
  }) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  String formaPagamento = 'Cartão';

  // Total sem desconto
  double get totalSemDesconto {
    return (widget.nDiarias * widget.valorDiaria).toDouble() +
        (widget.nPessoas * widget.valorPessoa).toDouble();
  }

  // Total com desconto
  double get totalComDesconto {
    if (formaPagamento == 'PIX') {
      return totalSemDesconto * 0.9; // 10% de desconto
    }
    return totalSemDesconto;
  }

  // Função para confirmar a reserva
  void confirmarReserva() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Reserva Confirmada'),
        content: Text('Sua reserva para ${widget.destino} foi confirmada!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                ..pop() // Fecha o dialog
                ..pop(); // Fecha a tela de checkout e retorna à tela anterior
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout - ${widget.destino}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // Adiciona rolagem para telas menores
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumo da Viagem',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildInfoRow('Destino:', widget.destino),
              _buildInfoRow('Número de diárias:', widget.nDiarias.toString()),
              _buildInfoRow('Número de acompanhantes:', widget.nPessoas.toString()),
              _buildInfoRow('Valor diária:', 'R\$ ${widget.valorDiaria}'),
              _buildInfoRow('Valor por pessoa:', 'R\$ ${widget.valorPessoa}'),
              Divider(height: 32, thickness: 2),
              _buildInfoRow('Total sem desconto:', 'R\$ ${totalSemDesconto.toStringAsFixed(2)}'),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Forma de pagamento:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 20),
                  DropdownButton<String>(
                    value: formaPagamento,
                    items: ['PIX', 'Cartão']
                        .map((fp) => DropdownMenuItem(
                              value: fp,
                              child: Text(fp),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        formaPagamento = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildInfoRow(
                'Total com desconto:',
                'R\$ ${totalComDesconto.toStringAsFixed(2)}',
                isBold: true,
              ),
              SizedBox(height: 20),
              Align(  // Alinha o botão para a parte inferior da tela
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: totalComDesconto == 0
                      ? null
                      : () {
                          confirmarReserva();
                        },
                  child: Text('Confirmar Reserva'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),  // Tamanho fixo do botão
                    backgroundColor: Colors.blue,  // Cor personalizada para o botão
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para exibir as linhas de informações
  Widget _buildInfoRow(String label, String valor, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Spacer(),
          Text(
            valor,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
