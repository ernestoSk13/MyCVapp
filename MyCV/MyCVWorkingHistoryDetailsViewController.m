//
//  MyCVWorkingHistoryDetailsViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 27/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVWorkingHistoryDetailsViewController.h"
#import "UserWorkingHistory.h"

@interface MyCVWorkingHistoryDetailsViewController ()
@property (strong, nonatomic)NSMutableArray *savedWork;
@property (strong, nonatomic)NSMutableArray *savedUser;
@property(strong, nonatomic)MyCVPickerViewController *monthPicker;
@property(strong, nonatomic)MyCVPickerViewController *yearPicker;
@end

@implementation MyCVWorkingHistoryDetailsViewController

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
     [self loadUI];
    self.title = @"Job information";
    appDelegate = (MyCVAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipadBg"]]];
    self.managedObjectContext = [sharedDataHelper managedObjectContext];
    self.fetchedWorkArray = [sharedDataHelper getInfoForItem:@"UserWorkingHistory"];
    self.savedWork = [[NSMutableArray alloc]init];
   
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
    _txtJobDescription.delegate = self;
    
   
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSManagedObjectContext *managedObjectContext = [sharedDataHelper managedObjectContext];
    
    NSFetchRequest *fetchWorkRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserWorkingHistory"];
    self.savedWork = [[managedObjectContext executeFetchRequest:fetchWorkRequest error:nil] mutableCopy];
    NSFetchRequest *fetchUserRequest = [[NSFetchRequest alloc]initWithEntityName:@"UserInfo"];
    self.savedUser = [[managedObjectContext executeFetchRequest:fetchUserRequest error:nil]mutableCopy];
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
        currentUserWork = [self.savedWork objectAtIndex:self.selectedWorkIndex];
        [_txtCompany setText:currentUserWork.company];
        [_txtJobTitle setText:currentUserWork.jobTitle];
        [_txtLocation setText:currentUserWork.location];
        [_txtJobDescription  setText:currentUserWork.jobDescription];
        [_lblFirstMonth setText:currentUserWork.firstMonth];
        [_lblFirstYear setText:currentUserWork.firstYear];
        [_lblLastMonth setText:currentUserWork.lastMonth];
        if ([currentUserWork.lastMonth isEqualToString:@"Present"]) {
            [_btnLastYear setHidden:YES];
            [_lblLastYear setHidden:YES];
        }else{
            [_lblLastYear setText:currentUserWork.lastYear];
        }
    }
    
    
    
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,_btnSave.frame.origin.y + _btnSave.frame.size.height + 20);
}



-(void)loadUI
{
    [_btnCancel setTarget:self];
    [_btnCancel setAction:@selector(cancelAndDismiss)];
     [_btnSave addTarget:self action:@selector(validateData) forControlEvents:UIControlEventTouchUpInside];
    [_btnFirstMonth addTarget:self action:@selector(showMonthPicker:) forControlEvents:UIControlEventTouchUpInside];
    _btnFirstMonth.tag = 1001;
    [_btnFirstYear addTarget:self action:@selector(showYearPicker:) forControlEvents:UIControlEventTouchUpInside];
    _btnFirstYear.tag = 1002;
    [_btnLastMonth addTarget:self action:@selector(showMonthPicker:) forControlEvents:UIControlEventTouchUpInside];
    _btnLastMonth.tag = 2001;
    [_btnLastYear addTarget:self action:@selector(showYearPicker:) forControlEvents:UIControlEventTouchUpInside];
    _btnLastYear.tag = 2002;
    yearsArray = [[NSMutableArray alloc]init];
    _btnLastYear.enabled = NO;
    _btnLastMonth.enabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignTextfield)];
    tap.numberOfTapsRequired = 1;
    self.scrollView.userInteractionEnabled  = YES;
    [_scrollView addGestureRecognizer:tap];


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

#pragma mark - Picker Methods

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
    [self.yearPicker.toolbarLabel setText:@"Select year"];
    
    
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

#pragma mark - Core Data Methods

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = sharedDataHelper;
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)saveWorkingHistoryWithSuccess:(WorkingHistorySavedSuccessfully) success onError: (WorkingHistorySavedFailed) savingError
{
    NSManagedObjectContext *context = [sharedDataHelper managedObjectContext];
    UserWorkingHistory *work = [NSEntityDescription insertNewObjectForEntityForName:@"UserWorkingHistory" inManagedObjectContext:context];
    
    work.jobTitle       = _txtJobTitle.text;
    work.company        = _txtCompany.text;
    work.firstMonth     = _lblFirstMonth.text;
    work.lastMonth      = _lblLastMonth.text;
    work.firstYear      = _lblFirstYear.text;
    if ([_lblLastMonth.text isEqualToString:@"Present"]) {
        work.lastYear  = @"";
    }else{
        work.lastYear  = _lblLastYear.text;
    }

    work.location       = _txtLocation.text;
    work.jobDescription = _txtJobDescription.text;
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        savingError(@"failed");
        //self.activityIndicator.hidden = YES;
        //[self.activityIndicator stopAnimating];
    }
    NSManagedObjectContext *managedObjectContext = [sharedDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"UserWorkingHistory"];
    self.savedWork = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    success(@"userSaved");
}

-(void)updateWorkingHistoryWithSuccess: (WorkingHistorySavedSuccessfully)success onError:(WorkingHistorySavedFailed)savingError
{
    NSManagedObjectContext *newWorkingInfo = [self.savedWork objectAtIndex:self.selectedWorkIndex];
    if (![currentUserWork.company isEqualToString:_txtCompany.text]
        || ![currentUserWork.jobTitle isEqualToString:_txtJobTitle.text]
        || ![currentUserWork.location isEqualToString:_txtLocation.text]
        || ![currentUserWork.firstMonth isEqualToString:_lblFirstMonth.text]
        || ![currentUserWork.firstYear isEqualToString:_lblFirstYear.text]
        || ![currentUserWork.lastMonth isEqualToString:_lblLastMonth.text]
        || ![currentUserWork.lastYear isEqualToString:_lblLastYear.text]
        || ![currentUserWork.jobDescription isEqualToString:_lblLastYear.text]){
        if (self.txtCompany.text.length != 0) {
            [newWorkingInfo setValue:_txtCompany.text forKeyPath:@"company"];
        }
        if (self.txtJobTitle.text.length != 0) {
            [newWorkingInfo setValue:_txtJobTitle.text forKeyPath:@"jobTitle"];
        }
        if (self.txtLocation.text.length != 0) {
            [newWorkingInfo setValue:_txtLocation.text forKeyPath:@"location"];
        }
        if (self.txtJobDescription.text.length != 0) {
            [newWorkingInfo setValue:_txtJobDescription.text forKeyPath:@"jobDescription"];
        }
        if (self.lblFirstMonth.text.length != 0) {
            
            [newWorkingInfo setValue:self.lblFirstMonth.text forKey:@"firstMonth"];
        }if (_lblFirstYear.text.length != 0) {
            [newWorkingInfo setValue:_lblFirstYear.text forKey:@"firstYear"];
        }if (_lblLastMonth.text.length != 0) {
            [newWorkingInfo setValue:_lblLastMonth.text forKey:@"lastMonth"];
        }if (_lblLastYear.text.length != 0) {
            [newWorkingInfo setValue:_lblLastYear.text forKey:@"lastYear"];
        }
    }
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        savingError(@"NO");
    }
    success(@"YES");
}



#pragma mark - Navigation

-(void)validateData
{
    if (currentUserWork) {
        [self updateWorkingHistoryWithSuccess:^(NSString *success) {
            [self cancelAndDismiss];
        } onError:^(NSString *failed) {
            
        }];
    }else{
    [self saveWorkingHistoryWithSuccess:^(NSString *success) {
        [self cancelAndDismiss];
    } onError:^(NSString *failed) {
        
    }];
    }
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
                                 [_scrollView setContentOffset:CGPointMake(0,textField.center.y - (self.view.frame.size.height / 2)) animated:YES];
                                 
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
        if (nextTag == 104) {
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

#pragma mark - Text View Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTextView)];
    gestureRecognizer.delegate = self;
    [self.scrollView addGestureRecognizer:gestureRecognizer];
     if ((textView.frame.origin.y + textView.frame.size.height) >  (self.view.frame.size.height / 2)) {
         CGRect currentFrame = self.view.frame;
         currentFrame.origin.y = -40;
         
         // Animate the frame change.
         [UIView animateWithDuration:0.1
                               delay:0.0
                             options:UIViewAnimationOptionCurveEaseIn
                          animations:^{
                              
                              if (self.view.frame.size.height > 500 && self.view.frame.size.height < 1000) {
                                  [_scrollView setContentOffset:CGPointMake(0,_btnSave.center.y - (self.view.frame.size.height / 2) + 30) animated:YES];
                                  
                              } else if(self.view.frame.size.height > 1000){
                                  [_scrollView setContentOffset:CGPointMake(0,textView.center.y -500) animated:YES];
                              }else{
                                  [_scrollView setContentOffset:CGPointMake(0,textView.center.y -200) animated:YES];
                                  
                              }
                              
                              
                          }
                          completion:^(BOOL finished) {
                          }
          ];

     }

}

- (void)hideTextView {
    
    if ([self.txtJobDescription isFirstResponder]) {
        [self.txtJobDescription resignFirstResponder];
    }
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


-(void)cancelAndDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
