import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class Link {
  dynamic lnkId;
  dynamic lnkRawUrl;
  dynamic lnkUrl;
  dynamic lnkIcon;
  dynamic lnkImg;
  dynamic lnkTitle;
  dynamic lnkDesc;
  dynamic lnkUsrId;
  dynamic lnkCatId;
  dynamic lnkCatTitle;
  dynamic lnkCreatedBy;
  dynamic lnkCreatedDate;
  dynamic lnkCreatedTime;
  dynamic lnkUpdatedBy;
  dynamic lnkUpdatedDate;
  dynamic lnkUpdatedTime;
  dynamic lnkStatus;
  dynamic lnkCode;
  dynamic lnkOwnerId;
  dynamic htmlWidget;
  dynamic controller;
  dynamic list;
  dynamic folders;
  PlatformWebViewController? webController;
  dynamic folId;
  dynamic folUsrId;
  dynamic folFolder;
  dynamic folIcon;
  dynamic folDesc;
  dynamic folCreatedBy;
  dynamic folCreatedDate;
  dynamic folCreatedTime;
  dynamic folUpdatedBy;
  dynamic folUpdatedDate;
  dynamic folUpdatedTime;
  dynamic folStatus;
  dynamic folCode;
  dynamic folOwnerId;

  // Default constructor
  Link({
    this.lnkId,
    this.lnkRawUrl,
    this.lnkUrl,
    this.lnkIcon,
    this.lnkImg,
    this.lnkTitle,
    this.lnkDesc,
    this.lnkUsrId,
    this.lnkCatId,
    this.lnkCatTitle,
    this.lnkCreatedBy,
    this.lnkCreatedDate,
    this.lnkCreatedTime,
    this.lnkUpdatedBy,
    this.lnkUpdatedDate,
    this.lnkUpdatedTime,
    this.lnkStatus,
    this.lnkCode,
    this.lnkOwnerId,
    this.htmlWidget,
    this.controller,
    this.webController,
    this.list,
    this.folders,

    this. folId,
    this. folUsrId,
    this. folFolder,
    this. folIcon,
    this. folDesc,
    this. folCreatedBy,
    this. folCreatedDate,
    this. folCreatedTime,
    this. folUpdatedBy,
    this. folUpdatedDate,
    this. folUpdatedTime,
    this. folStatus,
    this. folCode,
    this. folOwnerId,
  });


  // Constructs a `Link` instance from a JSON object.
  Link.fromJson(Map<dynamic, dynamic> json):
        lnkId = json['lnkId'],
        lnkRawUrl = json['lnkRawUrl'],
        lnkUrl = json['lnkUrl'],
        lnkIcon = json['lnkIcon'],
        lnkImg = json['lnkImg'],
        lnkTitle = json['lnkTitle'],
        lnkDesc = json['lnkDesc'],
        lnkUsrId = json['lnkUsrId'],
        lnkCatId = json['lnkCatId'],
        lnkCatTitle = json['lnkCatTitle'],
        lnkCreatedBy = json['lnkCreatedBy'],
        lnkCreatedDate = json['lnkCreatedDate'],
        lnkCreatedTime = json['lnkCreatedTime'],
        lnkUpdatedBy = json['lnkUpdatedBy'],
        lnkUpdatedDate = json['lnkUpdatedDate'],
        lnkUpdatedTime = json['lnkUpdatedTime'],
        lnkStatus = json['lnkStatus'],
        lnkCode = json['lnkCode'],
        folFolder = json['folFolder'],
        lnkOwnerId = json['lnkOwnerId'],
        folders = json['folders'],
        list = json['list'];

  // Converts the `Link` instance into a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'lnkId': lnkId,
      'lnkRawUrl': lnkRawUrl,
      'lnkUrl': lnkUrl,
      'lnkIcon': lnkIcon,
      'lnkImg': lnkImg,
      'lnkTitle': lnkTitle,
      'lnkDesc': lnkDesc,
      'lnkUsrId': lnkUsrId,
      'lnkCatId': lnkCatId,
      'lnkCatTitle': lnkCatTitle,
      'lnkCreatedBy': lnkCreatedBy,
      'lnkCreatedDate': lnkCreatedDate,
      'lnkCreatedTime': lnkCreatedTime,
      'lnkUpdatedBy': lnkUpdatedBy,
      'lnkUpdatedDate': lnkUpdatedDate,
      'lnkUpdatedTime': lnkUpdatedTime,
      'lnkStatus': lnkStatus,
      'lnkCode': lnkCode,
      'lnkOwnerId': lnkOwnerId,
      'folFolder': folFolder,
      'list': list,
    };
  }
}