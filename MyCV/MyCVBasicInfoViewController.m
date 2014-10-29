//
//  MyCVBasicInfoViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 18/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVBasicInfoViewController.h"
#import "MyCVHomeControllerViewController.h"
#import "MyCVCustomDatePickerViewController.h"
#import "UIImage+customProperties.h"

@interface MyCVBasicInfoViewController ()
@property (nonatomic, strong)MyCVCustomDatePickerViewController *datePicker;
@property (nonatomic, strong)NSMutableArray *savedSelectedUser;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation MyCVBasicInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = (MyCVAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.profileImageView.image = self.profileImage;
    [_txtFirstName setText:self.firstName];
    [_txtLastName setText:self.lastName];
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchedUserArray = [appDelegate getUserInfo];
    self.savedSelectedUser = [[NSMutableArray alloc]init];
    
    [_btnContinue addTarget:self action:@selector(validateData) forControlEvents:UIControlEventTouchUpInside];
    [self.btnBirthDate addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!IPAD) {
        [_btnBirthDate.layer setBorderColor:[UIColor blackColor].CGColor];
        [_btnBirthDate.layer setBorderWidth:1];
        [_btnBirthDate setBackgroundColor:[UIColor whiteColor]];
    }
    [_btnBirthDate.layer setBorderColor:[UIColor blackColor].CGColor];
    [_btnBirthDate.layer setBorderWidth:1];
    [_btnBirthDate setBackgroundColor:[UIColor whiteColor]];
    for (UIView *scrollSubviews in _scrollView.subviews) {
        if ([scrollSubviews isKindOfClass:[UITextField class]]) {
            UITextField *textfield = (UITextField *)scrollSubviews;
            textfield.delegate = self;
        }
    }
    if (IPAD) {
        [self setupViewsForIPad];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignTextfield)];
    tap.numberOfTapsRequired = 1;
    self.scrollView.userInteractionEnabled  = YES;
    [_scrollView addGestureRecognizer:tap];
    [_btnChangePicture addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    if (self.comesFromConfirmPage) {
        [self.btnContinue setTitle:@"Confirm" forState:UIControlStateNormal];
    }
    
}

-(void)setupViewsForIPad
{
    for (UITextField *txtFld in self.view.subviews) {
        if ([txtFld isKindOfClass:[UITextField class]]) {
            if ([txtFld respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                UIColor *color = [UIColor whiteColor];
                txtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:txtFld.placeholder attributes:@{NSForegroundColorAttributeName: color}];
            } else {
                NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
            }
        }
    }
   
    [_btnBirthDate.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_btnBirthDate.layer setBorderWidth:0];
    [_btnBirthDate setBackgroundColor:[UIColor clearColor]];
    [_btnDismiss addTarget:self action:@selector(dismissToHome) forControlEvents:UIControlEventTouchUpInside];
}

-(void)dismissToHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
    [super viewWillDisappear:animated];
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
    self.savedSelectedUser = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    currentUser = [self.savedSelectedUser objectAtIndex:0];
    if (currentUser) {
        if (!isChangingImage) {
            _profileImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:currentUser.profilePicUrl]];
            _profileImageView.image = _profileImage;
        }
        _txtFirstName.text = currentUser.firstName;
        _txtLastName.text = currentUser.lastName;
        _txtAddress.text = currentUser.address;
        _txtEmail.text = currentUser.email;
        _txtMobile.text = currentUser.mobile;
        _txtCity.text = currentUser.city;
        _txtCountry.text = currentUser.country;
        if ([currentUser.birthdate isEqualToString:@""] || !currentUser.birthdate) {
            _lblBirthDate.text = @"Birthdate";
        }else{
             _lblBirthDate.text = currentUser.birthdate;
        }
       
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _btnContinue.frame.origin.y + _btnContinue.frame.size.height + 20);
}
-(void)resignTextfield
{
    for (UIView *scrollSubviews in _scrollView.subviews) {
        if ([scrollSubviews isKindOfClass:[UITextField class]]) {
            UITextField *textfield = (UITextField *)scrollSubviews;
            if ([textfield isFirstResponder]) {
                [textfield resignFirstResponder];
                return;
            }
        }
    }
}
-(void)validateData
{
    NSMutableString *missingFieldsMessage = [[NSMutableString alloc]initWithString:@"You are missing to fill: \n"];
    int missingFields = 0;
    if (self.txtLastName.text.length == 0 || self.txtLastName.text.length == 0) {
        if (self.txtFirstName.text.length == 0) {
            [missingFieldsMessage appendString:@" First name"];
            missingFields++;
        }
        if (self.txtLastName.text.length == 0) {
            if (missingFields > 0) {
                [missingFieldsMessage appendString:@", Last name"];
            }else{
                [missingFieldsMessage appendString:@" Last name"];
            }
            
        }
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:missingFieldsMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }else{
        [self updateUserInfoWithSuccess:^(NSString *userState) {
            if ([userState isEqualToString:@"YES"]) {
                if (self.comesFromConfirmPage) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                [self performSegueWithIdentifier:@"educationSegue" sender:self];
                }
            }
        } failure:^(NSString *failed) {
            if ([failed isEqualToString:@"NO"]) {
                
            }
        }];
    }
}

-(void)showDatePicker:(UIButton *)dateButton
{
    MyCVCustomDatePickerViewController* picker = [[MyCVCustomDatePickerViewController alloc] initWithDelegate:self];
    picker.pickerHeight = 240;
    [picker.toolbarLabel setText:@"Birthdate"];
    [picker.view setBackgroundColor:[UIColor whiteColor]];
    [self showPicker:picker];
}
- (void)pickerWasCancelled:(MyCVCustomDatePickerViewController *)picker
{
    for (UIView *scrollSubviews in _scrollView.subviews) {
        if ([scrollSubviews isKindOfClass:[UITextField class]]) {
            UITextField *textfield = (UITextField *)scrollSubviews;
            textfield.enabled = YES;
        }
    }
}

-(void)picker:(MyCVCustomDatePickerViewController *)picker pickedDate:(NSDate *)date
{
    for (UIView *scrollSubviews in _scrollView.subviews) {
        if ([scrollSubviews isKindOfClass:[UITextField class]]) {
            UITextField *textfield = (UITextField *)scrollSubviews;
            textfield.enabled = YES;
        }
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"dd/MMM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    
    [_lblBirthDate setText:dateString];
}

- (void)showPicker:(MyCVCustomDatePickerViewController *)picker
{
    for (UIView *scrollSubviews in _scrollView.subviews) {
        if ([scrollSubviews isKindOfClass:[UITextField class]]) {
            UITextField *textfield = (UITextField *)scrollSubviews;
            textfield.enabled = NO;
        }
    }
    
    UIViewController* parent = self.parentViewController.parentViewController;
    if (parent == nil)
        parent = self.parentViewController;
    
    if (parent == nil)
        parent = self;
    [picker showInViewController:parent];
    picker.view.backgroundColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
    // Move the main window frame to make room for the keyboard.
    
    if ((textField.frame.origin.y + textField.frame.size.height) >  (self.view.frame.size.height / 2)) {
        
        CGRect currentFrame = self.view.frame;
        currentFrame.origin.y = -40;
        
        // Animate the frame change.
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             if (self.view.frame.size.height > 500 && self.view.frame.size.height < 1000) {
                                 [_scrollView setContentOffset:CGPointMake(0,textField.center.y -290) animated:YES];
                                 
                             } else if(self.view.frame.size.height > 1000){
                                 [_scrollView setContentOffset:CGPointMake(0,textField.center.y -480) animated:YES];
                             }else{
                                 [_scrollView setContentOffset:CGPointMake(0,textField.center.y -180) animated:YES];
                                 
                             }
                             
                             
                         }
                         completion:^(BOOL finished) {
                         }
         ];
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        if (nextTag == 1003) {
            [textField resignFirstResponder];
            [self showDatePicker:_btnBirthDate];
        }else{
            [nextResponder becomeFirstResponder];
        }
        
    } else {
        // Not found, so remove keyboard.
        CGFloat differenceHeights =self.scrollView.contentSize.height - self.view.frame.size.height - self.btnContinue.frame.size.height;

        [textField resignFirstResponder];
         [_scrollView setContentOffset:CGPointMake(0,differenceHeights + 50) animated:YES];
       
    }
    return NO; // We do not want UITextField to insert line-breaks.
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    // Move the main window frame to make room for the keyboard.
    
    if ((textField.frame.origin.y + textField.frame.size.height) >  (self.view.frame.size.height / 2)) {
        
        CGRect currentFrame = self.view.frame;
        currentFrame.origin.y = -40;
        
        // Animate the frame change.
        CGFloat differenceHeights =self.scrollView.contentSize.height - self.view.frame.size.height - self.btnContinue.frame.size.height;
        
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [_scrollView setContentOffset:CGPointMake(0,differenceHeights + 50) animated:YES];
                         }
                         completion:^(BOOL finished) {
                         }
         ];
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == _txtMobile) {
    int length = [self getLength:textField.text];
    //NSLog(@"Length  =  %d ",length);
    
   /* if(length == 10)
    {
        NSMutableString *num = [NSMutableString stringWithString:[self formatNumber:textField.text]];
        [num insertString:@"+" atIndex:0];
        [num insertString:@"(" atIndex:2];
        [num insertString:@")" atIndex:5];
        [num insertString:@"-" atIndex:10];
        textField.text = num;
        
    }
    
    if (length == 11) {
        NSMutableString *num = [NSMutableString stringWithString:[self formatNumber:textField.text]];
        [num insertString:@"+" atIndex:0];
        [num insertString:@"(" atIndex:3];
        [num insertString:@")" atIndex:7];
        [num insertString:@"-" atIndex:11];
        textField.text = num;
        
    }*/
        
    if (length == 13) {
       /* NSMutableString *num = [NSMutableString stringWithString:[self formatNumber:textField.text]];
        [num insertString:@"+" atIndex:0];
        [num insertString:@"(" atIndex:3];
        [num insertString:@")" atIndex:6];
        textField.text = num;*/
        if(range.length == 0)
            return NO;
    }
        
  /*  if(length == 3)
    {
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6)
    {
        NSString *num = [self formatNumber:textField.text];
        //NSLog(@"%@",[num  substringToIndex:3]);
        //NSLog(@"%@",[num substringFromIndex:3]);5
        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }*/
    /*else if(length == 10)
    {
        NSString *num = [self formatNumber:textField.text];
        //textField.text = [NSString stringWithFormat:@"+%@ (%@) %@-", [num substringToIndex:1], [num substringFromIndex:1], [num substringFromIndex:4]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"+ %@ (%@) %@-%@",[num substringFromIndex:2], [num substringFromIndex:3], [num substringFromIndex:3], [num substringFromIndex:3]];
    }*/
        
        
    }
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    int length = [mobileNumber length];
    if(length > 11)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    
    return mobileNumber;
}


-(int)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = [mobileNumber length];
    
    return length;
    
    
}


#pragma mark - Camera Methods
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

-(void)getPicture
{
    if (pickFromCamera) {
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

   chosenImage = [UIImage imageWithImage:chosenImage scaledToSize:CGSizeMake(400, 400)];
    self.profileImage = chosenImage;
    self.profileImageView.image = chosenImage;
    isChangingImage = YES;
    
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark Core Data Methods
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)updateUserInfoWithSuccess:(UserSavedSuccess)success failure:(UserUpdatedFailed)failed
{
    
    NSManagedObject *newUserInfo= [self.savedSelectedUser objectAtIndex:0];
    
    if (isChangingImage) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:[NSString stringWithFormat:@"%@_%@.png", _txtLastName.text, _txtFirstName.text]]];
        NSData *data = UIImagePNGRepresentation(self.profileImage);
        self.imageURL = path;
        [data writeToFile:path atomically:YES];
        
    }
    
    if (![currentUser.firstName isEqualToString:_txtFirstName.text]||![currentUser.lastName isEqualToString:_txtLastName.text]||![currentUser.mobile isEqualToString:_txtMobile.text]||![currentUser.birthdate isEqualToString:_lblBirthDate.text]||![currentUser.email isEqualToString:_txtEmail.text]||![currentUser.address isEqualToString:_txtAddress.text]||![currentUser.city isEqualToString:_txtCity.text]||![currentUser.country isEqualToString:_txtCountry.text] || isChangingImage) {
        
        
        if (self.txtFirstName.text.length != 0) {
            
            [newUserInfo setValue:self.txtFirstName.text forKey:@"firstName"];
        }if (self.txtLastName.text.length != 0) {
            
            [newUserInfo setValue:self.txtLastName.text forKey:@"lastName"];
        }if (self.txtMobile) {
            
            [newUserInfo setValue:self.txtMobile.text forKey:@"mobile"];
        }if (self.txtEmail.text.length != 0) {
            
            [newUserInfo setValue:self.txtEmail.text forKey:@"email"];
        }if (self.txtAddress) {
            
            [newUserInfo setValue:self.txtAddress.text forKey:@"address"];
        }if ((_lblBirthDate) || ![_lblBirthDate.text isEqualToString:@"Birthdate"]) {
            [newUserInfo setValue:_lblBirthDate.text forKey:@"birthdate"];
        }if (_txtCity) {
            [newUserInfo setValue:_txtCity.text forKey:@"city"];
        }if (_txtCountry) {
            [newUserInfo setValue:_txtCountry.text forKey:@"country"];
        }
        if (isChangingImage) {
            if (self.imageURL) {
                [newUserInfo setValue:_imageURL forKey:@"profilePicUrl"];
            }
            isChangingImage = NO;
        }
    }
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        failed(@"NO");
    }
    success(@"YES");
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"educationSegue"]) {
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (IBAction)getCurrentLocationPressed:(id)sender {
    // [self dismissKeyboard:nil];
    [self.locationActivityIndicator startAnimating];
    self.locationActivityIndicator.hidden = NO;
    [self.btnCurrentLocation setEnabled:NO];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}
#pragma mark - Core Location Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    [manager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || ([placemarks count] == 0)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not find your location. Please make sure you have a cellular, GPS or WiFi signal and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        if ([placemarks count] > 0) {
            self.currentLocationString = [NSString stringWithFormat:@"%@, %@", [[placemarks objectAtIndex:0] locality], [[placemarks objectAtIndex:0] administrativeArea]];
            self.currentLocationCountry =[(CLPlacemark *)[placemarks objectAtIndex:0] country];
            [self.txtCity setText:self.currentLocationString];
            [self.txtCountry setText:self.currentLocationCountry];
            
            [self.locationActivityIndicator stopAnimating];
        }
        
        [self.locationActivityIndicator stopAnimating];
        [self.btnCurrentLocation setEnabled:YES];
    }];

}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not find your location. If you did not not cancel the request, please make sure you have a cellular, GPS or WiFi signal and try again." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    [self.locationActivityIndicator stopAnimating];
    
    [self.btnCurrentLocation setEnabled:YES];
}

@end
