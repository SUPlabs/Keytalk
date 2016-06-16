
#import "KeyTalkClient.h"

#import <KeyTalk/KeyTalk.h>
#import "AppDelegate.h"

static NSString *CERT_FILE = @"/tmp/clientCertificate.pfx";
static NSString *PASS_FILE = @"/tmp/certificatePassphrase.txt";
static NSString *ERROR_LOG = @"/tmp/KeyMasterErrorLog.log";

@implementation KeyTalkClient


-(id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    
    if(self)
    {
        self.username = [dict objectForKey:@"username"];
        self.password = [dict objectForKey:@"password"];
        [self fetchCertificate];
    }
    return self;
}

- (KeyTalkClient *)init {
    if ([super init]) {
        [self fetchCertificate];
    }
    return self;
}


- (void)fetchCertificate {
    // read RCCD file content
    NSString *rccd_file = [[NSBundle mainBundle] pathForResource:@"kt_superp" ofType:@"rccd"];
    NSLog(@"Path:%@\n", rccd_file);
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:rccd_file];
    
    // parse the RCCD file:
    KMRCCD *rccd = [[KMRCCD alloc] initWithData:data];
    
    // rccd.config contains a Dictionary with all the settings in the rccd file.
    // Inspect it to learn which services are available, what their name and
    // address are etc... The KeyMaster SDK does not provide any persistent 
    // storage of this data, it should be handled by clients itself.
    NSLog(@"%@", rccd.config);
    
    // Once a service name has been selected, the required data can be fetched
    // directly from the rccd by its name. If e.g. the CoreData framework is
    // utilized to persistently store the data, then the KMServiceProvider protocol
    // can be implemented on the stored objects instead.
//    id<KMServiceProvider> service = [rccd getService:@"KT_AD"];
    id<KMServiceProvider> service = [rccd getService:@"SUPERP_Active_Directory"];
    // We initialize the keytalk protocol with the selected service.
    keytalk = [[KeyTalk alloc] initForService:service withDelegate:self andHardwareDescription:@"iOS Demo Client"];
    
    // getCertificateOnSuccess takes three callback methods, one for each 
    // possible endstate: success, fail: user locked, fail: other errors.    
    [keytalk getCertificateOnSuccess:^(NSURL *url, NSData *certificate, NSString *passphrase) {
        // Here we simply store the Certificate and its passphrase to disk.
        // Typically, these will be stored in the applications keychain.
        
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:CERT_FILE contents:certificate attributes:nil];
        [fm createFileAtPath:PASS_FILE contents:[passphrase dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
        NSLog(@"Saved certificate and passphrase for URL: %@", url);
    } onLock:^() {
        NSLog(@"User locked");

    } onError:^(enum ErrorCode code, NSString *reason) {
       // Here you can do error reporting to the user and localization. E.g.:
       NSString *template;
       switch (code) {
           case errSuccess: template = @"Success: %@"; break;
           case errConfiguration: template = @"Configuration error: %@"; break;
           case errNoSecureCommunication: template = @"Could not setup secure communication: %@"; break;
           case errNetwork: template = @"Network connectivity problems: %@"; break;
           case errCommunication: template = @"Communication error in protocol: %@"; break;
           case errIpResolve: template = @"Could not resolve IPs: %@"; break;
           case errReceivedCertNoTrusted: template = @"Received untrusted certificate: %@"; break;
           case errResolvedIpInvalid: template = @"Resolved IP is not valid: %@"; break;
           case errDigestInvalid: template = @"Invalid message digest: %@"; break;
           case errTimeOutOfSync: template = @"Client and server time are out of sync: %@"; break;
           case errMaxLicensedUsersReached: template = @"Maximum number of users has been reached: %@"; break;
           case errPasswordExpired: template = @"Your password has expired: %@"; break;
           case errNotSupAuthReqRenew:
           case errNotSupAuthMethod: template = @"Not supported server reply received: %@"; break;
           case errDefault: template = @"An error has occurred: %@"; break;
       }
       NSLog(template, reason);
       
       // We can also fetch an error log to submit back to developers. The log
       // contains human readable parts and encrypted parts for the SDK developers.
       // The optional string passed to getLogReport allows addition of custom
       // information, such as e.g. the configuration (i.e. rccd.config).
       NSData *log = [KeyTalk getLogReport:[NSString stringWithFormat:@"%@", rccd.config]];
       
       NSFileManager *fm = [NSFileManager defaultManager];
       [fm createFileAtPath:ERROR_LOG contents:log attributes:nil];
   }];
}


- (void)submitCredentials:(id)param {
    if (authenticationDelay == 0) {
        NSLog(@"Submitting credentials");
        [keytalk reportCredentials:requestedCredentials];
    }
    else {
        NSLog(@"Delay requested, retrying submit after %f", authenticationDelay);
        [self performSelector:@selector(submitCredentials:) withObject:nil afterDelay:authenticationDelay];
        authenticationDelay = 0;
    }    
}


# pragma mark
# pragma mark KeyMasterDelegate methods


- (void)requestCredentials:(id<KMCredentialQuery>)credentials {
    if (credentials.usernameRequested) {
        credentials.username = self.username;
    }
    
    if (credentials.passwordRequested) {
        credentials.password = self.password;
    }
    
    if (credentials.pinRequested) {
        credentials.pin = self.pin;
    }
    if (credentials.responseRequested) {
        // List all challenges
        for (NSString *challenge in credentials.challengeOrder) {
            NSLog(@"Challenge: %@=%@", challenge, [credentials.challenges objectForKey:challenge]);
        }
        
        // Set all response to the same value. In practice, you would not do this, but
        // compute the response based on the challenges and set the appropriate key.
        for (NSString *response in credentials.responseOrder) {
            [credentials.responses setObject:@"FAB60E96" forKey:response];
        }
    }
    // @credentials.hardwareSignatureRequested
    // The hardware signature is handled by the keytalk sdk. It is possible
    // to parse the formula and handle it manually if a non-supported platform
    // is utilized or when---for whatever reason---a different hardware signature
    // is required.     
    requestedCredentials = credentials;
    [self submitCredentials:nil];
}


- (void)notifyAuthenticationSuccessWithUserMessages {
    // ignore user messages:
    // [keytalk reportUserMessagesWithLimit:0];
    
    // return them all:
    [keytalk reportUserMessagesSince:nil];
}


- (void)notifyFailureWithDelay:(NSTimeInterval)delay {
    // Received when credentials are incorrect. The client will receive a new
    // credential request. Don't call reportCredentials on the keytalk instance
    // before the indicated delay (in seconds) has expired.
    // The new credential request can (and typically will) arrive before the
    // delay has expired.
    authenticationDelay = delay;
    NSLog(@"incorrect credentials");
}


- (void)notifyUserMessages:(NSArray *)messages {
    // NSArray is an array with dictionaries containing a date (key: DATE)
    // and message (key: MESSAGE).
    NSLog(@"%@", messages);
}

- (void)notifyPasswordExpiring:(NSTimeInterval)delay {
    if (delay <= 0) {
        NSLog(@"Password has expired, but without user input I'm not going to change it.");
        return;
    }
    
    [keytalk skipChangingPassword];
}

- (void)notifyPasswordChanged {
    NSLog(@"Password succesfully changed");
}

- (void)notifyPasswordChangeFailed:(NSTimeInterval)secondsToRetry {
    NSLog(@"Error changing password, retry in %f seconds", secondsToRetry);
}

//int main(int argc, char *argv[])
//{
//    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//    }
//}

@end
