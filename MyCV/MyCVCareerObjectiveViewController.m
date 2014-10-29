//
//  MyCVCareerObjectiveViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 26/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVCareerObjectiveViewController.h"

@interface MyCVCareerObjectiveViewController ()
@property (nonatomic, strong)NSMutableArray *savedObjectiveArray;
@end

@implementation MyCVCareerObjectiveViewController

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
    self.savedObjectiveArray = [[NSMutableArray alloc]init];
    appDelegate = (MyCVAppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchedObjectiveArray = [appDelegate getUserCareerObjective];
    self.savedObjectiveArray = [[NSMutableArray alloc]init];
    [self loadUI];
    if (self.comesFromConfirmPage) {
        [self.btnContinue setTitle:@"Confirm" forState:UIControlStateNormal];
    }
    
}

-(void)loadUI
{
    [self.txtCareerObjective setDelegate:self];
    [self.btnContinue addTarget:self action:@selector(validateData) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserCareerObjective"];
    self.savedObjectiveArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    if ([self.savedObjectiveArray count] > 0) {
         currentObjective = [self.savedObjectiveArray objectAtIndex:0];
        [_txtCareerObjective setText:currentObjective.careerObjective];
    }
   
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

-(void) saveObjectiveWithSuccess: (ObjectiveSavedSuccessfully) success onError: (ObjectivSavedFailed) failure
{
    NSManagedObjectContext *context = [self managedObjectContext];
    UserCareerObjective *objective = [NSEntityDescription insertNewObjectForEntityForName:@"UserCareerObjective" inManagedObjectContext:context];
    objective.careerObjective = self.txtCareerObjective.text;
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        failure(@"failed");
    }
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"UserCareerObjective"];
    self.savedObjectiveArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil]mutableCopy];
    success(@"objectiveSaved");
}

-(void) updateObjectiveWithSuccess: (ObjectiveSavedSuccessfully)success onError: (ObjectivSavedFailed) failure
{
    NSManagedObject *newObjective = [self.savedObjectiveArray objectAtIndex:0];
    if (![currentObjective.careerObjective isEqualToString:_txtCareerObjective.text]) {
        if (_txtCareerObjective.text.length != 0) {
            [newObjective setValue:self.txtCareerObjective.text forKeyPath:@"careerObjective"];
        }
    }
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        failure(@"NO");
    }
    success(@"YES");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,_btnContinue.frame.origin.y + _btnContinue.frame.size.height + 20);
}


#pragma mark - Text View Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTextView)];
    gestureRecognizer.delegate = self;
    [self.scrollView addGestureRecognizer:gestureRecognizer];
}

- (void)hideTextView {
    
    if ([self.txtCareerObjective isFirstResponder]) {
        [self.txtCareerObjective resignFirstResponder];
    }
}

#pragma mark - Navigation

-(void)validateData
{
    if (currentObjective) {
        [self updateObjectiveWithSuccess:^(NSString *success) {
            if (self.comesFromConfirmPage) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
            [self performSegueWithIdentifier:@"workHistorySegue" sender:self];
            }
        } onError:^(NSString *failed) {
            
        }];
    }else{
        [self saveObjectiveWithSuccess:^(NSString *success) {
            if (self.comesFromConfirmPage) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
             [self performSegueWithIdentifier:@"workHistorySegue" sender:self];
            }
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


@end
