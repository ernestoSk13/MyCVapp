//
//  MyCVBaseViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 17/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@interface MyCVBaseViewController : UIViewController
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *viewBg;
-(void)showLoadingIndicator;
-(void)hideLoadingIndicator;
@end
