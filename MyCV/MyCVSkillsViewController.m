//
//  MyCVSkillsViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 27/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVSkillsViewController.h"
#import "MyCVSkillDetailsViewController.h"

@interface MyCVSkillsViewController ()
@property (strong, nonatomic)NSMutableArray *savedSkillsInfo;
@end

@implementation MyCVSkillsViewController

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
    self.fetchedSkillsArray = [sharedDataHelper getInfoForItem:@"UserSkills"];
    self.savedSkillsInfo = [[NSMutableArray alloc]init];
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
    NSFetchRequest *fetchSkillRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserSkills"];
    self.savedSkillsInfo = [[managedObjectContext executeFetchRequest:fetchSkillRequest error:nil] mutableCopy];
    
    if ([self.savedSkillsInfo count]>0) {
        self.hasDataStored = YES;
    }else{
        [self.btnEdit setEnabled:NO];
    }
    [self.tblSkills reloadData];
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
        [self.tblSkills setEditing:YES];
        [self.btnCancel setEnabled:YES];
        [self.btnEdit setTitle:@"Done"];
    }else{
        [self.tblSkills setEditing:NO];
        [self.btnCancel setEnabled:NO];
        [self.btnEdit setTitle:@"Edit"];
    }
}

-(void)cancelEditing
{
    [self.tblSkills setEditing:NO];
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
        return [self.savedSkillsInfo count];
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tblSkills.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    if ([self.savedSkillsInfo count] > 0) {
        self.hasDataStored = YES;
        self.btnEdit.enabled = YES;
    }else{
        //self.editEducationButton.enabled = NO;
        self.hasDataStored = NO;
    }
    
    if (self.hasDataStored) {
        if (indexPath.row == self.savedSkillsInfo.count) {
            CellIdentifier = @"addSkillCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            // UILabel *lblAddCell = (UILabel *)[cell viewWithTag:1001];
            // UIButton *btnAddCell = (UIButton *)[cell viewWithTag:1002];
        }else{
            CellIdentifier = @"skillListCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
           
            UILabel *lblSkill = (UILabel *)[cell viewWithTag:1001];
            UILabel *lblYears = (UILabel *)[cell viewWithTag:2001];
            
            UserSkills *skill = [self.savedSkillsInfo objectAtIndex:indexPath.row];
           
            [lblSkill setText:skill.skillName];
            [lblYears setText:skill.skillExperience];
        }
    }else{
        CellIdentifier = @"addSkillCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.savedSkillsInfo.count) {
        return 75.0f;
    }
    return 80.0f;
}


#pragma mark TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tblSkills cellForRowAtIndexPath:indexPath];
    if (![cell.textLabel.text isEqualToString:@"No Education added yet"]) {
        goesToEdit = YES;
        skillIndex = indexPath.row;
        [self performSegueWithIdentifier:@"reviewSkillSegue" sender:self];
    }
}

- (void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete object from database
        [self.managedObjectContext deleteObject:[self.savedSkillsInfo objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove goal from table view
        [self.savedSkillsInfo removeObjectAtIndex:indexPath.row];
        [self.tblSkills deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.tblSkills.editing = NO;
        [self.btnEdit setTitle:@"Edit"];
        [self.tblSkills reloadData];
    }
    
}



#pragma mark - Navigation

-(void)validateData
{
    if (self.comesFromConfirmPage) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    [self performSegueWithIdentifier:@"otherSegue" sender:self];
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"reviewSkillSegue"]) {
        MyCVSkillDetailsViewController *detailsVC = (MyCVSkillDetailsViewController *)segue.destinationViewController;
        detailsVC.hasDataStored = YES;
        detailsVC.selectedSkillIndex = skillIndex;
    }
}


@end
