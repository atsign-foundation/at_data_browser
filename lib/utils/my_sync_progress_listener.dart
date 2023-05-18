import 'package:at_client_mobile/at_client_mobile.dart';

class MySyncProgressListener extends SyncProgressListener {
  @override
  void onSyncProgressEvent(SyncProgress syncProgress) async {
    if (syncProgress.syncStatus == SyncStatus.success) {
      // * Sync is complete
      // * Do something here
    }
  }
}
