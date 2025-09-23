import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout - Carrinho'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              child: cart.items.isEmpty
                  ? const Center(child: Text('Carrinho vazio'))
                  : ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, idx) {
                        final item = cart.items[idx];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.place),
                            title: Text(item.nome),
                            subtitle: Text('${item.nDiarias} diárias • ${item.nPessoas} acompanhantes\nPagamento: ${item.formaPagamento}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('R\$ ${item.total.toStringAsFixed(2)}'),
                                IconButton(
                                    onPressed: () {
                                      cart.removeAt(idx);
                                    },
                                    icon: const Icon(Icons.delete)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('R\$ ${cart.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: cart.items.isEmpty
                  ? null
                  : () {
                      // aqui você pode implementar finalização, salvar pedido ou reset
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Confirmar compra'),
                          content: Text('Total a pagar: R\$ ${cart.total.toStringAsFixed(2)}'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Voltar')),
                            ElevatedButton(
                              onPressed: () {
                                // Simula finalização: limpa carrinho e volta para home
                                cart.clear();
                                Navigator.popUntil(context, ModalRoute.withName('/'));
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compra finalizada com sucesso!')));
                              },
                              child: const Text('Confirmar'),
                            ),
                          ],
                        ),
                      );
                    },
              child: const SizedBox(width: double.infinity, child: Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Finalizar pedido')))),
            ),
          ],
        ),
      ),
    );
  }
}
