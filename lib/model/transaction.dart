/// txnId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// txnPetUsrId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// txnBuyerUsrId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// txnAmount : 0
/// txnTimestamp : "2025-06-14T07:56:30.285Z"
/// txnBstId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// txnInstId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// txnDesc : "dynamic"
/// txnStatus : "dynamic"
/// txnCode : "dynamic"
/// txnType : "dynamic"

class Transaction {
  Transaction({
      dynamic txnId, 
      dynamic txnPetUsrId, 
      dynamic txnBuyerUsrId, 
      dynamic txnAmount, 
      dynamic txnTimestamp, 
      dynamic txnBstId, 
      dynamic txnInstId, 
      dynamic txnDesc, 
      dynamic txnStatus, 
      dynamic txnCode, 
      dynamic txnType,}){
    txnId = txnId;
    txnPetUsrId = txnPetUsrId;
    txnBuyerUsrId = txnBuyerUsrId;
    txnAmount = txnAmount;
    txnTimestamp = txnTimestamp;
    txnBstId = txnBstId;
    txnInstId = txnInstId;
    txnDesc = txnDesc;
    txnStatus = txnStatus;
    txnCode = txnCode;
    txnType = txnType;
}

  Transaction.fromJson(dynamic json) {
    txnId = json['txnId'];
    txnPetUsrId = json['txnPetUsrId'];
    txnBuyerUsrId = json['txnBuyerUsrId'];
    txnAmount = json['txnAmount'];
    txnTimestamp = json['txnTimestamp'];
    txnBstId = json['txnBstId'];
    txnInstId = json['txnInstId'];
    txnDesc = json['txnDesc'];
    txnStatus = json['txnStatus'];
    txnCode = json['txnCode'];
    txnType = json['txnType'];
  }
  dynamic txnId;
  dynamic txnPetUsrId;
  dynamic txnBuyerUsrId;
  dynamic txnAmount;
  dynamic txnTimestamp;
  dynamic txnBstId;
  dynamic txnInstId;
  dynamic txnDesc;
  dynamic txnStatus;
  dynamic txnCode;
  dynamic txnType;
Transaction copyWith({  dynamic txnId,
  dynamic txnPetUsrId,
  dynamic txnBuyerUsrId,
  dynamic txnAmount,
  dynamic txnTimestamp,
  dynamic txnBstId,
  dynamic txnInstId,
  dynamic txnDesc,
  dynamic txnStatus,
  dynamic txnCode,
  dynamic txnType,
}) => Transaction(  txnId: txnId ?? txnId,
  txnPetUsrId: txnPetUsrId ?? txnPetUsrId,
  txnBuyerUsrId: txnBuyerUsrId ?? txnBuyerUsrId,
  txnAmount: txnAmount ?? txnAmount,
  txnTimestamp: txnTimestamp ?? txnTimestamp,
  txnBstId: txnBstId ?? txnBstId,
  txnInstId: txnInstId ?? txnInstId,
  txnDesc: txnDesc ?? txnDesc,
  txnStatus: txnStatus ?? txnStatus,
  txnCode: txnCode ?? txnCode,
  txnType: txnType ?? txnType,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['txnId'] = txnId;
    map['txnPetUsrId'] = txnPetUsrId;
    map['txnBuyerUsrId'] = txnBuyerUsrId;
    map['txnAmount'] = txnAmount;
    map['txnTimestamp'] = txnTimestamp;
    map['txnBstId'] = txnBstId;
    map['txnInstId'] = txnInstId;
    map['txnDesc'] = txnDesc;
    map['txnStatus'] = txnStatus;
    map['txnCode'] = txnCode;
    map['txnType'] = txnType;
    return map;
  }

}