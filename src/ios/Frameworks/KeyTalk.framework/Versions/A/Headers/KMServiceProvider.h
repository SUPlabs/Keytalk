
@protocol KMServiceProvider <NSObject>

@property (readonly, nonatomic) NSString *serviceName;
@property (readonly, nonatomic) NSString *serverAddress;
@property (readonly, nonatomic) NSData *serverPublicKeyData;
@property (readonly, nonatomic) NSData *UCAderData;

@end
