//
//  MyCVEducationMenuViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 24/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVEducationViewController.h"
#import "MyCVPickerViewController.h"
#import "MyCVEducationDetailsViewController.h"

@interface MyCVEducationViewController ()
@property (strong, nonatomic)NSMutableArray *savedEducation;
@property(strong, nonatomic)MyCVPickerViewController *highestDegreePicker;
@end

@implementation MyCVEducationViewController

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
    self.title = @"Education";
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
    self.managedObjectContext =  [sharedDataHelper managedObjectContext];
    self.fetchedEducationArray = [sharedDataHelper getInfoForItem:@"UserEducation"];
    self.savedEducation = [[NSMutableArray alloc]init];
    [_btnContinue addTarget:self action:@selector(validateData) forControlEvents:UIControlEventTouchUpInside];
    [_btnSelectDegree.layer setBorderColor:[UIColor blackColor].CGColor];
    [_btnSelectDegree.layer setBorderWidth:1];
    [_btnSelectDegree setBackgroundColor:[UIColor whiteColor]];
    [self.btnSelectDegree addTarget:self action:@selector(showHighestDegreePicker) forControlEvents:UIControlEventTouchUpInside];
    [self.btnEdit setTarget:self];
    [self.btnEdit setAction:@selector(editTableContent)];
    [self.btnCancel setEnabled:NO];
    [self.btnCancel setTarget:self];
    [self.btnCancel setAction:@selector(cancelEditing)];
    if (self.comesFromConfirmPage) {
        [self.btnContinue setTitle:@"Confirm" forState:UIControlStateNormal];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    NSManagedObjectContext *managedObjectContext = [sharedDataHelper managedObjectContext];
    highestDegree = [[NSUserDefaults standardUserDefaults]objectForKey:@"highestDegree"];
    if (highestDegree.length < 1) {
       _degreeLabel.text = @"Select a degree";
    }else{
        _degreeLabel.text = highestDegree;
    }
   
    NSFetchRequest *fetchEducationeRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserEducation"];
    self.savedEducation = [[managedObjectContext executeFetchRequest:fetchEducationeRequest error:nil] mutableCopy];
    
    if ([self.savedEducation count]>0) {
        self.hasDataStored = YES;
    }else{
        [self.btnEdit setEnabled:NO];
    }
    [self.educationTable reloadData];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,_btnContinue.frame.origin.y + _btnContinue.frame.size.height + 20);
}

-(void)editTableContent
{
    if ([_btnEdit.title isEqualToString:@"Edit"]) {
        [self.educationTable setEditing:YES];
        [self.btnCancel setEnabled:YES];
        [self.btnEdit setTitle:@"Done"];
    }else{
        [self.educationTable setEditing:NO];
        [self.btnCancel setEnabled:NO];
        [self.btnEdit setTitle:@"Edit"];
    }
}

-(void)cancelEditing
{
    [self.educationTable setEditing:NO];
    [self.btnCancel setEnabled:NO];
    [self.btnEdit setTitle:@"Edit"];
}

-(void)showHighestDegreePicker
{
    self.btnContinue.enabled = YES;
    self.highestDegreePicker= [[MyCVPickerViewController alloc]initWithDelegate:self];
    self.highestDegreePicker.view.backgroundColor = [UIColor whiteColor];
    self.highestDegreePicker.pickerHeight = 250;
    [self.highestDegreePicker.toolbarLabel setText:highestDegree];
    self.highestDegreePicker.pickerItems = [[NSArray alloc]initWithArray:degreesArray];
    [self.highestDegreePicker showInViewController:self.parentViewController.parentViewController];
    self.highestDegreePicker.view.tag = 1;
}

-(void)picker:(MyCVPickerViewController *)picker pickedValueAtIndex:(NSInteger)index
{
    [self.degreeLabel setText:[picker.pickerItems objectAtIndex:index]];
    [[NSUserDefaults standardUserDefaults]setObject:self.degreeLabel.text forKey:@"highestDegree"];
    highestDegree = [[NSUserDefaults standardUserDefaults]objectForKey:@"highestDegree"];
    
}

-(void)pickerWasCancelled:(MyCVPickerViewController *)picker
{
    
}

#pragma mark TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hasDataStored) {
        return [self.savedEducation count];
    }else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //self.educationTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    if ([self.savedEducation count] > 0) {
        self.hasDataStored = YES;
        self.btnEdit.enabled = YES;
    }else{
        //self.editEducationButton.enabled = NO;
        self.hasDataStored = NO;
    }
    
    if (self.hasDataStored) {
        if (indexPath.row == self.savedEducation.count) {
            CellIdentifier = @"addEducationCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
           // UILabel *lblAddCell = (UILabel *)[cell viewWithTag:1001];
           // UIButton *btnAddCell = (UIButton *)[cell viewWithTag:1002];
        }else{
            CellIdentifier = @"educationCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            UILabel *lblStartingDate = (UILabel *)[cell viewWithTag:1001];
            UILabel *lblFinalDate = (UILabel *)[cell viewWithTag:1002];
            UILabel *schoolLabel = (UILabel *)[cell viewWithTag:2001];
            UILabel *degreeLabel = (UILabel *)[cell viewWithTag:3001];
            UILabel *majorLabel = (UILabel *)[cell viewWithTag:4001];
            UILabel *locationLabel = (UILabel *)[cell viewWithTag:5001];
            UserEducation *education = [self.savedEducation objectAtIndex:indexPath.row];
            
            [lblStartingDate setText:[NSString stringWithFormat:@"%@-%@", education.firstMonth, education.firstYear]];
            if ([education.lastMonth isEqualToString:@"Present"]) {
                [lblFinalDate setText:[NSString stringWithFormat:@"%@", education.lastMonth]];
            }else{
                [lblFinalDate setText:[NSString stringWithFormat:@"%@-%@", education.lastMonth, education.lastYear]];
            }
            [degreeLabel setText:education.degree];
            [schoolLabel setText:education.schoolName];
            [majorLabel setText:education.majorDegree];
            [locationLabel setText:education.location];
        }
    }else{
        CellIdentifier = @"addEducationCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
      //  UILabel *lblAddCell = (UILabel *)[cell viewWithTag:1001];
      //  UIButton *btnAddCell = (UIButton *)[cell viewWithTag:1002];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.savedEducation.count) {
        return 80.0f;
    }
    return 150.0f;
}

-(void)addNewEducationInfo:(UIButton *)sender
{
    
}


#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.educationTable cellForRowAtIndexPath:indexPath];
    if (![cell.textLabel.text isEqualToString:@"No Education added yet"]) {
        goesToEdit = YES;
        educationIndex = indexPath.row;
        [self performSegueWithIdentifier:@"reviewEducationSegue" sender:self];
        
    }
}

 - (void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath {
 
 
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 
 // Delete object from database
 [self.managedObjectContext deleteObject:[self.savedEducation objectAtIndex:indexPath.row]];
 
 NSError *error = nil;
 if (![self.managedObjectContext save:&error]) {
 NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
 return;
 }
 
 // Remove goal from table view
 [self.savedEducation removeObjectAtIndex:indexPath.row];
 [self.educationTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 self.educationTable.editing = NO;
 [self.btnEdit setTitle:@"Edit"];
 [self.educationTable reloadData];
 }
 
 }




#pragma mark Core Data Methods
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate =sharedDataHelper;
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
-(void)validateData
{
    if (self.comesFromConfirmPage) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self performSegueWithIdentifier:@"careerObjectiveSegue" sender:self];
    }
    
}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 if ([segue.identifier isEqualToString:@"reviewEducationSegue"]) {
     MyCVEducationDetailsViewController *detailsVC = (MyCVEducationDetailsViewController *)segue.destinationViewController;
     detailsVC.hasDataStored = YES;
     detailsVC.selectedEducationIndex = educationIndex;
     
 }else{
     
 }
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
}

@end
