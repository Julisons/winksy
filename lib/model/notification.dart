/// notiId : null
/// notiUsrId : null
/// notiText : null
/// notiVeId : null
/// notiVeImg : null
/// notiSubject : null
/// notiCreatedBy : null
/// notiCreatedDate : null
/// notiCreatedTime : null
/// notiUpdatedBy : null
/// notiUpdatedDate : null
/// notiUpdatedTime : null
/// notiDesc : null
/// notiStatus : null
/// notiCode : null
/// notiTrpId : null
/// notiCtrId : null
/// notiRtId : null
/// notiVesId : null
/// notiPlate : null
/// notiType : null

class Notification {
  Notification({
      dynamic notiId, 
      dynamic notiUsrId, 
      dynamic notiText, 
      dynamic notiVeId, 
      dynamic notiVeImg, 
      dynamic notiSubject, 
      dynamic notiCreatedBy, 
      dynamic notiCreatedDate, 
      dynamic notiCreatedTime, 
      dynamic notiUpdatedBy, 
      dynamic notiUpdatedDate, 
      dynamic notiUpdatedTime, 
      dynamic notiDesc, 
      dynamic notiStatus, 
      dynamic notiCode, 
      dynamic notiTrpId, 
      dynamic notiCtrId, 
      dynamic notiRtId, 
      dynamic notiVesId, 
      dynamic notiPlate, 
      dynamic notiType,}){
    _notiId = notiId;
    _notiUsrId = notiUsrId;
    _notiText = notiText;
    _notiVeId = notiVeId;
    _notiVeImg = notiVeImg;
    _notiSubject = notiSubject;
    _notiCreatedBy = notiCreatedBy;
    _notiCreatedDate = notiCreatedDate;
    _notiCreatedTime = notiCreatedTime;
    _notiUpdatedBy = notiUpdatedBy;
    _notiUpdatedDate = notiUpdatedDate;
    _notiUpdatedTime = notiUpdatedTime;
    _notiDesc = notiDesc;
    _notiStatus = notiStatus;
    _notiCode = notiCode;
    _notiTrpId = notiTrpId;
    _notiCtrId = notiCtrId;
    _notiRtId = notiRtId;
    _notiVesId = notiVesId;
    _notiPlate = notiPlate;
    _notiType = notiType;
}

  Notification.fromJson(dynamic json) {
    _notiId = json['notiId'];
    _notiUsrId = json['notiUsrId'];
    _notiText = json['notiText'];
    _notiVeId = json['notiVeId'];
    _notiVeImg = json['notiVeImg'];
    _notiSubject = json['notiSubject'];
    _notiCreatedBy = json['notiCreatedBy'];
    _notiCreatedDate = json['notiCreatedDate'];
    _notiCreatedTime = json['notiCreatedTime'];
    _notiUpdatedBy = json['notiUpdatedBy'];
    _notiUpdatedDate = json['notiUpdatedDate'];
    _notiUpdatedTime = json['notiUpdatedTime'];
    _notiDesc = json['notiDesc'];
    _notiStatus = json['notiStatus'];
    _notiCode = json['notiCode'];
    _notiTrpId = json['notiTrpId'];
    _notiCtrId = json['notiCtrId'];
    _notiRtId = json['notiRtId'];
    _notiVesId = json['notiVesId'];
    _notiPlate = json['notiPlate'];
    _notiType = json['notiType'];
  }
  dynamic _notiId;
  dynamic _notiUsrId;
  dynamic _notiText;
  dynamic _notiVeId;
  dynamic _notiVeImg;
  dynamic _notiSubject;
  dynamic _notiCreatedBy;
  dynamic _notiCreatedDate;
  dynamic _notiCreatedTime;
  dynamic _notiUpdatedBy;
  dynamic _notiUpdatedDate;
  dynamic _notiUpdatedTime;
  dynamic _notiDesc;
  dynamic _notiStatus;
  dynamic _notiCode;
  dynamic _notiTrpId;
  dynamic _notiCtrId;
  dynamic _notiRtId;
  dynamic _notiVesId;
  dynamic _notiPlate;
  dynamic _notiType;
Notification copyWith({  dynamic notiId,
  dynamic notiUsrId,
  dynamic notiText,
  dynamic notiVeId,
  dynamic notiVeImg,
  dynamic notiSubject,
  dynamic notiCreatedBy,
  dynamic notiCreatedDate,
  dynamic notiCreatedTime,
  dynamic notiUpdatedBy,
  dynamic notiUpdatedDate,
  dynamic notiUpdatedTime,
  dynamic notiDesc,
  dynamic notiStatus,
  dynamic notiCode,
  dynamic notiTrpId,
  dynamic notiCtrId,
  dynamic notiRtId,
  dynamic notiVesId,
  dynamic notiPlate,
  dynamic notiType,
}) => Notification(  notiId: notiId ?? _notiId,
  notiUsrId: notiUsrId ?? _notiUsrId,
  notiText: notiText ?? _notiText,
  notiVeId: notiVeId ?? _notiVeId,
  notiVeImg: notiVeImg ?? _notiVeImg,
  notiSubject: notiSubject ?? _notiSubject,
  notiCreatedBy: notiCreatedBy ?? _notiCreatedBy,
  notiCreatedDate: notiCreatedDate ?? _notiCreatedDate,
  notiCreatedTime: notiCreatedTime ?? _notiCreatedTime,
  notiUpdatedBy: notiUpdatedBy ?? _notiUpdatedBy,
  notiUpdatedDate: notiUpdatedDate ?? _notiUpdatedDate,
  notiUpdatedTime: notiUpdatedTime ?? _notiUpdatedTime,
  notiDesc: notiDesc ?? _notiDesc,
  notiStatus: notiStatus ?? _notiStatus,
  notiCode: notiCode ?? _notiCode,
  notiTrpId: notiTrpId ?? _notiTrpId,
  notiCtrId: notiCtrId ?? _notiCtrId,
  notiRtId: notiRtId ?? _notiRtId,
  notiVesId: notiVesId ?? _notiVesId,
  notiPlate: notiPlate ?? _notiPlate,
  notiType: notiType ?? _notiType,
);
  dynamic get notiId => _notiId;
  dynamic get notiUsrId => _notiUsrId;
  dynamic get notiText => _notiText;
  dynamic get notiVeId => _notiVeId;
  dynamic get notiVeImg => _notiVeImg;
  dynamic get notiSubject => _notiSubject;
  dynamic get notiCreatedBy => _notiCreatedBy;
  dynamic get notiCreatedDate => _notiCreatedDate;
  dynamic get notiCreatedTime => _notiCreatedTime;
  dynamic get notiUpdatedBy => _notiUpdatedBy;
  dynamic get notiUpdatedDate => _notiUpdatedDate;
  dynamic get notiUpdatedTime => _notiUpdatedTime;
  dynamic get notiDesc => _notiDesc;
  dynamic get notiStatus => _notiStatus;
  dynamic get notiCode => _notiCode;
  dynamic get notiTrpId => _notiTrpId;
  dynamic get notiCtrId => _notiCtrId;
  dynamic get notiRtId => _notiRtId;
  dynamic get notiVesId => _notiVesId;
  dynamic get notiPlate => _notiPlate;
  dynamic get notiType => _notiType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notiId'] = _notiId;
    map['notiUsrId'] = _notiUsrId;
    map['notiText'] = _notiText;
    map['notiVeId'] = _notiVeId;
    map['notiVeImg'] = _notiVeImg;
    map['notiSubject'] = _notiSubject;
    map['notiCreatedBy'] = _notiCreatedBy;
    map['notiCreatedDate'] = _notiCreatedDate;
    map['notiCreatedTime'] = _notiCreatedTime;
    map['notiUpdatedBy'] = _notiUpdatedBy;
    map['notiUpdatedDate'] = _notiUpdatedDate;
    map['notiUpdatedTime'] = _notiUpdatedTime;
    map['notiDesc'] = _notiDesc;
    map['notiStatus'] = _notiStatus;
    map['notiCode'] = _notiCode;
    map['notiTrpId'] = _notiTrpId;
    map['notiCtrId'] = _notiCtrId;
    map['notiRtId'] = _notiRtId;
    map['notiVesId'] = _notiVesId;
    map['notiPlate'] = _notiPlate;
    map['notiType'] = _notiType;
    return map;
  }

}