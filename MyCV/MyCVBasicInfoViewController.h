//
//  MyCVBasicInfoViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 18/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCVCustomDatePickerViewController.h"
#import <CoreData/CoreData.h>
#import "UserInfo.h"
@import CoreLocation;
typedef void (^UserUpdatedSuccess)(NSString *success);
typedef void (^UserUpdatedFailed)(NSString *failed);

@interface MyCVBasicInfoViewController : MyCVBaseViewController<MyCVDatePickerDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate>
{
    BOOL   pickFromCamera;
    UserInfo *currentUser;
    MyCVAppDelegate *appDelegate;
    BOOL isChangingImage;
}
@property (nonatomic, assign)NSString *firstName;
@property(nonatomic, assign)NSString *lastName;
@property(nonatomic, assign)NSString *currentLocationString;
@property(nonatomic, assign)NSString *currentLocationCountry;
@property (nonatomic, assign)NSString *degreeTitle;
@property (nonatomic, strong)UIImage *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePicture;
@property (weak, nonatomic) IBOutlet UILabel *lblBirthDate;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UIButton *btnBirthDate;
@property (weak, nonatomic) IBOutlet UIButton *btnCurrentLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtCity;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnNextController;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UITextField *txtCountry;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *locationActivityIndicator;
@property (strong, nonatomic) NSString *imageURL;
@property (nonatomic,strong)NSArray* fetchedUserArray;
@property(nonatomic) BOOL comesFromConfirmPage;

//IPAD
@property (weak, nonatomic) IBOutlet UIButton *btnDismiss;





- (IBAction)getCurrentLocationPressed:(id)sender;
@end
