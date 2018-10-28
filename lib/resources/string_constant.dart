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
}