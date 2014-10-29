//
//  MyCVInterstitialAppDelegate.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 08/09/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyCVConfirmationViewController;
@interface MyCVInterstitialAppDelegate : NSObject

@property(nonatomic, weak) IBOutlet UIWindow *window;
@property(nonatomic, weak) IBOutlet MyCVConfirmationViewController *mainController;
@end
