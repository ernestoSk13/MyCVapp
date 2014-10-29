//
//  MyCVViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 05/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuController;

@protocol MyCVMenuDelegate <NSObject>
@required

-(UITableView *)tableViewForMenu: (MenuController *)menu;
-(UIViewController *)menu:(MenuController *)menu viewControllerAtIndexpath:(NSIndexPath *)indexpath;

@optional

-(CGFloat)widthControllerForMenu:(MenuController *)menu;
-(CGFloat)minScaleForMenu:(MenuController *)menu;
-(CGFloat)minScaleTableForMenu:(MenuController *)menu;
-(CGFloat)minAlphaTableForMenu:(MenuController *)menu;

@end

@interface MenuController : UIViewController

@property  (nonatomic, readonly, strong) UIViewController *currentViewController;
@property  (nonatomic, weak)   id<MyCVMenuDelegate> menuDelegate;
@property (nonatomic, assign,readonly) BOOL isMenuOpened;
@property  (nonatomic, assign) BOOL isMenuOnRight;
+(instancetype)sharedMenu;
-(void)openMenuAnimated;
-(void)closeMenuAnimated;
-(void)reloadMenuAfterRegister;
@property (nonatomic, strong)UIImage *profileImage;
@property (nonatomic, assign)NSString *firstName;
@property (nonatomic, assign)NSString *lastName;
@property (nonatomic, assign)NSString *degree;


@end
