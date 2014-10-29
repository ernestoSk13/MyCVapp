//
//  MyCVComingFeaturesViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 08/09/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
@import iAd;
@class GADBannerView;
@interface MyCVComingFeaturesViewController : MyCVBaseViewController <UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate, ADBannerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (nonatomic, strong) MenuController *menuController;
-(IBAction)openMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@end
