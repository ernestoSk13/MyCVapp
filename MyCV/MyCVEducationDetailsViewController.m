//
//  MyCVEducationDetailsViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 26/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVEducationDetailsViewController.h"
#import "MyCVPickerViewController.h"
#import "UserEducation.h"

@interface MyCVEducationDetailsViewController ()
@property (strong, nonatomic)NSMutableArray *savedEducation;
@property (strong, nonatomic)NSMutableArray *savedUser;
@property(strong, nonatomic)MyCVPickerViewController *degreePicker;
@property(strong, nonatomic)MyCVPickerViewController *monthPicker;
@property(strong, nonatomic)MyCVPickerViewController *yearPicker;
@end

@implementation MyCVEducationDetailsViewController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipadBg"]]];
    appDelegate = (MyCVAppDelegate*)[[UIApplication sharedApplication] delegate];
    degreesArray = @[@"Less Than High School Diploma",
                     @"High School Diploma or GED",
                     @"Certificate",
                     @"Some College Courses",
                     @"Associate's Degree",
                     @"Bachelor's Degree",
                     @"Post-Baccalaureate Certificate",
                     @"Master's Degree",
                     @"Post Master's Certificate",
                     @"First Professional Degree",
                     @"Doctoral Degree",
                     @"Post-Doctoral Training"];
    self.managedObjectContext = [sharedDataHelper managedObjectContext];
    self.fetchedEducationArray = [sharedDataHelper getInfoForItem:@"UserEducation"];
    self.savedEducation = [[NSMutableArray alloc]init];
    [self loadUI];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignTextfield)];
    tap.numberOfTapsRequired = 1;
    self.scrollView.userInteractionEnabled  = YES;
    [_scrollView addGestureRecognizer:tap];
   
    
    monthsArray = [[NSMutableArray alloc]initWithObjects:
                   @"JAN",
                   @"FEB",
                   @"MAR",
                   @"APR",
                   @"MAY",
                   @"JUN",
                   @"JUL",
                   @"AUG",
                   @"SEP",
                   @"OCT",
                   @"NOV",
                   @"DEC", nil];
    _btnLastYear.enabled = NO;
    _btnLastMonth.enabled = NO;
    for (UIView *subviews in self.scrollView.subviews) {
        if ([subviews isKindOfClass:[UITextField class]]) {
            UITextField *textfield = (UITextField *)subviews;
            textfield.delegate = self;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    NSManagedObjectContext *managedObjectContext = [sharedDataHelper managedObjectContext];
    
    NSFetchRequest *fetchEducationeRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserEducation"];
    self.savedEducation = [[managedObjectContext executeFetchRequest:fetchEducationeRequest error:nil] mutableCopy];
    NSFetchRequest *fetchUserRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
    self.savedUser = [[managedObjectContext executeFetchRequest:fetchUserRequest error:nil] mutableCopy];
    if ([self.savedUser count]>0) {
        currentUser = [self.savedUser objectAtIndex:0];
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    int yearValue = [yearString intValue];
    int statingYear = 1920;
    if (currentUser) {
        NSString *dateString = currentUser.birthdate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setDateFormat:@"dd/MMM/yyyy"];
        NSDate *dateFromString = [[NSDate alloc] init];
        // voila!
        dateFromString = [dateFormatter dateFromString:dateString];
        dateString = [formatter stringFromDate:dateFromString];
        statingYear = [dateString intValue];
    }
    
    
    for (int x = statingYear; x<=yearValue; x++) {
        [yearsArray addObject:[NSString stringWithFormat:@"%d", x]];
    }
    if (self.hasDataStored) {
        currentUserEducation = [self.savedEducation objectAtIndex:self.selectedEducationIndex];
        [_txtMajorName setText:currentUserEducation.majorDegree];
        [_lblDegree setText:currentUserEducation.degree];
        [_txtSchoolName setText:currentUserEducation.schoolName];
        [_txtLocation  setText:currentUserEducation.location];
        [_lblFirstMonth setText:currentUserEducation.firstMonth];
        [_lblFirstYear setText:currentUserEducation.firstYear];
        [_lblLastMonth setText:currentUserEducation.lastMonth];
        if ([currentUserEducation.lastMonth isEqualToString:@"Present"]) {
            [_btnLastYear setHidden:YES];
            [_lblLastYear setHidden:YES];
        }else{
            [_lblLastYear setText:currentUserEducation.lastYear];
        }
    }
    
}

-(void)loadUI
{
    [_btnSave addTarget:self action:@selector(validateData) forControlEvents:UIControlEventTouchUpInside];
    [_btnDegree.layer setBorderColor:[UIColor blackColor].CGColor];
    [_btnDegree.layer setBorderWidth:1];
    [_btnDegree setBackgroundColor:[UIColor whiteColor]];
    [_btnDegree addTarget:self action:@selector(showDegreePicker:) forControlEvents:UIControlEventTouchUpInside];
    [_btnFirstMonth addTarget:self action:@selector(showMonthPicker:) forControlEvents:UIControlEventTouchUpInside];
    _btnFirstMonth.tag = 1001;
    [_btnFirstYear addTarget:self action:@selector(showYearPicker:) forControlEvents:UIControlEventTouchUpInside];
    _btnFirstYear.tag = 1002;
    [_btnLastMonth addTarget:self action:@selector(showMonthPicker:) forControlEvents:UIControlEventTouchUpInside];
    _btnLastMonth.tag = 2001;
    [_btnLastYear addTarget:self action:@selector(showYearPicker:) forControlEvents:UIControlEventTouchUpInside];
    _btnLastYear.tag = 2002;
    yearsArray = [[NSMutableArray alloc]init];
    [_btnCancel setTarget:self];
    [_btnCancel setAction:@selector(cancelAndDismiss)];
    _btnLastYear.enabled = NO;
    _btnLastMonth.enabled = NO;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _btnSave.frame.origin.y + _btnSave.frame.size.height + 20);
}

-(void)validateData
{
    if (currentUserEducation) {
        [self updateEducationInfoWithSuccess:^(NSString *success) {
            [self cancelAndDismiss];
        } failure:^(NSString *failed) {
           
        }];
    }else{
        [self saveEducationInfo:^(NSString *success) {
             [self cancelAndDismiss];
        } onError:^(NSString *failed) {
            
        }];
    }
}

#pragma mark - Picker Methods

-(void)showDegreePicker:(UIButton *)sender
{
    self.btnSave.enabled = YES;
    self.degreePicker= [[MyCVPickerViewController alloc]initWithDelegate:self];
    self.degreePicker.view.backgroundColor = [UIColor whiteColor];
    self.degreePicker.pickerHeight = 250;
    [self.degreePicker.toolbarLabel setText:@"Select degree"];
    self.degreePicker.pickerItems = [[NSArray alloc]initWithArray:degreesArray];
    [self.degreePicker showInViewController:self];
    self.degreePicker.view.tag = 1;
}

-(void)showMonthPicker:(UIButton *)sender
{
    self.btnSave.enabled = YES;
    self.monthPicker= [[MyCVPickerViewController alloc]initWithDelegate:self];
    self.monthPicker.view.backgroundColor = [UIColor whiteColor];
    self.monthPicker.pickerHeight = 250;
    [self.monthPicker.toolbarLabel setText:@"Select month"];
    if (sender.tag == 1001) {
        self.monthPicker.view.tag = 21;
        if (monthsArray.count == 13) {
            [monthsArray removeObjectAtIndex:0];
        }
           }else{
               if (monthsArray.count < 13) {
                   [monthsArray insertObject:@"Present" atIndex:0];
               }
               self.monthPicker.view.tag = 31;
        
    }
    self.monthPicker.pickerItems = [[NSArray alloc]initWithArray:monthsArray];
    [self.monthPicker showInViewController:self];
}
-(void)showYearPicker:(UIButton *)sender
{
    self.btnSave.enabled = YES;
    self.yearPicker= [[MyCVPickerViewController alloc]initWithDelegate:self];
    self.yearPicker.view.backgroundColor = [UIColor whiteColor];
    self.yearPicker.pickerHeight = 250;
    [self.yearPicker.toolbarLabel setText:@"Select degree"];
   
    
    if (sender.tag == 1002) {
         self.yearPicker.view.tag = 22;
        self.yearPicker.pickerItems = [[NSArray alloc]initWithArray:yearsArray];
       
    }else{
        self.yearPicker.view.tag = 32;
        lastYearsArray = [[NSMutableArray alloc]init];
        int firstYear = [_lblFirstYear.text intValue];
        for (int x = firstYear; x<2030; x++) {
            [lastYearsArray addObject:[NSString stringWithFormat:@"%d", x]];
        }
        self.yearPicker.pickerItems = [[NSArray alloc]initWithArray:lastYearsArray];
    }
     [self.yearPicker showInViewController:self];
}


-(void)pickerWasCancelled:(MyCVPickerViewController *)picker
{
    
}

-(void)picker:(MyCVPickerViewController *)picker pickedValueAtIndex:(NSInteger)index
{
    switch (picker.view.tag) {
        //Degree picker
        case 1:
            [_lblDegree setText:[picker.pickerItems objectAtIndex:index]];
            break;
        //First Month picker
        case 21:
            [_lblFirstMonth setText:[picker.pickerItems objectAtIndex:index]];
            [_lblFirstMonth  setTextColor:[UIColor blackColor]];
            break;
        //First Year picker
        case 22:
            [_lblFirstYear setText:[picker.pickerItems objectAtIndex:index]];
            [_lblFirstYear setTextColor:[UIColor blackColor]];
            _btnLastMonth.enabled = YES;
            _btnLastYear.enabled = YES;
            break;
            //Last Month picker
        case 31:
            [_lblLastMonth setText:[picker.pickerItems objectAtIndex:index]];
            [_lblLastMonth setTextColor:[UIColor blackColor]];
            if ([_lblLastMonth.text isEqualToString:@"Present"]) {
                [_btnLastYear setHidden:YES];
                [_lblLastYear setHidden:YES];
            }else{
                [_btnLastYear setHidden:NO];
                [_lblLastYear setHidden:NO];
            }
            break;
            //Last Year picker
        case 32:
            [_lblLastYear setText:[picker.pickerItems objectAtIndex:index]];
            [_lblLastYear setTextColor:[UIColor blackColor]];
            break;
        default:
            break;
    }
}

-(void)cancelAndDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Core Data Methods

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = sharedDataHelper;
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)saveEducationInfo:(EducationSavedSuccessfully)success onError:(EducationSavedFailed)savingError
{
    
    
    NSManagedObjectContext *context = [sharedDataHelper managedObjectContext];
    UserEducation *education = [NSEntityDescription insertNewObjectForEntityForName:@"UserEducation" inManagedObjectContext:context];
    education.majorDegree   = _txtMajorName.text;
    education.schoolName    = _txtSchoolName.text;
    education.location      = _txtLocation.text;
    education.firstMonth    = _lblFirstMonth.text;
    education.firstYear     = _lblFirstYear.text;
    education.lastMonth     = _lblLastMonth.text;
    if ([_lblLastMonth.text isEqualToString:@"Present"]) {
        education.lastYear  = @"";
    }else{
        education.lastYear  = _lblLastYear.text;
    }
    education.degree        = _lblDegree.text;
    
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        savingError(@"failed");
        //self.activityIndicator.hidden = YES;
        //[self.activityIndicator stopAnimating];
    }
    NSManagedObjectContext *managedObjectContext = [sharedDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"UserEducation"];
    self.savedEducation = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    success(@"userSaved");
}

-(void)updateEducationInfoWithSuccess:(EducationSavedSuccessfully)success failure:(EducationSavedFailed)failed
{
    
    NSManagedObject *newEducationInfo= [self.savedEducation objectAtIndex:self.selectedEducationIndex];
    
   
    
    if (![currentUserEducation.degree isEqualToString:_lblDegree.text]
        ||![currentUserEducation.schoolName isEqualToString:_txtSchoolName.text]
        ||![currentUserEducation.majorDegree isEqualToString:_txtMajorName.text]
        ||![currentUserEducation.location isEqualToString:_txtLocation.text]
        ||![currentUserEducation.firstMonth isEqualToString:_lblFirstMonth.text]
        ||![currentUserEducation.firstYear isEqualToString:_lblFirstYear.text]
        ||![currentUserEducation.lastMonth isEqualToString:_lblLastMonth.text]
        ||![currentUserEducation.lastYear isEqualToString:_lblLastYear.text]) {
        
        
        if (self.lblDegree.text.length != 0) {
            
            [newEducationInfo setValue:self.lblDegree.text forKey:@"degree"];
        }if (self.txtSchoolName.text.length != 0) {
            
            [newEducationInfo setValue:self.txtSchoolName.text forKey:@"schoolName"];
        }if (self.txtMajorName.text.length != 0) {
            
            [newEducationInfo setValue:self.txtMajorName.text forKey:@"majorDegree"];
        }if (self.txtLocation.text.length != 0) {
            
            [newEducationInfo setValue:self.txtLocation.text forKey:@"location"];
        }if (self.lblFirstMonth.text.length != 0) {
            
            [newEducationInfo setValue:self.lblFirstMonth.text forKey:@"firstMonth"];
        }if (_lblFirstYear.text.length != 0) {
            [newEducationInfo setValue:_lblFirstYear.text forKey:@"firstYear"];
        }if (_lblLastMonth.text.length != 0) {
            [newEducationInfo setValue:_lblLastMonth.text forKey:@"lastMonth"];
        }if (_lblLastYear.text.length != 0) {
            [newEducationInfo setValue:_lblLastYear.text forKey:@"lastYear"];
        }
    }
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        failed(@"NO");
    }
    success(@"YES");
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
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             
                             if (self.view.frame.size.height > 500 && self.view.frame.size.height < 1000) {
                                 [_scrollView setContentOffset:CGPointMake(0,textField.center.y - (self.view.frame.size.height / 2) + 20) animated:YES];
                                 
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
        if (nextTag == 1004) {
            [textField resignFirstResponder];
        }else{
            [nextResponder becomeFirstResponder];
        }
        
    } else {
        // Not found, so remove keyboard.
        CGFloat differenceHeights =self.scrollView.contentSize.height - self.view.frame.size.height - self.btnSave.frame.size.height;
        
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
        CGFloat differenceHeights =self.scrollView.contentSize.height - self.view.frame.size.height - self.btnSave.frame.size.height;
        
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
