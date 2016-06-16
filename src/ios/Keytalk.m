#import "Keytalk.h"
#import <Cordova/CDVPlugin.h>

@implementation Keytalk

- (void)getKeytalk:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* Keytalk = [command.arguments objectAtIndex:0];
    
    if (Keytalk != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:Keytalk];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end