//
//  MyCVSkillDetailsViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 27/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVSkillDetailsViewController.h"
#import "UserSkills.h"

@interface MyCVSkillDetailsViewController ()
@property (strong, nonatomic)NSMutableArray *savedSkill;
@property(strong, nonatomic)MyCVPickerViewController *yearPicker;
@end

@implementation MyCVSkillDetailsViewController

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
    appDelegate = (MyCVAppDelegate*)[[UIApplication sharedApplication] delegate];
    [self.view setBackgroundColor:[UIColor whiteColor]];
     [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipadBg"]]];
    self.managedObjectContext = [sharedDataHelper managedObjectContext];
    self.fetchedSkillArray = [sharedDataHelper getInfoForItem:@"UserSkills"];
    self.savedSkill = [[NSMutableArray alloc]init];
    yearsArray = @[@"1-2 years", @"3-5 years", @"6-10 years", @"10+ years"];
    _txtSkillName.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSManagedObjectContext *managedObjectContext = [sharedDataHelper managedObjectContext];
    
    NSFetchRequest *fetchSkillRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserSkills"];
    self.savedSkill = [[managedObjectContext executeFetchRequest:fetchSkillRequest error:nil] mutableCopy];
    
    if (self.hasDataStored) {
        currentSkill = [self.savedSkill objectAtIndex:self.selectedSkillIndex];
        [_txtSkillName setText:currentSkill.skillName];
        [_lblExperienceYears setText:currentSkill.skillExperience];
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignTextfield)];
    tap.numberOfTapsRequired = 1;
    self.scrollView.userInteractionEnabled  = YES;
    [_scrollView addGestureRecognizer:tap];
    [_btnCancel setTarget:self];
    [_btnCancel setAction:@selector(cancelAndDismiss)];
    [_btnSave addTarget:self action:@selector(validateData) forControlEvents:UIControlEventTouchUpInside];
    [_btnExperience addTarget:self action:@selector(showYearsPicker:) forControlEvents:UIControlEventTouchUpInside];

}



#pragma mark - Picker Methods

-(void)showYearsPicker:(UIButton *)sender
{
    self.btnSave.enabled = YES;
    self.yearPicker= [[MyCVPickerViewController alloc]initWithDelegate:self];
    self.yearPicker.view.backgroundColor = [UIColor whiteColor];
    self.yearPicker.pickerHeight = 250;
    [self.yearPicker.toolbarLabel setText:@"Select years"];
    self.yearPicker.pickerItems = [[NSArray alloc]initWithArray:yearsArray];
    [self.yearPicker showInViewController:self];
}
-(void)pickerWasCancelled:(MyCVPickerViewController *)picker
{
    
}

-(void)picker:(MyCVPickerViewController *)picker pickedValueAtIndex:(NSInteger)index
{
    [_lblExperienceYears setText:[picker.pickerItems objectAtIndex:index]];
    [_lblExperienceYears setTextColor:[UIColor blackColor]];
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

-(void)saveSkillWithSuccess: (SkillSavedSuccessfully)success onError:(SkillSavedFailed) savingError
{
    NSManagedObjectContext *context = [sharedDataHelper managedObjectContext];
    UserSkills *skill = [NSEntityDescription insertNewObjectForEntityForName:@"UserSkills" inManagedObjectContext:context];
    skill.skillName       = _txtSkillName.text;
    skill.skillExperience = _lblExperienceYears.text;
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        savingError(@"failed");
        //self.activityIndicator.hidden = YES;
        //[self.activityIndicator stopAnimating];
    }
    NSManagedObjectContext *managedObjectContext = [sharedDataHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"UserSkills"];
    self.savedSkill = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    success(@"userSaved");
}

-(void)updateSkillWithSuccess: (SkillSavedSuccessfully)success onError:(SkillSavedFailed)savingError
{
    NSManagedObjectContext *newSkill = [self.savedSkill objectAtIndex:self.selectedSkillIndex];
    if (![currentSkill.skillName isEqualToString:_txtSkillName.text]
        || ![currentSkill.skillExperience isEqualToString:_lblExperienceYears.text]) {
        if (self.txtSkillName.text.length != 0) {
            [newSkill setValue:_txtSkillName.text forKeyPath:@"skillName"];
        }
        if (self.lblExperienceYears.text.length != 0) {
            [newSkill setValue:_lblExperienceYears.text forKeyPath:@"skillExperience"];
        }
    }
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        savingError(@"NO");
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
                                 [_scrollView setContentOffset:CGPointMake(0,textField.center.y -500) animated:YES];
                             }else{
                                 [_scrollView setContentOffset:CGPointMake(0,textField.center.y -200) animated:YES];
                                 
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
        [textField resignFirstResponder];
        
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
#pragma mark - Navigation

-(void)validateData
{
    if (currentSkill) {
        [self updateSkillWithSuccess:^(NSString *success) {
            [self cancelAndDismiss];
        } onError:^(NSString *failed) {
            
        }];
    }else{
        [self saveSkillWithSuccess:^(NSString *success) {
            [self cancelAndDismiss];
        } onError:^(NSString *failed) {
            
        }];
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
