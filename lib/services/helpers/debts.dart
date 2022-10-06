class Debts {
  late int debt_id;
  late String product;
  late double price;
  late int fk_debtor;

  Debts(this.debt_id, this.product, this.price, this.fk_debtor);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'debt_id': debt_id,
      'product': product,
      'price': price,
      'fk_debtor': fk_debtor,

    };
    return map;
  }

  Debts.fromMap(Map<String, dynamic> map) {
    debt_id = map['debt_id'];
    product = map['product'];
    price = map['price'];
    fk_debtor = map['fk_debtor'];
  }
}
