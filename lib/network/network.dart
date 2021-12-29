class NetworkUrl {
  static String url = "https://pjmpalmerah.000webhostapp.com/api/";

  static String addProducts() {
    return "$url/add_products.php";
  }

  static String editProducts() {
    return "$url/edit_products.php";
  }

  static String editCoverProducts() {
    return "$url/edit_cover_products.php";
  }

  static String deleteProducts() {
    return "$url/delete_products.php";
  }

  static String deleteKategoriProducts() {
    return "$url/delete_kategori_products.php";
  }

  static String updateStatusPemesanan() {
    return "$url/update_status_pemesanan.php";
  }

  static String updateNamaKategoriProduk() {
    return "$url/update_nama_kategori.php";
  }

  static String addKategoriProduk() {
    return "$url/add_kategori_produk.php";
  }

  static String getProducts() {
    return "$url/get_products.php";
  }

  static String getOngkosKirim() {
    return "$url/get_ongkos_kirim.php";
  }

  static String getKategoriProduk() {
    return "$url/get_products_dengan_kategoriProduk.php";
  }

  static String addFavoritProdukWithoutLogin() {
    return "$url/add_products_favorit_produk_without_login.php";
  }

  static String getFavoritProdukWhitoutLogin(String deviceInfo) {
    return "$url/get_products_favorit_produk_without_login.php?deviceInfo=$deviceInfo";
  }

  static String addKeranjangBelanja() {
    return "$url/add_keranjang_belanja.php";
  }

  static String menambahQuantityKeranjangBelanja() {
    return "$url/menambah_jumlah_barang_di_dalam_keranjang_belanja.php";
  }

  static String mengurangiQuantityKeranjangBelanja() {
    return "$url/mengurangi_jumlah_barang_di_dalam_keranjang_belanja.php";
  }

  static String getPenjumlahanTotalHargaBarangDalamKeranjang(String unikID) {
    return "$url/get_penjumlahan_dari_quantity_barang.php?unikID=$unikID";
  }

  static String getKeranjangBelanja(String unikID) {
    return "$url/get_products_dari_keranjang_belanja.php?unikID=$unikID";
  }

  static String getTotalBarangDikeranjang(String unikID) {
    return "$url/get_products_total_barang_yang_ada_dikeranjang.php?unikID=$unikID";
  }

  static String getProdukDetail(String idProduk) {
    return "$url/get_products_detail.php?idProduk=$idProduk";
  }

  static String loginGmail() {
    return "$url/cekEmail.php";
  }

  static String login() {
    return "$url/login.php";
  }

  static String daftar() {
    return "$url/daftar.php";
  }

  static String checkOut() {
    return "$url/checkout.php";
  }

  static String getHistory(String idUsers) {
    return "$url/get_history.php?idUsers=$idUsers";
  }

  static String getStatusPesanan() {
    return "$url/get_status_pesanan.php";
  }

  static String getUsers() {
    return "$url/get_users.php";
  }

  static String getHistoryPesananUser(String idUsers) {
    return "$url/get_history_pesanan_user.php?idUsers=$idUsers";
  }

  static String inputKonfirmasiPembayaran() {
    return "$url/input_konfirmasi_pembayaran.php";
  }

  static String getKonfirmasiPembayaran() {
    return "$url/get_konfirmasi_pembayaran.php";
  }

  static String addOngkosKirim() {
    return "$url/add_ongkos_kirim.php";
  }

  static String deleteOngkosKirim() {
    return "$url/delete_ongkos_kirim.php";
  }

  static String updateOngkosKirim() {
    return "$url/update_ongkos_kirim.php";
  }

  static String deleteKonfirmasiPembayaran() {
    return "$url/delete_konfirmasi_pembayaran.php";
  }

  static String kirimNotifikasiStatusPemesanan(String noInvoice) {
    return "$url/SendNotificationStatusPemesananDalamPengiriman.php?noInvoice=$noInvoice";
  }

  static String getPenjumlahanTotalPembelian(String noInvoice) {
    return "$url/get_penjumlahan_dari_total_harga_detail_pemesanan.php?noInvoice=$noInvoice";
  }

  static String kirimNotifikasiAdmin(String namaLengkap, level) {
    return "$url/SendNotificationPembelianToAdmin.php?nama=$namaLengkap&=$level";
  }

  static String kirimNotifikasiKonfirmasiPembayaran(String noInvoice, level) {
    return "$url/SendNotificationKonfirmasiPembayaran.php?noInvoice=$noInvoice&level=$level";
  }
}
