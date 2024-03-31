class PostModel {
  String? id;
  String? sendItem;
  String? receiveItem;
  double? sendAmount;
  double? receiveAmount;
  String? receiveAddress;
  String? contactNumber;
  String? transactionNumber;
  String? status;
  String? dateTime;
  String? email;
  double? revenueInBDT;
  String? activeAccount;
  String? activeAccountName;
  String? activeAccountId;
  PostModel({
    this.id,
    this.sendItem,
    this.receiveItem,
    this.sendAmount,
    this.receiveAmount,
    this.receiveAddress,
    this.contactNumber,
    this.transactionNumber,
    this.status,
    this.dateTime,
    this.email,
    this.revenueInBDT,
    this.activeAccount,
    this.activeAccountName,
    this.activeAccountId,
  });
}
