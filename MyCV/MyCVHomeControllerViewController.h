//
//  MyCVHomeControllerViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 06/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UserInfo.h"
#import "MenuController.h"


@import iAd;
@class MyCVBasicInfoViewController, GADBannerView;
typedef void (^UserSavedSuccess)(NSString *userState);
typedef void (^UserSavedError)();
typedef void (^DatabaseClearSuccess)(BOOL success);

@interface MyCVHomeControllerViewController : MyCVBaseViewController<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, ADBannerViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    MyCVAppDelegate * appDelegate;
    UserInfo *selectedUser;
    MyCVBasicInfoViewController *landingVC ;
    BOOL hasStartedWithResume;
}
@property (weak, nonatomic) IBOutlet UIButton *btnReset;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnStartResume;
@property (weak, nonatomic) IBOutlet UIButton *btnReviewResume;
@property (nonatomic, strong) MenuController *menuController;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *lblDegree;
@property (weak, nonatomic) IBOutlet UILabel *lblCompleteName;
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet UIView *viewBlurredImage;
@property (weak, nonatomic) IBOutlet UIView *viewTransparency;
@property (weak, nonatomic) IBOutlet UIImageView *blurredImageView;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong)NSArray* fetchedUserArray;

// iPad functionality

@property (weak, nonatomic) IBOutlet UICollectionView *collectionSections;
@property (strong, nonatomic) NSDictionary *dictSections;
@property (strong, nonatomic) NSArray *arraySections;
@property (strong, nonatomic) UIView *tutorialView;


//iPad assets
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnComingSoon;
-(IBAction)openMenu:(id)sender;
-(void)setLandingInformationWithName:(NSString *)name degree:(NSString *)degree andImage:(UIImage *)image;
@end
