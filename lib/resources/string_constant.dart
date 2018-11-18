class StringConstant{

  static String getDeleteConfirmationMessageInMaster(
      String toBeDeletedMessage, String toBeAffectedMessage,
      ){
    return 'Apakah anda yakin untuk menghapus $toBeDeletedMessage'
        ' ? \nJika iya maka semua barang yang $toBeAffectedMessage'
        ' akan terhapus.';
  }

  static String getRestoreConfirmationMessageInMaster(
      String toBeRestoredMessage, String toBeAffectedMessage,
      ){
    return 'Apakah anda yakin untuk mengaktifkan kembali $toBeRestoredMessage'
        ' ? \nJika iya maka semua barang yang $toBeAffectedMessage'
        ' akan aktif kembali di katalog.';
  }

  static const String DELETE_OK = 'Setuju';
  static const String DELETE_CANCEL = 'Tidak';
  static const String MESSAGE_NO_DATA_AVAILABLE = 'Tidak ada data tersedia';
  static const String MESSAGE_TAP_TO_RETRY = 'Tap To Retry';
  static const String OK = 'OK';

  static const String RESTORE = "Mengaktifkan kembali";
  static const String RELATED_PRODUCT = "Produk terkait :";
  static const String NO_RELATED_PRODUCT = "Tidak ada produk terkait";

  static const String MASTER_UNIT = "Master Satuan";
  static const String NO_DATA_AVAILABLE = "Tidak ada data tersedia";
  static const String UNIT = "satuan";

  static const String INSERT = "Tambahkan";
  static const String UPDATE = "Ubah";
  static const String BUTTON_STATE_LOADING_LABEL = "PROCESSING";

  static const String ERROR_SHOULD_RETRY_LABEL = "Tap to retry";
}