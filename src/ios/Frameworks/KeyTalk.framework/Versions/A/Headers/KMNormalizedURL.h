
@interface KMNormalizedURL : NSObject

@property NSString *scheme;
@property NSString *user;
@property NSString *password;
@property NSString *host;
@property NSString *port;
@property NSString *path;
@property NSString *query;

- (KMNormalizedURL *)initWithString:(NSString *)url;
- (KMNormalizedURL *)initWithString:(NSString *)url removeWWW:(BOOL)remove;
- (KMNormalizedURL *)initWithURL:(NSURL *)url removeWWW:(BOOL)remove;

- (NSURL *)normalizedURL;
- (BOOL)matchesURL:(KMNormalizedURL *)url;

@end
