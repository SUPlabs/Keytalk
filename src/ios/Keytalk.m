#import "Keytalk.h"
#import "KeyTalkClient.h"
#import <Cordova/CDV.h>

@implementation CDVKeytalk

- (void)login:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];
    
    if (echo != nil && [echo length] > 0) {
        client = [[KeyTalkClient alloc] initWithDict:@{ @"username" : [command.arguments objectAtIndex:0],
                                                        @"password" : [command.arguments objectAtIndex:1]}];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

@end