#import "KMRCCD.h"
#import "KMCredentialQuery.h"
#import "KMServiceProvider.h"
#import "KeyTalkDelegate.h"

@interface KeyTalk : NSObject {
    KeyTalk *impl;
}

enum ErrorCode
{
    errSuccess = 0,
    errConfiguration,
    errNoSecureCommunication,
    errNetwork,
    errCommunication,
    errIpResolve,
    errReceivedCertNoTrusted,
    errResolvedIpInvalid,
    errDigestInvalid,
    errTimeOutOfSync,
    errMaxLicensedUsersReached,
    errPasswordExpired,
    errNotSupAuthReqRenew,
    errNotSupAuthMethod,
    errDefault = 100
};

/*
 * Gets a detailed log report, ready to be sent to support.
 * The (optional) userConfiguration should be a description of the service configuration used.
 * Typically a serialization of the RCCD or the id<KMServiceProvider> provided to initForService.
 * It will be inserted as-is into the log as user configuration to provide context to the error.
 */
+ (NSData *)getLogReport:(NSString *)usedConfiguration;

/*
 * Initializes this KeyTalk object to retrieve a certificate for the given service,
 * passing in the intermediate delegate.
 */
- (KeyTalk *)initForService:(id<KMServiceProvider>)service withDelegate:(id<KeyTalkDelegate>)delegate andHardwareDescription:(NSString*)hwDesc;

/*
 * Retrieves a certificate and returns in the scucess block.
 * The certificate can then be loaded into the iOS keychain using SecPKCS12Import.
 */
- (void)getCertificateOnSuccess:(void (^)(NSURL * serviceURL, NSData *serviceP12CertificateData, NSString *passphrase))success
onLock:(void (^)())lock
onError:(void (^)(enum ErrorCode code, NSString * reason))error;

/*
 * Convenience method which directly loads the certificate into the application keychain
 */
- (void)loadCertificateToKeyChainOnSuccess:(void (^)(NSURL *serviceURL))success
onLock:(void (^)())lock
onError:(void (^)(enum ErrorCode code, NSString *reason))error;

/*
 * Report a set of credentials back to the protocol; this is a response to KMProtocolDelegate.requestCredentials.
 */
- (void)reportCredentials:(id<KMCredentialQuery>)credentials;
/*
 * Report that credentials are not supplied for whatever reason (e.g., the user has chosen not to enter them); this is a response to KMProtocolDelegate.requestCredentials.
 */
- (void)reportCredentialsNotSupplied;
/*
 * Report up to limit of the last user messages. Zero or negative limit skips the phase.
 * this is a response to KMProtocolDelegate.notifyAuthenticationSuccessWithUserMessages
 */
- (void)reportUserMessagesWithLimit:(int)limit;
/*
 * Report all user messages since specified date. date equal to nil reports all messages.
 * this is a response to KMProtocolDelegate.notifyAuthenticationSuccessWithUserMessages
 */
- (void)reportUserMessagesSince:(NSDate *)date;


/*
 * After receiving the message 'notifyPasswordExpiring',
 * call this to change the password.
 */
- (void)changePassword:(NSString*)newPassword;

/**
 * After receiving the message 'notifyPasswordExpiring',
 * call this to skip changing the password and completing
 * the handshake. If this is not allowed (because the
 * password has already expired), a 'notifyPasswordExpiring'
 * will be triggered again.
 */
- (void)skipChangingPassword;

/*
 * Return a (semi) unique identifier per device. The ID will be generated on first query
 * and subsequently remain the same (the only guarantee is that different devices will
 * have different IDs)
 */
+ (NSString *)deviceIdentifier;

@end
