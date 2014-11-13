//
//  MyCVWorkingHistoryViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 26/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVWorkingHistoryViewController.h"
#import "MyCVPickerViewController.h"
#import "MyCVWorkingHistoryDetailsViewController.h"

@interface MyCVWorkingHistoryViewController ()
@property (strong, nonatomic)NSMutableArray *savedWorkInfo;
@end

@implementation MyCVWorkingHistoryViewController

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
    self.managedObjectContext = [sharedDataHelper managedObjectContext];
    self.fetchedWorkArray = [sharedDataHelper getInfoForItem:@"UserWorkingHistory"];
    self.savedWorkInfo = [[NSMutableArray alloc]init];
    [_btnContinue addTarget:self action:@selector(validateData) forControlEvents:UIControlEventTouchUpInside];
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
    NSFetchRequest *fetchWorkRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserWorkingHistory"];
    self.savedWorkInfo = [[managedObjectContext executeFetchRequest:fetchWorkRequest error:nil] mutableCopy];
    
    if ([self.savedWorkInfo count]>0) {
        self.hasDataStored = YES;
    }else{
        [self.btnEdit setEnabled:NO];
    }
    [self.tblWorkingHistory reloadData];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width,_btnContinue.frame.origin.y + _btnContinue.frame.size.height + 20);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editTableContent
{
    if ([_btnEdit.title isEqualToString:@"Edit"]) {
        [self.tblWorkingHistory setEditing:YES];
        [self.btnCancel setEnabled:YES];
        [self.btnEdit setTitle:@"Done"];
    }else{
        [self.tblWorkingHistory setEditing:NO];
        [self.btnCancel setEnabled:NO];
        [self.btnEdit setTitle:@"Edit"];
    }
}

-(void)cancelEditing
{
    [self.tblWorkingHistory setEditing:NO];
    [self.btnCancel setEnabled:NO];
    [self.btnEdit setTitle:@"Edit"];
}

#pragma mark Core Data Methods
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = sharedDataHelper;
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


#pragma mark - Table View Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hasDataStored) {
        return [self.savedWorkInfo count];
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tblWorkingHistory.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    if ([self.savedWorkInfo count] > 0) {
        self.hasDataStored = YES;
        self.btnEdit.enabled = YES;
    }else{
        //self.editEducationButton.enabled = NO;
        self.hasDataStored = NO;
    }
    
    if (self.hasDataStored) {
        if (indexPath.row == self.savedWorkInfo.count) {
            CellIdentifier = @"addWorkCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
           // UILabel *lblAddCell = (UILabel *)[cell viewWithTag:1001];
           // UIButton *btnAddCell = (UIButton *)[cell viewWithTag:1002];
        }else{
            CellIdentifier = @"workListCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            UILabel *lblStartingDate = (UILabel *)[cell viewWithTag:1001];
            UILabel *lblFinalDate = (UILabel *)[cell viewWithTag:1002];
            UILabel *lblPosition = (UILabel *)[cell viewWithTag:2001];
            UILabel *lblCompany = (UILabel *)[cell viewWithTag:3001];
            UILabel *lblLocation = (UILabel *)[cell viewWithTag:4001];
            
            UserWorkingHistory *work = [self.savedWorkInfo objectAtIndex:indexPath.row];
            
            [lblStartingDate setText:[NSString stringWithFormat:@"%@-%@", work.firstMonth, work.firstYear]];
            if ([work.lastMonth isEqualToString:@"Present"]) {
                 [lblFinalDate setText:[NSString stringWithFormat:@"%@", work.lastMonth]];
            }else{
                 [lblFinalDate setText:[NSString stringWithFormat:@"%@-%@", work.lastMonth, work.lastYear]];
            }
           
            [lblPosition setText:work.jobTitle];
            [lblCompany setText:work.company];
            [lblLocation setText:work.location];
        }
    }else{
        CellIdentifier = @"addWorkCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.savedWorkInfo.count) {
        return 74.0f;
    }
    return 160.0f;
}


#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tblWorkingHistory cellForRowAtIndexPath:indexPath];
    if (![cell.textLabel.text isEqualToString:@"No Education added yet"]) {
        goesToEdit = YES;
        workIndex = indexPath.row;
        [self performSegueWithIdentifier:@"selectedJobSegue" sender:self];
    }
}

- (void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete object from database
        [self.managedObjectContext deleteObject:[self.savedWorkInfo objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove goal from table view
        [self.savedWorkInfo removeObjectAtIndex:indexPath.row];
        [self.tblWorkingHistory deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.tblWorkingHistory.editing = NO;
        [self.btnEdit setTitle:@"Edit"];
        [self.tblWorkingHistory reloadData];
    }
    
}


#pragma mark - Navigation

-(void)validateData
{
    if (self.comesFromConfirmPage) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    [self performSegueWithIdentifier:@"skillSegue" sender:self];
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectedJobSegue"]) {
        MyCVWorkingHistoryDetailsViewController *detailsVC = (MyCVWorkingHistoryDetailsViewController *)segue.destinationViewController;
        detailsVC.hasDataStored = YES;
        detailsVC.selectedWorkIndex = workIndex;
    }
}


@end
