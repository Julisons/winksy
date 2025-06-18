/// imgId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// imgImage : "dynamic"
/// imgUsrId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// imgInstId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// imgDesc : "dynamic"
/// imgStatus : "dynamic"
/// imgCode : "dynamic"
/// imgType : "dynamic"

class Photo {
  Photo({
      dynamic imgId, 
      dynamic imgImage, 
      dynamic imgUsrId, 
      dynamic imgInstId, 
      dynamic imgDesc, 
      dynamic imgStatus, 
      dynamic imgCode, 
      dynamic imgType,}){
    imgId = imgId;
    imgImage = imgImage;
    imgUsrId = imgUsrId;
    imgInstId = imgInstId;
    imgDesc = imgDesc;
    imgStatus = imgStatus;
    imgCode = imgCode;
    imgType = imgType;
}

  Photo.fromJson(dynamic json) {
    imgId = json['imgId'];
    imgImage = json['imgImage'];
    imgUsrId = json['imgUsrId'];
    imgInstId = json['imgInstId'];
    imgDesc = json['imgDesc'];
    imgStatus = json['imgStatus'];
    imgCode = json['imgCode'];
    imgType = json['imgType'];
  }
  dynamic imgId;
  dynamic imgImage;
  dynamic imgUsrId;
  dynamic imgInstId;
  dynamic imgDesc;
  dynamic imgStatus;
  dynamic imgCode;
  dynamic imgType;
Photo copyWith({  dynamic imgId,
  dynamic imgImage,
  dynamic imgUsrId,
  dynamic imgInstId,
  dynamic imgDesc,
  dynamic imgStatus,
  dynamic imgCode,
  dynamic imgType,
}) => Photo(  imgId: imgId ?? imgId,
  imgImage: imgImage ?? imgImage,
  imgUsrId: imgUsrId ?? imgUsrId,
  imgInstId: imgInstId ?? imgInstId,
  imgDesc: imgDesc ?? imgDesc,
  imgStatus: imgStatus ?? imgStatus,
  imgCode: imgCode ?? imgCode,
  imgType: imgType ?? imgType,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['imgId'] = imgId;
    map['imgImage'] = imgImage;
    map['imgUsrId'] = imgUsrId;
    map['imgInstId'] = imgInstId;
    map['imgDesc'] = imgDesc;
    map['imgStatus'] = imgStatus;
    map['imgCode'] = imgCode;
    map['imgType'] = imgType;
    return map;
  }

}