//
//  MyCVConfirmationViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 28/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVConfirmationViewController.h"
#import "MyCVBasicInfoViewController.h"
#import "MyCVEducationViewController.h"
#import "MyCVWorkingHistoryViewController.h"
#import "MyCVCareerObjectiveViewController.h"
#import "MyCVSkillsViewController.h"
#import "MyCVOtherSectionViewController.h"
#import "MyCVPDFDesignOptionsViewController.h"
#import "PDFHelper.h"

@interface MyCVConfirmationViewController ()
@property (nonatomic, strong)NSMutableArray *savedBasicInfo;
@property (nonatomic, strong)NSMutableArray *savedEducation;
@property (nonatomic, strong)NSMutableArray *savedWorkHistory;
@property (nonatomic, strong)NSMutableArray *savedCareerObjective;
@property (nonatomic, strong)NSMutableArray *savedSkills;
@property (nonatomic, strong)NSMutableArray *savedSections;

@end

@implementation MyCVConfirmationViewController

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
    self.fetchedInfoArray = [appDelegate getUserInfo];
    self.fetchedEducationArray = [appDelegate getUserEducation];
    self.fetchedObjectiveArray = [appDelegate getUserCareerObjective];
    self.fetchedWorksArray = [appDelegate getUserWorkingHistory];
    self.fetchedSkillsArray = [appDelegate getUserSkills];
    self.fetchedSectionsArray = [appDelegate getUserCustomSections];
    
    
    
    [_btnBasicInfo addTarget:self action:@selector(navigateToView:) forControlEvents:UIControlEventTouchUpInside];
    [_btnEducation addTarget:self action:@selector(navigateToView:) forControlEvents:UIControlEventTouchUpInside];
    [_btnCareerObjective addTarget:self action:@selector(navigateToView:) forControlEvents:UIControlEventTouchUpInside];
    [_btnWorkingHistory addTarget:self action:@selector(navigateToView:) forControlEvents:UIControlEventTouchUpInside];
    [_btnSkills addTarget:self action:@selector(navigateToView:) forControlEvents:UIControlEventTouchUpInside];
    [_btnOtherSections addTarget:self action:@selector(navigateToView:) forControlEvents:UIControlEventTouchUpInside];
    [_btnBuildResumé addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
}

-(void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd
{
    
}

-(void)navigateToView:(UIButton *)sender
{
    switch (sender.tag) {
        case 1000:
            [self performSegueWithIdentifier:@"confirmBasicInfoSegue" sender:self];
            break;
        case 2000:
            [self performSegueWithIdentifier:@"confirmEducationSegue" sender:self];
            break;
        case 3000:
            [self performSegueWithIdentifier:@"confirmObjectiveSegue" sender:self];
            break;
        case 4000:
            [self performSegueWithIdentifier:@"confirmWorkSegue" sender:self];
            break;
        case 5000:
            [self performSegueWithIdentifier:@"confirmSkillSegue" sender:self];
            break;
        case 6000:
            [self performSegueWithIdentifier:@"confirmOtherSegue" sender:self];
            break;
        default:
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
   
    [super viewWillAppear:animated];
    self.viewArray = [[NSMutableArray alloc]initWithObjects:
                      _viewBasicInfo,
                      _viewEducationInfo,
                      _viewCareerObjective,
                      _viewWorkingHistory,
                      _viewSkills,
                      _viewOtherSections,
                      nil];
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
   //Basic Info
    NSFetchRequest *fetchUserInfoRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserInfo"];
    self.savedBasicInfo = [[managedObjectContext executeFetchRequest:fetchUserInfoRequest error:nil] mutableCopy];
    //Education
    NSFetchRequest *fetchEducationRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserEducation"];
    self.savedEducation = [[managedObjectContext executeFetchRequest:fetchEducationRequest error:nil] mutableCopy];
    //Career Objective
    NSFetchRequest *fetchObjectiveRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserCareerObjective"];
    self.savedCareerObjective = [[managedObjectContext executeFetchRequest:fetchObjectiveRequest error:nil] mutableCopy];
    //Work Info
    NSFetchRequest *fetchWorkRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserWorkingHistory"];
    self.savedWorkHistory = [[managedObjectContext executeFetchRequest:fetchWorkRequest error:nil] mutableCopy];

    //Skills
    NSFetchRequest *fetchSkillRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserSkills"];
    self.savedSkills = [[managedObjectContext executeFetchRequest:fetchSkillRequest error:nil] mutableCopy];
    //Additional Sections
    NSFetchRequest *fetchSectionRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserAdditionalSection"];
    self.savedSections = [[managedObjectContext executeFetchRequest:fetchSectionRequest error:nil] mutableCopy];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self checkSectionStatus];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    for (UIView *viewArray in self.viewArray){
        for (UIView *subviews in viewArray.subviews)
        {
            if (subviews.tag == 999) {
                [subviews removeFromSuperview];
            }
            if (subviews.tag == 998) {
                [subviews removeFromSuperview];
            }
        }
    }
    interstitial_.delegate = nil;
}

-(void)checkSectionStatus
{
    for (int x = 0; x < [self.viewArray count]; x++) {
        
        switch ((sectionNumbers) x) {
            case kBasicInfo:
            {
                NSInteger status;
                float percentage;
                if ([self.savedBasicInfo count] > 0) {
                    currentBasicInfo = [self.savedBasicInfo objectAtIndex:0];
                    int y = 0;
                    if (currentBasicInfo.firstName.length > 1) {
                        y++;
                    }if (currentBasicInfo.lastName.length > 1) {
                        y++;
                    }if (currentBasicInfo.email.length > 1) {
                        y++;
                    }if (currentBasicInfo.mobile.length > 1) {
                        y++;
                    }if (currentBasicInfo.city.length > 1) {
                        y++;
                    }if (currentBasicInfo.address.length > 1) {
                        y++;
                    }if (currentBasicInfo.birthdate.length > 1) {
                        y++;
                    }
                    percentage = y/7.0f;
                    if (percentage == 1) {
                       status = sectionCompleted;
                    }else{
                        status = sectionHasStarted;
                    }
                    
                }else{
                    status = sectionNotStarted;
                    percentage = 0;
                }
                [self initialAnimationInView:_viewBasicInfo withStatus:status andPercentage:percentage withSuccess:^(NSString *success) {
                }];
             
            }
                break;
            case kEducation:
                {
                    NSInteger status;
                    float percentage;
                    if ([self.savedEducation count]>0) {
                        status = sectionCompleted;
                        percentage = 1;
                    }else{
                        status = sectionNotStarted;
                        percentage = 0;
                    }
                    [self initialAnimationInView:_viewEducationInfo withStatus:status andPercentage:percentage withSuccess:^(NSString *success) {
                        
                    }];
                }
                break;
            case kCareerObjective:
                {
                    NSInteger status;
                    float percentage;
                    if ([self.savedCareerObjective count]>0) {
                        status = sectionCompleted;
                        percentage = 1;
                    }else{
                        status = sectionNotStarted;
                        percentage = 0;
                    }
                    [self initialAnimationInView:_viewCareerObjective withStatus:status andPercentage:percentage withSuccess:^(NSString *success) {
                        
                    }];
                }
                break;
            case kWorkingHistory:
            {
                NSInteger status;
                float percentage;
                if ([self.savedWorkHistory count]>0) {
                    status = sectionCompleted;
                    percentage = 1;
                }else{
                    status = sectionNotStarted;
                    percentage = 0;
                }
                [self initialAnimationInView:_viewWorkingHistory withStatus:status andPercentage:percentage withSuccess:^(NSString *success) {
                    
                }];
            }
                break;
            case kSkills:
            {
                NSInteger status;
                float percentage;
                if ([self.savedSkills count]>0) {
                    status = sectionCompleted;
                    percentage = 1;
                }else{
                    status = sectionNotStarted;
                    percentage = 0;
                }
                [self initialAnimationInView:_viewSkills withStatus:status andPercentage:percentage withSuccess:^(NSString *success) {
                    
                }];
            }
                break;
            case kOtherSections:
            {
                NSInteger status;
                float percentage;
                if ([self.savedSections count]>0) {
                    status = sectionCompleted;
                    percentage = 1;
                }else{
                    status = sectionNotStarted;
                    percentage = 0;
                }
                [self initialAnimationInView:_viewOtherSections withStatus:status andPercentage:percentage withSuccess:^(NSString *success) {
                    
                }];
            }
                break;
            default:
                break;
        }
    }
}

-(void)initialAnimationInView:(UIView *)selectedView withStatus:(NSInteger)status andPercentage:(float)percentage withSuccess:(initialAnimationSuccess)success
{
    UIView *statusBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, selectedView.frame.size.height)];
    [statusBar setAlpha:0];
    statusBar.tag = 999;
    NSString *completionString;
    UILabel *lblCompletionPercentage = [[UILabel alloc]initWithFrame:CGRectMake(181, 5, 67, 21)];
    lblCompletionPercentage.tag = 998;
    [lblCompletionPercentage setTextAlignment:NSTextAlignmentCenter];
    [lblCompletionPercentage setAlpha:0];
    [selectedView addSubview:lblCompletionPercentage];
    switch ((completionStatus)status) {
        case sectionCompleted:
            [statusBar setBackgroundColor:[UIColor greenColor]];
            lblCompletionPercentage.text = @"100%";
            break;
        case sectionHasStarted:
            [statusBar setBackgroundColor:[UIColor yellowColor]];
            lblCompletionPercentage.text =[NSString stringWithFormat:@"%d %%", (int)(percentage * 100)];
            break;
        case sectionNotStarted:
            [statusBar setBackgroundColor:[UIColor redColor]];
            lblCompletionPercentage.text = @"0%";
            break;
        default:
            break;
    }
    [selectedView insertSubview:statusBar atIndex:0];
    [UIView animateWithDuration:1.5 animations:^{
        [statusBar setAlpha:1.0];
        if (completionStatus == sectionHasStarted) {
            [statusBar setFrame:CGRectMake(0, 0, selectedView.frame.size.width * percentage, selectedView.frame.size.height)];
        }else{
            [statusBar setFrame:CGRectMake(0, 0, selectedView.frame.size.width, selectedView.frame.size.height)];
        }
        
    } completion:^(BOOL finished) {
        [lblCompletionPercentage setAlpha:1.0f];
        success(completionString);
    }];
}

-(void)midAnimationInView:(UIView *)selectedView withStatus:(NSInteger)status withSuccess:(midAnimationSuccess)success
{
    
}

-(void)finalAnimationInView:(UIView *)selectedView withStatus:(NSInteger)status withSuccess:(finalAnimationSuccess)success
{
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"confirmBasicInfoSegue"]) {
        MyCVBasicInfoViewController *detailsVC = (MyCVBasicInfoViewController *)segue.destinationViewController;
        detailsVC.comesFromConfirmPage = YES;
    }else if ([segue.identifier isEqualToString:@"confirmEducationSegue"]) {
        MyCVEducationViewController *detailsVC = (MyCVEducationViewController *)segue.destinationViewController;
        detailsVC.comesFromConfirmPage = YES;
    }else if ([segue.identifier isEqualToString:@"confirmObjectiveSegue"]) {
        MyCVCareerObjectiveViewController *detailsVC = (MyCVCareerObjectiveViewController *)segue.destinationViewController;
        detailsVC.comesFromConfirmPage = YES;
    }else if ([segue.identifier isEqualToString:@"confirmWorkSegue"]) {
        MyCVWorkingHistoryViewController *detailsVC = (MyCVWorkingHistoryViewController *)segue.destinationViewController;
        detailsVC.comesFromConfirmPage = YES;
    }else if ([segue.identifier isEqualToString:@"confirmSkillSegue"]) {
        MyCVSkillsViewController *detailsVC = (MyCVSkillsViewController *)segue.destinationViewController;
        detailsVC.comesFromConfirmPage = YES;
    }else if ([segue.identifier isEqualToString:@"confirmOtherSegue"]) {
        MyCVOtherSectionViewController *detailsVC = (MyCVOtherSectionViewController *)segue.destinationViewController;
        detailsVC.comesFromConfirmPage = YES;
    }else if ([segue.identifier isEqualToString:@"pdfChooseSegue"])
    {
        

        MyCVPDFDesignOptionsViewController *pdfController = (MyCVPDFDesignOptionsViewController *)segue.destinationViewController;
        pdfController.confirmedBasicInfo = self.savedBasicInfo;
        pdfController.confirmedEducation = self.savedEducation;
        pdfController.confirmedCareerObjective = self.savedCareerObjective;
        pdfController.confirmedWorkHistory = self.savedWorkHistory;
        pdfController.confirmedSkills = self.savedSkills;
        pdfController.confirmedAdditionalSections = self.savedSections;
    }
}


-(void)validateData
{
    

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithString:[NSString stringWithFormat:@"%@_%@.pdf", currentBasicInfo.firstName, currentBasicInfo.lastName]]];
    [self CreaPDFconPath:path];
    
}


#pragma mark - PDF

-(void)CreaPDFconPath:(NSString*)pdfFilePath{
    
    
    UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
    
    UIColor*color = [UIColor blackColor];
    NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
    
    NSString* text = [NSString stringWithFormat:@"%@ \n\n%@", currentBasicInfo.firstName, currentBasicInfo.lastName];
    
    CGFloat stringSize = [text boundingRectWithSize:CGSizeMake(980, CGFLOAT_MAX)// use CGFLOAT_MAX to dinamically calculate the height of a string
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:att context:nil].size.height;
    
    //creo pdf e vi aggiungo testo e immagini
    PDFHelper *pdfFile = [[PDFHelper alloc]init];
    [pdfFile initContentOfFile];
    [pdfFile setSize:CGSizeMake(612, 792)];
    
    [pdfFile addHeadertWithRect:currentBasicInfo.firstName inRect:CGRectMake(10, 10, 980, 60)];
    UIImage *imageData = [UIImage imageWithData:[NSData dataWithContentsOfFile:currentBasicInfo.profilePicUrl]];
    
    [pdfFile addImageWithRect:imageData inRect:CGRectMake(10, 80, 250, 250)];
    
    NSString*stringInfo = [NSString stringWithFormat:@"%@:%@ \n\n%@",currentBasicInfo.email,currentBasicInfo.mobile,currentBasicInfo.country];
    [pdfFile addHeadertWithRect:stringInfo inRect:CGRectMake(300, 190, 500, 120)];
    
    [pdfFile addTextWithRect:text inRect:CGRectMake(10, 350, 980, CGFLOAT_MAX)];
    
    
    //disegno header immagine e testo
   // [pdfFile drawHeader];
   // [pdfFile drawImage];
   // [pdfFile drawText];
    //genero pdf
    [pdfFile drawHeaderWithBasicInfo:self.savedBasicInfo];
    [pdfFile drawCareerObjective:self.savedCareerObjective];
    [pdfFile drawEducationSection:self.savedEducation];
    [pdfFile drawWorkExperience:self.savedWorkHistory];
    [pdfFile drawSkills:self.savedSkills];
    [pdfFile drawOtherSection:self.savedSections];
    generatedFile = [NSMutableData data];
    [pdfFile generatePdfWithFilePath:pdfFilePath withSuccess:^(NSMutableData *pdfFile) {
        if (pdfFile) {
            generatedFile = pdfFile;
            [self sendEmail];
            
        }
    }];
    
    
}

-(void)showActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose your format" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"PDF",@"Text", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault; [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self performSegueWithIdentifier:@"pdfChooseSegue" sender:self];
            
        }
            break;
        case 1:
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Coming soon" message:@"This feature will be coming soon" delegate:self cancelButtonTitle:@"OK :(" otherButtonTitles: nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}



-(void)sendEmail{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[currentBasicInfo.email]];
        [composeViewController setSubject:[NSString stringWithFormat:@"%@ %@ Resumé", currentBasicInfo.firstName, currentBasicInfo.lastName]];
        [composeViewController setMessageBody:@"This is my resumé" isHTML:YES];
        [composeViewController addAttachmentData:generatedFile mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@%@_resume", currentBasicInfo.lastName, currentBasicInfo.firstName]];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark GADInterstitialDelegate implementation

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [self showLoadingIndicator];
    [interstitial_ presentFromRootViewController:self];
    //self.showInterstitialButton.enabled = YES;
    
}
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"%@", error);
}




@end
