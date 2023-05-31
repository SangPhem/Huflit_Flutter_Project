class BASEURL {
  static String ipAddress = "192.168.1.146";
  static String apiRegister = "http://$ipAddress/med_app_db/register_api.php";
  static String apiLogin = "http://$ipAddress/med_app_db/login_api.php";

  static String categoryWithProduct =
      "http://$ipAddress/med_app_db/get_product_with_category.php";
  static String getProduct = "http://$ipAddress/med_app_db/get_product.php";
  static String addToCart = "http://$ipAddress/med_app_db/add_to_cart.php";
  static String getProductCart =
      "http://$ipAddress/med_app_db/get_cart.php?userID=";
  static String updateQuantityProductCart =
      "http://$ipAddress/med_app_db/update_quantity.php";
  static String totalPriceCart =
      "http://$ipAddress/med_app_db/get_total_price.php?userID=";
  static String getTotalCart =
      "http://$ipAddress/med_app_db/total_cart.php?userID=";
  static String checkout = "http://$ipAddress/med_app_db/checkout.php";
  static String historyOrder =
      "http://$ipAddress/med_app_db/get_history.php?id_user=";
  static String getDoctor =
      "http://$ipAddress/med_app_db/get_doctor.php?id_user=";
  static String getProductPrescription =
      "http://$ipAddress/med_app_db/get_product_prescription.php?id_user=";
  static String booking =
      "http://$ipAddress/med_app_db/booking_api.php?id_user=";
  static String getbooking =
      "http://$ipAddress/med_app_db/get_booked_schedule.php?id_user=";
}
