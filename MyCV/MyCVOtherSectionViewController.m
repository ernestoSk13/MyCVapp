//
//  MyCVOtherSectionViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 27/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVOtherSectionViewController.h"
#import "MyCVOtherSectionDetailsViewController.h"

@interface MyCVOtherSectionViewController ()
@property (strong, nonatomic)NSMutableArray *savedSectionInfo;
@end

@implementation MyCVOtherSectionViewController

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
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchedSectionsArray = [appDelegate getUserCustomSections];
    self.savedSectionInfo = [[NSMutableArray alloc]init];
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
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchSectionRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserAdditionalSection"];
    self.savedSectionInfo = [[managedObjectContext executeFetchRequest:fetchSectionRequest error:nil] mutableCopy];
    
    if ([self.savedSectionInfo count]>0) {
        self.hasDataStored = YES;
    }
    [self.tblSectionList reloadData];
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
        [self.tblSectionList setEditing:YES];
        [self.btnCancel setEnabled:YES];
        [self.btnEdit setTitle:@"Done"];
    }else{
        [self.tblSectionList setEditing:NO];
        [self.btnCancel setEnabled:NO];
        [self.btnEdit setTitle:@"Edit"];
    }
}

-(void)cancelEditing
{
    [self.tblSectionList setEditing:NO];
    [self.btnCancel setEnabled:NO];
    [self.btnEdit setTitle:@"Edit"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Table View Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hasDataStored) {
        return [self.savedSectionInfo count];
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tblSectionList.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    if ([self.savedSectionInfo count] > 0) {
        self.hasDataStored = YES;
        self.btnEdit.enabled = YES;
    }else{
        //self.editEducationButton.enabled = NO;
        self.hasDataStored = NO;
    }
    
    if (self.hasDataStored) {
        if (indexPath.row == self.savedSectionInfo.count) {
            CellIdentifier = @"addSectionCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            // UILabel *lblAddCell = (UILabel *)[cell viewWithTag:1001];
            // UIButton *btnAddCell = (UIButton *)[cell viewWithTag:1002];
        }else{
            CellIdentifier = @"sectionListCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            UILabel *lblSectionName = (UILabel *)[cell viewWithTag:1001];
            
            UserAdditionalSection *currentSection = [self.savedSectionInfo objectAtIndex:indexPath.row];
            
            [lblSectionName setText:currentSection.sectionName];
        }
    }else{
        CellIdentifier = @"addSectionCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.savedSectionInfo.count) {
        return 90.0f;
    }
    return 80.0f;
}


#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.savedSectionInfo.count > 0) {
        goesEdit = YES;
        sectionIndex = indexPath.row;
        [self performSegueWithIdentifier:@"reviewSectionSegue" sender:self];
    }
}

- (void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete object from database
        [self.managedObjectContext deleteObject:[self.savedSectionInfo objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove goal from table view
        [self.savedSectionInfo removeObjectAtIndex:indexPath.row];
        [self.tblSectionList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.tblSectionList.editing = NO;
        [self.btnEdit setTitle:@"Edit"];
        [self.tblSectionList reloadData];
    }
    
}

#pragma mark - Navigation

-(void)validateData
{
    if (self.comesFromConfirmPage) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
      [self performSegueWithIdentifier:@"confirmationSegue" sender:self];
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"reviewSectionSegue"]) {
        MyCVOtherSectionDetailsViewController *detailsVC = (MyCVOtherSectionDetailsViewController *)segue.destinationViewController;
        detailsVC.hasDataStored = YES;
        detailsVC.selectedSectionIndex = sectionIndex;
    }
}

@end
