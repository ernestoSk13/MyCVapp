//
//  MyCVViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 06/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuController.h"

@import QuartzCore;
@interface MyCVViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) MenuController *menuController;
@property (weak, nonatomic) IBOutlet UIView *blurredView;

@end
