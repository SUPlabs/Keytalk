

@protocol KMCredentialQuery <NSObject>

@property (nonatomic, readonly) BOOL usernameRequested;
@property (nonatomic, strong) NSString *username;

@property (nonatomic) BOOL passwordRequested;
@property (nonatomic, strong) NSString *passwordPrompt;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, readonly) BOOL pinRequested;
@property (nonatomic, strong) NSString *pin;

/**
 * Challenge/response fields
 *
 * A challenge/response consists of an arbitrary number of challenge fields
 * (with names and values) and an arbitrary number of response fields.
 */
@property (nonatomic, readonly) BOOL responseRequested;
@property (nonatomic, strong) NSArray *challengeOrder;        // List of challenges
@property (nonatomic, strong) NSDictionary *challenges;       // Mapping challenge-name => challenge-value
@property (nonatomic, strong) NSArray *responseOrder;         // List of expected responses
@property (nonatomic, strong) NSMutableDictionary *responses;           // Should be filled with response-name => response-value

@property (nonatomic, readonly) BOOL hardwareSignatureRequested;
@property (nonatomic, readonly, strong) NSString *hardwareFormula;
@property (nonatomic, strong) NSString *hardwareSignature;

/**
 * Return the response payload string for the credentials supplied in this object
 */
- (NSString*)payloadString;

/**
 * Return whether all challenges have been answered
 */
- (BOOL)responsesProvided;

@end