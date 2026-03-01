import '../../l10n/generated/app_localizations.dart';

/// Resolves error/success code keys to localized strings.
/// Used in UI layer to display localized error messages from core utilities
/// that don't have access to BuildContext.
class ErrorLocalizer {
  ErrorLocalizer._();

  /// Resolve an error code to a localized message.
  /// If the code is not recognized or l10n is null, returns the code itself.
  static String localize(String? code, AppLocalizations? l10n) {
    if (code == null) return '';
    if (l10n == null) return code;

    switch (code) {
      // Error codes
      case 'errorNetworkConnection':
        return l10n.errorNetworkConnection;
      case 'errorServer':
        return l10n.errorServer;
      case 'errorAuthFailed':
        return l10n.errorAuthFailed;
      case 'errorUnknown':
        return l10n.errorUnknown;
      case 'errorTimeout':
        return l10n.errorTimeout;
      case 'errorRequestCancelled':
        return l10n.errorRequestCancelled;
      case 'errorForbidden':
        return l10n.errorForbidden;
      case 'errorNotFound':
        return l10n.errorNotFound;
      case 'errorRequestParam':
        return l10n.errorRequestParam;
      case 'errorParseData':
        return l10n.errorParseData;
      case 'errorParseFormat':
        return l10n.errorParseFormat;
      case 'errorRateLimited':
        return l10n.errorRateLimited;
      // Success codes
      case 'successLogin':
        return l10n.successLogin;
      case 'successRegister':
        return l10n.successRegister;
      case 'successSync':
        return l10n.successSync;
      case 'successDownload':
        return l10n.successDownload;
      // Auth error codes (from auth_provider)
      case 'loginFailed':
        return l10n.loginFailed;
      case 'registerFailed':
        return l10n.registerFailed;
      case 'loginErrorOccurred':
        return l10n.loginErrorOccurred;
      case 'registerErrorOccurred':
        return l10n.registerErrorOccurred;
      case 'logoutErrorOccurred':
        return l10n.logoutErrorOccurred;
      case 'userInfoLoadFailed':
        return l10n.userInfoLoadFailed;
      // Provider error codes
      case 'userNotFound':
        return l10n.userNotFound;
      case 'failedToCreateComment':
        return l10n.failedToCreateComment;
      case 'failedToDeleteComment':
        return l10n.failedToDeleteComment;
      case 'failedToSubmitReport':
        return l10n.failedToSubmitReport;
      case 'failedToBlockUser':
        return l10n.failedToBlockUser;
      case 'failedToUnblockUser':
        return l10n.failedToUnblockUser;
      case 'failedToCreatePost':
        return l10n.failedToCreatePost;
      case 'failedToDeletePost':
        return l10n.failedToDeletePost;
      case 'voiceServerConnectFailed':
        return l10n.voiceServerConnectFailed;
      case 'connectionLostRetry':
        return l10n.connectionLostRetry;
      case 'noInternetConnection':
        return l10n.noInternetConnection;
      case 'couldNotLoadRooms':
        return l10n.couldNotLoadRooms;
      case 'couldNotCreateRoom':
        return l10n.couldNotCreateRoom;
      case 'couldNotJoinRoom':
        return l10n.couldNotJoinRoom;
      case 'roomClosedByHost':
        return l10n.roomClosedByHost;
      case 'removedFromRoomByHost':
        return l10n.removedFromRoomByHost;
      case 'connectionTimedOut':
        return l10n.connectionTimedOut;
      case 'missingLiveKitCredentials':
        return l10n.missingLiveKitCredentials;
      case 'microphoneEnableFailed':
        return l10n.microphoneEnableFailed;
      case 'stageRequestFailed':
        return l10n.stageRequestFailed;
      case 'stageRequestRejected':
        return l10n.stageRequestRejected;
      case 'stageFull':
        return l10n.voiceRoomStageFull;
      case 'inviteToStageFailed':
        return l10n.inviteToStageFailed;
      case 'demoteFailed':
        return l10n.demoteFailed;
      case 'messageSendFailed':
        return l10n.voiceRoomMessageSendFailed;
      default:
        return code;
    }
  }
}
