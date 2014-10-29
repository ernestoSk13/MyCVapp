//
//  MyCVHomeControllerViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 06/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVHomeControllerViewController.h"
#import "MenuController.h"
#import "MyCVLandingViewController.h"
#import "MyCVUtilities.h"
#import "UIImage+customProperties.h"
#import "UserInfo.h"
#import "MyCVBasicInfoViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"
#import "MyCVSections.h"

@interface MyCVHomeControllerViewController ()
@property (nonatomic, strong)NSMutableArray *menuItems;
@property (strong) NSMutableArray *savedUser;
@end

@implementation MyCVHomeControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initialSetup
{
    [[MyCVUtilities sharedInstance]setHomeVCObject:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showLoadingIndicator];
    if (IPAD) {
        [self setUpForIpad];
    }
    
    
    
    [_viewTransparency setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipadBg"]]];
    self.managedObjectContext = appDelegate.managedObjectContext;
    self.fetchedUserArray = [appDelegate getUserInfo];    
     self.menuItems = [[NSMutableArray alloc]initWithArray:@[@"Start new resumé"]];
    [self.profilePicture.layer setCornerRadius:self.profilePicture.frame.size.height / 2];
    [self.profilePicture.layer setMasksToBounds:YES];
    [self initialSetup];
    
    
    [_btnReset addTarget:self action:@selector(resetOption) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setUpForIpad
{
    _dictSections = @{@"Basic Info"       : @"basicInfo",
                      @"Education"        : @"Education",
                      @"Career Objective" : @"career",
                      @"Working History"  : @"work",
                      @"Skills"           : @"skills",
                      @"Other Sections"   : @"other"
                      };
    
    _arraySections = @[@"Basic Info",
                       @"Education",
                       @"Career Objective",
                       @"Working History",
                       @"Skills" ,
                       @"Other Sections"];
    
    _collectionSections.delegate = self;

    
    _tutorialView = [[UIView alloc]initWithFrame:self.view.frame];
    
    [_tutorialView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
    UILabel *instructionLabel = [[UILabel alloc]initWithFrame:CGRectMake(_tutorialView.center.x - 250, _tutorialView.center.y + 150, 500, 100)];
    [_tutorialView setNeedsLayout];
    
    instructionLabel.numberOfLines = 0;
    [instructionLabel setText:@"You can go directly to a section by tapping \nthe icons below"];
    [instructionLabel setFont:[UIFont systemFontOfSize:25]];
    [instructionLabel setTextColor:[UIColor whiteColor]];
    [instructionLabel setTextAlignment:NSTextAlignmentCenter];
    [_tutorialView addSubview:instructionLabel];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTutorial)];
    tap.numberOfTapsRequired = 1;
    [_tutorialView setUserInteractionEnabled:YES];
    [_tutorialView addGestureRecognizer:tap];
    [self.view addSubview:_tutorialView];
}

-(void)removeTutorial{
    [_tutorialView removeFromSuperview];
    _tutorialView = nil;
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _scrollView.scrollEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width, _bannerView.frame.origin.y + _bannerView.frame.size.height);
    if (self.view.frame.size.height > 500) {
        _scrollView.scrollEnabled = NO;
    }

}

-(void)viewDidAppear:(BOOL)animated
{
#if TARGET_IPHONE_SIMULATOR
    // where are you?
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#endif
    [super viewWillAppear:animated];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
    self.savedUser = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        storyboard =[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }else{
        
    }
        
        
    
    if (![self.savedUser count]) {
        MyCVLandingViewController *landingViewController = (MyCVLandingViewController*)[storyboard instantiateViewControllerWithIdentifier:@"landingVC"];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            self.modalPresentationStyle = UIModalPresentationFormSheet;
            landingViewController.view.frame = CGRectMake(((self.view.frame.size.width / 2) - 300), 100, 600, 600);
        }else{
            
        }
        
        [self presentViewController:landingViewController animated:YES completion:nil];
    }else{
        selectedUser = [self.savedUser objectAtIndex:0];
        NSData *imageData = [[NSData alloc]initWithContentsOfFile:selectedUser.profilePicUrl];
        UIImage *userProfileImage = [[UIImage alloc]initWithData:imageData];
        if (!userProfileImage) {
            userProfileImage = [UIImage imageNamed:@"ProfileThumbnail"];
        }
        [self setLandingInformationWithName:[NSString stringWithFormat:@"%@ %@", selectedUser.firstName, selectedUser.lastName] degree:selectedUser.degree andImage:userProfileImage];
         self.menuController = [MenuController sharedMenu];
        self.menuController.profileImage = userProfileImage;
        self.menuController.firstName = selectedUser.firstName;
        self.menuController.lastName = selectedUser.lastName;
        self.menuController.degree = selectedUser.degree;
        if (selectedUser.mobile.length > 0 || selectedUser.email.length > 0) {
            hasStartedWithResume = YES;
            [self.menuItems addObject:@"Preview Started Resumé"];
            [self.homeTableView reloadData];
        }
        [_btnStartResume addTarget:self action:@selector(startNewResume) forControlEvents:UIControlEventTouchUpInside];
        [_btnReviewResume addTarget:self action:@selector(continuePreviousResume) forControlEvents:UIControlEventTouchUpInside];
        if (hasStartedWithResume) {
            [_btnReviewResume setHidden:NO];
            [_btnReset setHidden:NO];
        }else{
            [_btnReviewResume setHidden:YES];
            [_btnReset setHidden:YES];
        }
        
        
        [self.menuController reloadMenuAfterRegister];
        [self hideLoadingIndicator];
    }
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




-(void)setLandingInformationWithName:(NSString *)name degree:(NSString *)degree andImage:(UIImage *)image
{
    self.profilePicture.image = image;
    UIImageView *newBlurredImage = [[UIImageView alloc]initWithFrame:self.viewBlurredImage.frame];
    newBlurredImage.image = image;
    newBlurredImage = [UIImage captureBlur:newBlurredImage];
    self.blurredImageView.image = newBlurredImage.image;
    self.blurredImageView.contentMode = UIViewContentModeScaleToFill;
    [self.lblCompleteName setText:name];
    [self.lblDegree setText:degree];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)startNewResume
{
    [self performSegueWithIdentifier:@"basicInfoSegue" sender:self];
}

-(void)continuePreviousResume
{
    [self performSegueWithIdentifier:@"previewCompletionSegue" sender:self];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier;
    UITableViewCell *cell;
    
    CellIdentifier = @"MenuCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    
    
    // Configure the cell...
    //cell.backgroundColor = [UIColor darkGrayColor];
    UILabel *menuItemLabel = (UILabel *)[cell viewWithTag:1001];
    [menuItemLabel setText:self.menuItems[indexPath.row]];
    [menuItemLabel sizeToFit];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        //Start a new CV
        case 0:
        {
            [self performSegueWithIdentifier:@"basicInfoSegue" sender:self];
        }
            break;
        case 1:
        {
            [self performSegueWithIdentifier:@"previewCompletionSegue" sender:self];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)openMenu:(id)sender
{
    MenuController *sharedMenu = [MenuController sharedMenu];
    if (sharedMenu.isMenuOpened) {
        [sharedMenu closeMenuAnimated];
    }else{
        [sharedMenu openMenuAnimated];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"basicInfoSegue"]) {
        landingVC = [segue destinationViewController];
        [landingVC setFirstName:selectedUser.firstName];
        [landingVC setLastName:selectedUser.lastName];
        NSData *profileImageData = [[NSData alloc]initWithContentsOfFile:selectedUser.profilePicUrl];
        UIImage *selectedProfileImage = [UIImage imageWithData:profileImageData];
        [landingVC setProfileImage:selectedProfileImage];
        
    }else if([segue.identifier isEqualToString:@"previewCompletionSegue"]){
        
    }
}

-(void)resetOption
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Are you sure you want to reset your data?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete data" otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"Reset");
        [self resetDatabase];
    }
}

-(void)resetDatabase
{
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    [self resetCoreDataWithSuccess:^(BOOL success) {
        if (success) {
            MyCVLandingViewController *landingViewController = (MyCVLandingViewController*)[storyboard instantiateViewControllerWithIdentifier:@"landingVC"];
            [self presentViewController:landingViewController animated:YES completion:nil];

        }
    }];
}

-(void)resetCoreDataWithSuccess: (DatabaseClearSuccess) success
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSArray *allEntities = @[@"UserInfo", @"UserEducation", @"UserWorkingHistory", @"UserCareerObjective", @"UserSkills", @"UserAdditionalSection"];
    for (NSString *entity in allEntities)
    {
        NSFetchRequest * allObjects = [[NSFetchRequest alloc] init];
        [allObjects setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:context]];
        [allObjects setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        NSError * error = nil;
        NSArray * objectsInside = [context executeFetchRequest:allObjects error:&error];
        //error handling goes here
        for (NSManagedObject * object in objectsInside) {
            [context deleteObject:object];
        }
        NSError *saveError = nil;
        [context save:&saveError];
        if (saveError) {
            success(NO);
        }

    }
    success(YES);
}


#pragma mark - Collection View Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_arraySections count]
    ;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    UICollectionViewCell *cell;
    cellIdentifier = @"sectionCell";
    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    }
  //  UIImageView *imgSection = (UIImageView *) [cell viewWithTag:1001];
    UIButton *btnSection = (UIButton *) [cell viewWithTag:1002];
    
    [btnSection.layer setBorderColor: [UIColor whiteColor].CGColor];
    [btnSection.layer setBorderWidth:1];
    [btnSection.layer setCornerRadius:10];
    [btnSection sizeToFit];
    
    [btnSection setTitle:[_arraySections objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    UICollectionViewCell *cell;
    cellIdentifier = @"sectionCell";
    if (cell == nil) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"basicInfoSegue" sender:self];
            break;
        default:
            break;
    }

}




@end
