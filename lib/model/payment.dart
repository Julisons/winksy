/// id : 6
/// transAmount : "1.00"
/// businessShortCode : "4095123"
/// billRefNumber : "101912501"
/// invoiceNumber : "UU33"
/// transTime : "20240712170052"
/// msisdn : "2547 ***** 822"
/// transactionType : null
/// transId : "SG2Yi8u"
/// orgAccountBalance : null
/// thirdPartyTransId : null
/// firstName : null
/// middleName : null
/// lastName : null
/// rcptNo : null
/// createdDate : null
/// createdTime : null
/// refId : null
/// transCreatedBy : null
/// transCreatedDate : null
/// transCreatedTime : null
/// transUpdatedBy : null
/// transUpdatedDate : null
/// transUpdatedTime : null
/// transDesc : null
/// transStatus : null
/// transCode : null
/// c2bStatus : null

class Payment {
  Payment({
      dynamic id, 
      dynamic transAmount, 
      dynamic businessShortCode, 
      dynamic billRefNumber, 
      dynamic invoiceNumber, 
      dynamic transTime, 
      dynamic msisdn, 
      dynamic transactionType, 
      dynamic transId, 
      dynamic orgAccountBalance, 
      dynamic thirdPartyTransId, 
      dynamic firstName, 
      dynamic middleName, 
      dynamic lastName, 
      dynamic rcptNo, 
      dynamic createdDate, 
      dynamic createdTime, 
      dynamic refId, 
      dynamic transCreatedBy, 
      dynamic transCreatedDate, 
      dynamic transCreatedTime, 
      dynamic transUpdatedBy, 
      dynamic transUpdatedDate, 
      dynamic transUpdatedTime, 
      dynamic transDesc, 
      dynamic transStatus, 
      dynamic transCode, 
      dynamic c2bStatus,}){
    _id = id;
    _transAmount = transAmount;
    _businessShortCode = businessShortCode;
    _billRefNumber = billRefNumber;
    _invoicedynamicber = invoiceNumber;
    _transTime = transTime;
    _msisdn = msisdn;
    _transactionType = transactionType;
    _transId = transId;
    _orgAccountBalance = orgAccountBalance;
    _thirdPartyTransId = thirdPartyTransId;
    _firstName = firstName;
    _middleName = middleName;
    _lastName = lastName;
    _rcptNo = rcptNo;
    _createdDate = createdDate;
    _createdTime = createdTime;
    _refId = refId;
    _transCreatedBy = transCreatedBy;
    _transCreatedDate = transCreatedDate;
    _transCreatedTime = transCreatedTime;
    _transUpdatedBy = transUpdatedBy;
    _transUpdatedDate = transUpdatedDate;
    _transUpdatedTime = transUpdatedTime;
    _transDesc = transDesc;
    _transStatus = transStatus;
    _transCode = transCode;
    _c2bStatus = c2bStatus;
}

  Payment.fromJson(dynamic json) {
    _id = json['id'];
    _transAmount = json['transAmount'];
    _businessShortCode = json['businessShortCode'];
    _billRefNumber = json['billRefNumber'];
    _invoicedynamicber = json['invoiceNumber'];
    _transTime = json['transTime'];
    _msisdn = json['msisdn'];
    _transactionType = json['transactionType'];
    _transId = json['transId'];
    _orgAccountBalance = json['orgAccountBalance'];
    _thirdPartyTransId = json['thirdPartyTransId'];
    _firstName = json['firstName'];
    _middleName = json['middleName'];
    _lastName = json['lastName'];
    _rcptNo = json['rcptNo'];
    _createdDate = json['createdDate'];
    _createdTime = json['createdTime'];
    _refId = json['refId'];
    _transCreatedBy = json['transCreatedBy'];
    _transCreatedDate = json['transCreatedDate'];
    _transCreatedTime = json['transCreatedTime'];
    _transUpdatedBy = json['transUpdatedBy'];
    _transUpdatedDate = json['transUpdatedDate'];
    _transUpdatedTime = json['transUpdatedTime'];
    _transDesc = json['transDesc'];
    _transStatus = json['transStatus'];
    _transCode = json['transCode'];
    _c2bStatus = json['c2bStatus'];
  }
  dynamic _id;
  dynamic _transAmount;
  dynamic _businessShortCode;
  dynamic _billRefNumber;
  dynamic _invoicedynamicber;
  dynamic _transTime;
  dynamic _msisdn;
  dynamic _transactionType;
  dynamic _transId;
  dynamic _orgAccountBalance;
  dynamic _thirdPartyTransId;
  dynamic _firstName;
  dynamic _middleName;
  dynamic _lastName;
  dynamic _rcptNo;
  dynamic _createdDate;
  dynamic _createdTime;
  dynamic _refId;
  dynamic _transCreatedBy;
  dynamic _transCreatedDate;
  dynamic _transCreatedTime;
  dynamic _transUpdatedBy;
  dynamic _transUpdatedDate;
  dynamic _transUpdatedTime;
  dynamic _transDesc;
  dynamic _transStatus;
  dynamic _transCode;
  dynamic _c2bStatus;
Payment copyWith({  dynamic id,
  dynamic transAmount,
  dynamic businessShortCode,
  dynamic billRefNumber,
  dynamic invoiceNumber,
  dynamic transTime,
  dynamic msisdn,
  dynamic transactionType,
  dynamic transId,
  dynamic orgAccountBalance,
  dynamic thirdPartyTransId,
  dynamic firstName,
  dynamic middleName,
  dynamic lastName,
  dynamic rcptNo,
  dynamic createdDate,
  dynamic createdTime,
  dynamic refId,
  dynamic transCreatedBy,
  dynamic transCreatedDate,
  dynamic transCreatedTime,
  dynamic transUpdatedBy,
  dynamic transUpdatedDate,
  dynamic transUpdatedTime,
  dynamic transDesc,
  dynamic transStatus,
  dynamic transCode,
  dynamic c2bStatus,
}) => Payment(  id: id ?? _id,
  transAmount: transAmount ?? _transAmount,
  businessShortCode: businessShortCode ?? _businessShortCode,
  billRefNumber: billRefNumber ?? _billRefNumber,
  invoiceNumber: invoiceNumber ?? _invoicedynamicber,
  transTime: transTime ?? _transTime,
  msisdn: msisdn ?? _msisdn,
  transactionType: transactionType ?? _transactionType,
  transId: transId ?? _transId,
  orgAccountBalance: orgAccountBalance ?? _orgAccountBalance,
  thirdPartyTransId: thirdPartyTransId ?? _thirdPartyTransId,
  firstName: firstName ?? _firstName,
  middleName: middleName ?? _middleName,
  lastName: lastName ?? _lastName,
  rcptNo: rcptNo ?? _rcptNo,
  createdDate: createdDate ?? _createdDate,
  createdTime: createdTime ?? _createdTime,
  refId: refId ?? _refId,
  transCreatedBy: transCreatedBy ?? _transCreatedBy,
  transCreatedDate: transCreatedDate ?? _transCreatedDate,
  transCreatedTime: transCreatedTime ?? _transCreatedTime,
  transUpdatedBy: transUpdatedBy ?? _transUpdatedBy,
  transUpdatedDate: transUpdatedDate ?? _transUpdatedDate,
  transUpdatedTime: transUpdatedTime ?? _transUpdatedTime,
  transDesc: transDesc ?? _transDesc,
  transStatus: transStatus ?? _transStatus,
  transCode: transCode ?? _transCode,
  c2bStatus: c2bStatus ?? _c2bStatus,
);
  dynamic get id => _id;
  dynamic get transAmount => _transAmount;
  dynamic get businessShortCode => _businessShortCode;
  dynamic get billRefNumber => _billRefNumber;
  dynamic get invoiceNumber => _invoicedynamicber;
  dynamic get transTime => _transTime;
  dynamic get msisdn => _msisdn;
  dynamic get transactionType => _transactionType;
  dynamic get transId => _transId;
  dynamic get orgAccountBalance => _orgAccountBalance;
  dynamic get thirdPartyTransId => _thirdPartyTransId;
  dynamic get firstName => _firstName;
  dynamic get middleName => _middleName;
  dynamic get lastName => _lastName;
  dynamic get rcptNo => _rcptNo;
  dynamic get createdDate => _createdDate;
  dynamic get createdTime => _createdTime;
  dynamic get refId => _refId;
  dynamic get transCreatedBy => _transCreatedBy;
  dynamic get transCreatedDate => _transCreatedDate;
  dynamic get transCreatedTime => _transCreatedTime;
  dynamic get transUpdatedBy => _transUpdatedBy;
  dynamic get transUpdatedDate => _transUpdatedDate;
  dynamic get transUpdatedTime => _transUpdatedTime;
  dynamic get transDesc => _transDesc;
  dynamic get transStatus => _transStatus;
  dynamic get transCode => _transCode;
  dynamic get c2bStatus => _c2bStatus;

  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['id'] = _id;
    map['transAmount'] = _transAmount;
    map['businessShortCode'] = _businessShortCode;
    map['billRefNumber'] = _billRefNumber;
    map['invoiceNumber'] = _invoicedynamicber;
    map['transTime'] = _transTime;
    map['msisdn'] = _msisdn;
    map['transactionType'] = _transactionType;
    map['transId'] = _transId;
    map['orgAccountBalance'] = _orgAccountBalance;
    map['thirdPartyTransId'] = _thirdPartyTransId;
    map['firstName'] = _firstName;
    map['middleName'] = _middleName;
    map['lastName'] = _lastName;
    map['rcptNo'] = _rcptNo;
    map['createdDate'] = _createdDate;
    map['createdTime'] = _createdTime;
    map['refId'] = _refId;
    map['transCreatedBy'] = _transCreatedBy;
    map['transCreatedDate'] = _transCreatedDate;
    map['transCreatedTime'] = _transCreatedTime;
    map['transUpdatedBy'] = _transUpdatedBy;
    map['transUpdatedDate'] = _transUpdatedDate;
    map['transUpdatedTime'] = _transUpdatedTime;
    map['transDesc'] = _transDesc;
    map['transStatus'] = _transStatus;
    map['transCode'] = _transCode;
    map['c2bStatus'] = _c2bStatus;
    return map;
  }

}