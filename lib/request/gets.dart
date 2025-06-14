import 'dart:convert';
import 'dart:developer';
import 'package:winksy/request/urls.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../mixin/constants.dart';
import '../mixin/mixins.dart';

class NotificationsRequest {
  NotificationsRequest();
  Future<http.Response> fetchNotifications(usrId) {
    var url = Uri.parse(IUrls.NOTIFICATIONS(usrId));
    log(url.toString());
    return http.get(url);
  }
}


class LinkMainRequest {
  LinkMainRequest();
  Future<http.Response> fetchMainLinks(params) {
    var url = Uri.parse(IUrls.MAIN_LINKS(params));
    log('$url');
    return http.get(url);
  }
}

class PaymentRequest {
  PaymentRequest();
  Future<http.Response> fetchPayments(params) {
    var url = Uri.parse(IUrls.PAYMENTS(params).replaceAll('null', ''));
    log(url.toString());
    return http.get(url);
  }
}
class FolderRequest {
  FolderRequest();
  Future<http.Response> fetchFolders(params) {
    var url = Uri.parse(IUrls.FOLDERS(params));
    log(url.toString());
    return http.get(url);
  }
}

class MyFolderRequest {
  MyFolderRequest();
  Future<http.Response> fetchMyFolders(params) {
    var url = Uri.parse(IUrls.MYFOLDERS(params));
    log(url.toString());
    return http.get(url);
  }
}

class TopicsRequest {
  TopicsRequest();
  Future<http.Response> fetchTopics(usrId) {
    var url = Uri.parse(IUrls.TOPICS(usrId));
    log(url.toString());
    return http.get(url);
  }
}

class XRequest {
  Future<http.Response> getData(dynamic data, Uri url) async {
    final token = await Mixin.getPrefString(key: TOKEN);
    log(url.toString());
    log('data- : $data');

    return http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }
}


class InvoiceRequest {
  InvoiceRequest();
  Future<http.Response> fetchInvoices(usrId, search, ownerId) {
    var url = Uri.parse(IUrls.INVOICES(usrId,search,ownerId));
    log(url.toString());
    return http.get(url);
  }
}

class InvoiceDtlRequest {
  InvoiceDtlRequest();
  Future<http.Response> fetchInvoiceDtls(invodInvoId,ownerId) {
    var url = Uri.parse(IUrls.INVOICE_DTLS(invodInvoId,ownerId));
    log(url.toString());
    return http.get(url);
  }
}


