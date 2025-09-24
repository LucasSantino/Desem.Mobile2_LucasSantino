import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/destino_item.dart';

class DestinoWidget extends StatefulWidget {
  final String nome;
  final String imagePath;
  final int valord; // valor da diária
  final int valorp; // valor por pessoa

  const DestinoWidget({
    super.key,
    required this.nome,
    required this.imagePath,
    required this.valord,
    required this.valorp,
  });

  @override
  State<DestinoWidget> createState() => _DestinoWidgetState();
}

class _DestinoWidgetState extends State<DestinoWidget> {
  int nDiarias = 0;
  int nPessoas = 0;
  int total = 0;
  String formaPagamento = 'cartao'; // default

  void dias() {
    setState(() {
      nDiarias += 1;
    });
  }

  void n_pessoas() {
    setState(() {
      nPessoas += 1;
    });
  }

  void limpar() {
    setState(() {
      nDiarias = 0;
      nPessoas = 0;
      total = 0;
      formaPagamento = 'cartao';
    });
  }

  void calctotalAndAddToCart(BuildContext context) {
    // cálculo bruto
    final calc = (nDiarias * widget.valord) + (nPessoas * widget.valorp);
    double totalDouble = calc.toDouble();
    if (formaPagamento == 'pix') {
      totalDouble = totalDouble * 0.9; // 10% desconto
    }
    setState(() {
      total = totalDouble.round();
    });

    final item = DestinoItem(
      nome: widget.nome,
      nDiarias: nDiarias,
      nPessoas: nPessoas,
      valorDiaria: widget.valord,
      valorPessoa: widget.valorp,
      total: totalDouble,
      formaPagamento: formaPagamento,
    );

    // Adiciona ao carrinho com Provider
    Provider.of<CartModel>(context, listen: false).addItem(item);

    // Exibe confirmação simples
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Adicionado ao carrinho: ${widget.nome} — total R\$ ${totalDouble.toStringAsFixed(2)}')),
    );
  }

  void showPaymentDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolha a forma de pagamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                value: 'pix',
                groupValue: formaPagamento,
                title: const Text('PIX (10% desconto)'),
                onChanged: (v) => setState(() => formaPagamento = v ?? 'pix'),
              ),
              RadioListTile<String>(
                value: 'cartao',
                groupValue: formaPagamento,
                title: const Text('Cartão / Outros'),
                onChanged: (v) => setState(() => formaPagamento = v ?? 'cartao'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                calctotalAndAddToCart(ctx);
              },
              child: const Text('Confirmar e adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 393,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
        boxShadow: const [BoxShadow(blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Imagem e topo
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Texto e botões
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.nome, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Valor diária: R\$ ${widget.valord}  •  R\$ ${widget.valorp} por pessoa'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // B1 - número de diárias
                      Column(
                        children: [
                          IconButton(
                            onPressed: dias,
                            icon: const Icon(Icons.add_circle_outline),
                            tooltip: 'Adicionar diária',
                          ),
                          Text('Diárias: $nDiarias'),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // B2 - número de acompanhantes
                      Column(
                        children: [
                          IconButton(
                            onPressed: n_pessoas,
                            icon: const Icon(Icons.person_add_alt_1),
                            tooltip: 'Adicionar acompanhante',
                          ),
                          Text('Acompanhantes: $nPessoas'),
                        ],
                      ),
                      const Spacer(),
                      // B4 - limpar
                      IconButton(
                        onPressed: limpar,
                        icon: const Icon(Icons.clear),
                        tooltip: 'Limpar',
                      ),
                      // B3 - calcular e adicionar
                      ElevatedButton.icon(
                        onPressed: () => showPaymentDialog(context),
                        icon: const Icon(Icons.calculate),
                        label: const Text('Calcular / Adicionar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // mostra total calculado localmente
                  Text('Total calculado: R\$ ${total.toString()}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}