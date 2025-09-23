class DestinoItem {
  final String nome;
  final int nDiarias;
  final int nPessoas;
  final int valorDiaria;
  final int valorPessoa;
  final double total;
  final String formaPagamento; // 'pix' ou 'cartao' etc.

  DestinoItem({
    required this.nome,
    required this.nDiarias,
    required this.nPessoas,
    required this.valorDiaria,
    required this.valorPessoa,
    required this.total,
    required this.formaPagamento,
  });
}
