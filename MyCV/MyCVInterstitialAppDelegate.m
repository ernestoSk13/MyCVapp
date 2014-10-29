//
//  MyCVInterstitialAppDelegate.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 08/09/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVInterstitialAppDelegate.h"

@implementation MyCVInterstitialAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self.window setRootViewController:(UIViewController *)self.mainController];
    [self.window makeKeyAndVisible];
    
    return YES;
}
@end
