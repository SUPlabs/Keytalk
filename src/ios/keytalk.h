//#import <Cordova/CDVPlugin.h>
//
//@interface Keytalk : CDVPlugin
//
//- (void)getKeytalk:(CDVInvokedUrlCommand*)command;
//
//@end
#import <Cordova/CDV.h>

@interface Keytalk : CDVPlugin <UIAlertViewDelegate> {}
- (void)alert:(CDVInvokedUrlCommand*)command;
@end

@interface MyAlertView : UIAlertView {}
@property (nonatomic, copy) NSString* callbackId;
@end