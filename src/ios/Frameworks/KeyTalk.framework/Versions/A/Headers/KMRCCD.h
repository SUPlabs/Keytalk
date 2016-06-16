
#import "KMServiceProvider.h"


#pragma mark -
#pragma mark Public Interface declaration

@interface KMRCCD : NSObject {
}


#pragma mark -
#pragma mark Property declarations

@property (strong, nonatomic) NSDictionary *config;
@property (strong, nonatomic) NSData *iconImageData;
@property (strong, nonatomic) NSData *logoImageData;
@property (strong, nonatomic) NSData *clientServerCommunicationKeyData;
@property (strong, nonatomic) NSData *rootCertificateDERData;
@property (strong, nonatomic) NSData *primaryCertificateDERData;
@property (strong, nonatomic) NSData *userCertificateDERData;
@property (strong, nonatomic) NSData *serverCertificateDERData;


#pragma mark -
#pragma mark Method declarations

- (KMRCCD *)initWithData:(NSData *)archiveData;
- (id<KMServiceProvider>)getService:(NSString *)serviceName;

@end