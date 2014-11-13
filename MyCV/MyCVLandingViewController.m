
//
//  MyCVLandingViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 13/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVLandingViewController.h"
#import "UIImage+customProperties.h"
#import "MyCVUtilities.h"
#import "MyCVHomeControllerViewController.h"
#import "UserInfo.h"

@interface MyCVLandingViewController ()
@property (strong) UserInfo *savedUser;
@end

@implementation MyCVLandingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(CGFloat)getScreenHeight
{
    return self.view.frame.size.height;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtDegreeTitle.delegate = self;
    self.txtFirstName.delegate = self;
    self.txtLastName.delegate = self;
    [self.profileImage.layer setCornerRadius:100];
    [self.profileImage.layer setMasksToBounds:YES];
    [self.profileImage.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.profileImage.layer setBorderWidth:4];
    self.fetchedUserArray = [sharedDataHelper getInfoForItem:@"UserInfo"];

}





-(void)saveUserInfo:(UserSavedSuccess)success onError:(UserSavedError)savingError
{
    if (self.originalImage) {
        NSURL *destination = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]URLByAppendingPathComponent:@"MyProfilePic/profile.png"];
        //[[NSFileManager defaultManager]copyItemAtURL:resource toURL:destination error:nil];
        NSString *thePath = [NSString stringWithFormat:@"%@", destination];
        
        
        NSData *data = UIImagePNGRepresentation(self.originalImage);
        self.imageURL = thePath;
        [data writeToFile:thePath atomically:YES];
    }else{
        self.imageURL = @"";
    }
    
    [sharedDataHelper setNewUser:@{@"userId"   :@"1",
                                   @"firstName":_txtFirstName.text,
                                   @"lastName" : _txtLastName.text,
                                   @"degree"   :_txtDegreeTitle.text,
                                   @"profilePicUrl" : self.imageURL
                                   } withSuccess:^(NSString *successString) {
                                       self.savedUser = [sharedDataHelper savedUserInfo];
        success(@"userSaved");
    } orError:^(NSString *errorString, NSDictionary *errorDict) {
        savingError(errorString);
    }];
    
   
    //self.savedUser = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.view.superview.bounds = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
}
-(void)viewDidLayoutSubviews
{
    
    if ([self getScreenHeight] < 568) {
        self.scrollView.scrollEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                                 670);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showActionSheet:(id)sender {
    [self showProfilePicture];
}
-(void)showProfilePicture
{
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Album", nil];
        [myActionSheet showInView:self.view];
   
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        pickFromCamera = YES;
        [self getPicture];
    }else{
        pickFromCamera = NO;
        [self getPicture];
    }
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    if (textField == self.txtDegreeTitle) {
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 568);
    }else{
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 568);
    }
    [textField becomeFirstResponder];
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         if ([self getScreenHeight] < 568) {
                             [_scrollView setContentOffset:CGPointMake(0,textField.center.y - 200) animated:YES];
                         }else{
                             [_scrollView setContentOffset:CGPointMake(0,textField.center.y - 280) animated:YES];
                         }
                         
                     }
                     completion:^(BOOL finished) {
                     }
     ];

    
}

-(void)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         if ([self getScreenHeight]<568) {
                             [_scrollView setContentOffset:CGPointMake(0,_btnContinue.frame.size.height + 50)];
                         }else{
                             [_scrollView setContentOffset:CGPointMake(0,0)];
                         }
                     }
                     completion:^(BOOL finished) {
                     }
     ];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionAllowAnimatedContent
                     animations:^{
                         if ([self getScreenHeight]<568) {
                             [_scrollView setContentOffset:CGPointMake(0,_btnContinue.frame.size.height + 50)];
                         }else{
                             [_scrollView setContentOffset:CGPointMake(0,0)];
                         }
                     }
                     completion:^(BOOL finished) {
                     }
     ];
    return YES;
}


-(void)getPicture
{
    if (pickFromCamera) {
        if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Sorry, there is no available camera on this device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.originalImage = chosenImage;
    [UIImage imageWithImage:chosenImage scaledToSize:CGSizeMake(400, 400)];
    self.profileImage.image = chosenImage;

    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)continueAction:(id)sender{
    
    if (_txtFirstName.text.length > 0 && _txtLastName.text.length > 0) {
        MyCVHomeControllerViewController *homeVC = [[MyCVUtilities sharedInstance] homeVCObject];
        [self saveUserInfo:^(NSString *userState) {
            [self dismissViewControllerAnimated:YES completion:^{
                NSString *completeName = [NSString stringWithFormat:@"%@ %@", self.txtFirstName.text, self.txtLastName.text];
                [homeVC setLandingInformationWithName:completeName degree:self.txtDegreeTitle.text andImage:self.originalImage];
            }];
        } onError:^{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Your info couldn't be saved correctly" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }];

    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"First Name and Last Name textfields are required!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    
    
    
}
@end
