//
//  MyCVOtherSectionDetailsViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 27/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVOtherSectionDetailsViewController.h"
#import "UserAdditionalSection.h"
@interface MyCVOtherSectionDetailsViewController ()
@property (strong, nonatomic)NSMutableArray *savedSection;
@end

@implementation MyCVOtherSectionDetailsViewController

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
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchedSectionsArray = [appDelegate getUserCustomSections];
    self.savedSection = [[NSMutableArray alloc]init];
    _txtSectionDescription.delegate = self;
    _txtSectionName.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    NSFetchRequest *fetchSectionRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserAdditionalSection"];
    self.savedSection = [[managedObjectContext executeFetchRequest:fetchSectionRequest error:nil] mutableCopy];
    
    if (self.hasDataStored) {
        currentSection = [self.savedSection objectAtIndex:self.selectedSectionIndex];
        [_txtSectionName setText:currentSection.sectionName];
        [_txtSectionDescription setText:currentSection.sectionDescription];
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

}

#pragma mark - Core Data Methods

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)saveSectionWithSuccess: (SectionSavedSuccessfully) success onError:(SectionSavedFailed) savingError
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    UserAdditionalSection *section = [NSEntityDescription insertNewObjectForEntityForName:@"UserAdditionalSection" inManagedObjectContext:context];
    section.sectionName        = _txtSectionName.text;
    section.sectionDescription = _txtSectionDescription.text;
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        savingError(@"failed");
        //self.activityIndicator.hidden = YES;
        //[self.activityIndicator stopAnimating];
    }
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"UserAdditionalSection"];
    self.savedSection = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    success(@"userSaved");
}

-(void)updateSectionWithSuccess: (SectionSavedSuccessfully)success onError:(SectionSavedFailed) savingError
{
    NSManagedObjectContext *newSection = [self.savedSection objectAtIndex:self.selectedSectionIndex];
    if (![currentSection.sectionName isEqualToString:_txtSectionName.text]
        || ![currentSection.sectionDescription isEqualToString:_txtSectionDescription.text]) {
        if (self.txtSectionName.text.length != 0) {
            [newSection setValue:_txtSectionName.text forKeyPath:@"sectionName"];
        }
        if (self.txtSectionDescription.text.length != 0) {
            [newSection setValue:_txtSectionDescription.text forKeyPath:@"sectionDescription"];
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
    
    if ([self.txtSectionDescription isFirstResponder]) {
        [self.txtSectionDescription resignFirstResponder];
    }
}

#pragma mark - Navigation

-(void)validateData
{
    if (currentSection) {
        [self updateSectionWithSuccess:^(NSString *success) {
            [self cancelAndDismiss];
        } onError:^(NSString *failed) {
            
        }];
    }else{
        [self saveSectionWithSuccess:^(NSString *success) {
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
