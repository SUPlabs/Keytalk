#import "Keytalk.h"
#import <Cordova/CDVPlugin.h>

@implementation Keytalk
//
//- (void)getKeytalk:(CDVInvokedUrlCommand*)command
//{
//    CDVPluginResult* pluginResult = nil;
//    NSString* Keytalk = [command.arguments objectAtIndex:0];
//    
//    if (Keytalk != nil && [Keytalk length] > 0) {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:Keytalk];
//    } else {
//        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
//    }
//    
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//}
//
//@end
- (void)pluginInitialize
{
}

- (void)alert:(CDVInvokedUrlCommand*)command
{
    NSString* callbackId = command.callbackId;
    NSString* title = [command argumentAtIndex:0];
    NSString* message = [command argumentAtIndex:1];
    NSString* button = [command argumentAtIndex:2];
    
    MyAlertView *alert = [[MyAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:self
                          cancelButtonTitle:button
                          otherButtonTitles:nil];
    alert.callbackId = callbackId;
    [alert show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    MyAlertView* myAlertView = (MyAlertView*)alertView;
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                   messageAsInt:0];
    [self.commandDelegate sendPluginResult:result callbackId:myAlertView.callbackId];
}
@end

@implementation MyAlertView
@synthesize callbackId;
@end