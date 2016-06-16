#import "KMCredentialQuery.h"

// keys used in dictionaries returned by notifyUserMessages.
#define MSG_DATE_KEY    @"DATE"
#define MSG_MESSAGE_KEY @"MESSAGE"

#pragma mark -
#pragma mark Protocol Declaration

/*
 * The KMProtocolDelegate will be queried when additional information is required during the retrieval of a certificate by KMProtocol.
 */
@protocol KeyTalkDelegate <NSObject>

/*
 * Asks for additional information. For any key in the keys, there should be a corresponding value (NSString *) in the resulting dictionary. An implementer is not required to asked the user for this information, but is allowed to cache responses.
 */
- (void)requestCredentials:(id<KMCredentialQuery>)credentials;


/*
 * Report that the password is expiring or has expired.
 *
 * If delay > 0, the amount of seconds until the password expires.
 * The user may skip changing the password by calling
 * -(void)skipChangingPassword;
 *
 * If delay <= 0, the password has expired already. Changing
 * the password is mandatory and cannot be skipped. Call
 * -(void)changePassword:(NSString*)newPassword;
 */
- (void)notifyPasswordExpiring:(NSTimeInterval)delay;

/*
 * Report that the password got changed succesfully
 */
- (void)notifyPasswordChanged;

/*
 * Report that the password change failed (probably because the
 * complexity requirements weren't met).
 */
- (void)notifyPasswordChangeFailed:(NSTimeInterval)secondsToRetry;

/*
 * Reports succesful authentication to the end-user and ask which phase 4 user messages should be displayed.
 * An implementer can either ask the user or make an informed decision himself.
 * Expects a response of either:
 * - (void)reportUserMessagesWithLimit:(int)maximum;
 * or:
 * - (void)reportUserMessagesSince:(NSDate *)date;
 */
- (void)notifyAuthenticationSuccessWithUserMessages;

/*
 * In the case of a delay for a given period, delay contains the number of seconds
 * to wait before retrying authentication.
 */
- (void)notifyFailureWithDelay:(NSTimeInterval)delay;

/*
 * Phase 4 user messages to show user after authentication. messages contains NSDictionary objects,
 * each having keys MSG_DATE_KEY and MSG_MESSAGE_KEY, together making up the message with a timestamp.
 */
- (void)notifyUserMessages:(NSArray *)messages;

@end