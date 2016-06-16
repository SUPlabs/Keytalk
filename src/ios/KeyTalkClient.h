
#import <Foundation/Foundation.h>

#import <KeyTalk/KeyTalk.h>

@interface KeyTalkClient : NSObject<KeyTalkDelegate> {
    KeyTalk *keytalk;
    id<KMCredentialQuery> requestedCredentials;
    NSTimeInterval authenticationDelay;
}

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,strong) NSString *pin;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
