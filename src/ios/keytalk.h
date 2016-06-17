// SUPERP

#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KeyTalkClient.h"

@interface CDVKeytalk : CDVPlugin{
    KeyTalkClient *client;
}

- (void)login:(CDVInvokedUrlCommand*)command;

@end