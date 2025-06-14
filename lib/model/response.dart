/// success : true
/// message : "CREATED"
/// data : {}
/// total : 0
/// targetUrl : null
/// status : 201
/// result : null
/// token : "eyJhbGciOiJIUzI1NiJ9.eyJ1c3JJZCI6IjQ3NGM3NmQ5LTNiYmUtNDI5Mi04ZDQ2LWQ1Njk5MjE1ZTQ4NyIsInVzckZ1bGxOYW1lcyI6IkF1c3RpbmUgSnVsaXNvbnMiLCJ1c3JGaXJzdE5hbWUiOiJBdXN0aW5lIEp1bGlzb25zIiwidXNyTGFzdE5hbWUiOiJBdXN0aW5lIEp1bGlzb25zIiwidXNyVXNlcm5hbWUiOiJhdXN0aW5lanVsaXNvbnNAZ21haWwuY29tIiwidXNyRW1haWwiOiJhdXN0aW5lanVsaXNvbnNAZ21haWwuY29tIiwidXNyTW9iaWxlTnVtYmVyIjoiIiwidXNyRW5hYmxlZCI6MSwidXNySW1hZ2UiOiJodHRwczovL2xoMy5nb29nbGV1c2VyY29udGVudC5jb20vYS9BQ2c4b2NMcFY1YTNnRTRINmI1Z2YxTFQ3QmRMTXJQbXo4SEttc3dDel9MMWxFZlpGRXZnRlNQOCIsImVuYWJsZWQiOnRydWUsImF1dGhvcml0aWVzIjpbeyJhdXRob3JpdHkiOiJST0xFX1BSQUNUSVRJT05FUiJ9XSwiYWNjb3VudE5vbkV4cGlyZWQiOnRydWUsImNyZWRlbnRpYWxzTm9uRXhwaXJlZCI6dHJ1ZSwiYWNjb3VudE5vbkxvY2tlZCI6dHJ1ZSwianRpIjoiNDc0Yzc2ZDktM2JiZS00MjkyLThkNDYtZDU2OTkyMTVlNDg3Iiwic3ViIjoiYXVzdGluZWp1bGlzb25zQGdtYWlsLmNvbSIsImlhdCI6MTc0ODg2ODEyMSwiZXhwIjoxNzU2MDY4MTIxfQ.IzzprA8pPLF0JxHFWJ9dPx9zTgPKcOdjxyWVOC8mqeU"

class JsonResponse {
  JsonResponse({
      required dynamic success, 
      required dynamic message, 
      dynamic data, 
      required dynamic total, 
      dynamic targetUrl, 
      required dynamic status, 
      dynamic result, 
      required dynamic token,}){
    success = success;
    message = message;
    data = data;
    total = total;
    targetUrl = targetUrl;
    status = status;
    result = result;
    token = token;
}

  JsonResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'];
    total = json['total'];
    targetUrl = json['targetUrl'];
    status = json['status'];
    result = json['result'];
    token = json['token'];
  }
  dynamic success;
      dynamic message;
  dynamic data;
      dynamic total;
  dynamic targetUrl;
      dynamic status;
  dynamic result;
      dynamic token;
  

JsonResponse copyWith({  required dynamic success,
  required dynamic message,
  dynamic data,
  required dynamic total,
  dynamic targetUrl,
  required dynamic status,
  dynamic result,
  required dynamic token,
}) => JsonResponse(  success: success ?? success,
  message: message ?? message,
  data: data ?? data,
  total: total ?? total,
  targetUrl: targetUrl ?? targetUrl,
  status: status ?? status,
  result: result ?? result,
  token: token ?? token,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['data'] = data;
    map['total'] = total;
    map['targetUrl'] = targetUrl;
    map['status'] = status;
    map['result'] = result;
    map['token'] = token;
    return map;
  }

}