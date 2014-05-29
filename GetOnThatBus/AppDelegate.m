//
//  AppDelegate.m
//  GetOnThatBus
//
//  Created by Robert Figueras on 5/28/14.
//
//

#import "AppDelegate.h"
#import <CheckMate/CheckMate.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [CheckMate initializeFramework:@[@"d3006ae1b0e73d5213da0c7ca54c0af5",@"35463545c307ccc6b259f908f62dbea4"]];
    return YES;
}


@end
