//
//  MyCVLandingViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 13/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
typedef void (^UserSavedSuccess)(NSString *playerState);
typedef void (^UserSavedError)();
@interface MyCVLandingViewController : MyCVBaseViewController<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL   pickFromCamera;
    MyCVAppDelegate * appDelegate;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtDegreeTitle;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) NSString *imageURL;
@property (nonatomic,strong)NSArray* fetchedUserArray;


- (IBAction)continueAction:(id)sender;
- (IBAction)getPicture;
- (IBAction)showActionSheet:(id)sender;

@end
