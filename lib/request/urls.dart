class IUrls {

// static String BASE = 'http://192.168.100.36';
//static String BASE = 'http://10.10.1.28';

  static String BASE = 'http://212.47.74.158';
 static String BASE_IMAGE = 'http://212.47.74.158';

static String IMAGE_URL = '$BASE_IMAGE:5000';
  //static String IMAGE_URL = 'http://212.47.74.158:5000';

//static String BASE_URL = 'http://212.47.74.158:5000';
static String BASE_URL = '$BASE:5000';

 // static String BASE_URL = 'http://212.47.74.158/dopamine';

  static String TOKEN(channel,uid) {
    return "$BASE_URL/usr/fetch_token?channel=$channel&uid=$uid";
  }

  static Uri MESSAGES() {
    return Uri.parse('$BASE_URL/message/fetch_messages');
  }

  static String NODE(){
    return "$BASE:3030/messages";
   // return "http://192.168.100.36:3030/messages";
  }
  static String NODE_ONLINE(){
   // return "http://192.168.100.36:3030/chats";
    return "$BASE:3030/chats";
  }
  static String NODE_QUADRIX(){
    // return "http://192.168.100.36:3030/chats";
    return "$BASE:9000";
  }

  static String SAVE_MESSAGE() {
    return '$BASE_URL/message/save_message';
  }

  static String SIGN_UP() {
    return "$BASE_URL/auth/sign_up";
  }

  static String GIFT() {
    return "$BASE_URL/user_gift/save_usergift";
  }

  static String PHOTO() {
    return "$BASE_URL/image/save_image";
  }

  static String INTEREST() {
    return "$BASE_URL/interest/save_interest";
  }

  static String FRIEND() {
    return "$BASE_URL/friend/save_friend";
  }

  static String TRANSACTION() {
    return "$BASE_URL/transaction/save_transaction";
  }

  static String WISH() {
    return "$BASE_URL/wishlist/save_wishlist";
  }

  static String USER() {
    return "$BASE_URL/user/save_user";
  }

  static Uri CHATS() {
    return Uri.parse("$BASE_URL/chat/fetch_chats");
  }

  static Uri PETS() {
    return Uri.parse("$BASE_URL/pet/fetch_pets");
  }

  static Uri FRIENDS() {
    return Uri.parse("$BASE_URL/user/fetch_users");
  }

  static Uri FAME_HALL() {
    return Uri.parse("$BASE_URL/user/fetch_users_fame_hall");
  }

  static Uri MY_FRIENDS() {
    return Uri.parse("$BASE_URL/friend/fetch_friends");
  }

  static Uri OWNED_PETS() {
    return Uri.parse("$BASE_URL/pet/fetch_owned_pets");
  }

  static Uri NOTIFICATIONS() {
    return Uri.parse("$BASE_URL/notification/fetch_notifications");
  }

  static Uri PHOTOS() {
    return Uri.parse("$BASE_URL/image/fetch_images");
  }

  static Uri PETS_WISHLIST() {
    return Uri.parse("$BASE_URL/pet/fetch_pets_wishlist");
  }

  static Uri GIFTS() {
    return Uri.parse("$BASE_URL/user_gift/fetch_usergifts");
  }

  static Uri SPINNERS() {
    return Uri.parse("$BASE_URL/spinner/fetch_spinners");
  }

  static Uri TREATS() {
    return Uri.parse("$BASE_URL/gift/fetch_gifts");
  }

  static String MAIN_LINKS(params) {
    return "$BASE_URL/usr/fetchLinkAlt$params";
  }

  static String SIGN_IN() {
    return "$BASE_URL/auth/sign_in";
  }

  static String PET() {
    return "$BASE_URL/pet/save_pet";
  }

  static String VERIFY_OTP() {
    return "$BASE_URL/auth/verify_otp";
  }

  static String CHAT() {
    return "$BASE_URL/chat/save_chat";
  }


  static String RESET_PASSWORD() {
    return "$BASE_URL/auth/reset_password";
  }

  static String UPDATE_PASSWORD() {
    return "$BASE_URL/auth/update_password";
  }

  static String PUSH_STK(phone,ref,amount) {
    return '$BASE_URL/usr/mpesa_push_stk?phone=$phone&ref=$ref&amount=$amount';
  }

  static String LINK() {
    return "$BASE_URL/usr/saveLink";
  }

  static String FOLDER() {
    return "$BASE_URL/usr/saveFolder";
  }

  static String FOLDERS(params) {
    return "$BASE_URL/usr/fetchFolders$params";
  }

  static String MYFOLDERS(params) {
    return "$BASE_URL/usr/fetchMyFolders$params";
  }

  static String TOPICS(usrId) {
    return "$BASE_URL/usr/fetchTopics?folUsrId=$usrId";
  }

  static String TOPIC() {
    return "$BASE_URL/usr/saveTopic";
  }

  static String FOLDERALT() {
    return "$BASE_URL/usr/saveFolderAlt";
  }

  static Uri USERS(params) {
    return Uri.parse("$BASE_URL/user/fetch_users$params");
  }

  static Uri INTERESTS(params) {
    return Uri.parse("$BASE_URL/interest/fetch_interests");
  }


  static Uri IMAGE() {
    return Uri.parse("$IMAGE_URL/file/save_file");
  }

static String INVOICE_DTLS(invodInvoId, ownerId) {
  return "$BASE_URL/usr/fetchInvoiceDtls?invodInvoId=$invodInvoId&ownerId=$ownerId";
}

  static String PAYMENT(ref, usrId) {
    return "$BASE_URL/usr/fetchPayment?invoiceNumber=$ref&usrId=$usrId";
  }
  static String PAYMENT_WEB(ref, phoneNumber) {
    return "$BASE_URL/usr/fetchPayment?invoiceNumber=$ref&phoneNumber=$phoneNumber";
  }

  static String PAYMENTS(params) {
    return "$BASE_URL/usr/fetchPayments$params";
  }

  static String UPDATE_USER() {
    return "$BASE_URL/user/save_user";
  }

  static String INVENTORY(ownerId, search) {
    return "$BASE_URL/usr/fetchInventory?ownerId=${ownerId}&txtSearch=$search";
  }

  static String INVOICES(usrId,search,ownerId) {
    return "$BASE_URL/usr/fetchInvoices?usrId=${usrId}&txtSearch=$search&ownerId=$ownerId";
  }
}
