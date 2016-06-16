@interface KMHwSignature : NSObject {}

+ (NSArray *)parseFormula:(NSString *)formula;
+ (NSString *)calcHwSignature:(NSString *)formula;

@end