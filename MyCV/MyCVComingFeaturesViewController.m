//
//  MyCVComingFeaturesViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 08/09/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVComingFeaturesViewController.h"
#import "GADBannerView.h"
#import "GADRequest.h"

@interface MyCVComingFeaturesViewController ()

@end

@implementation MyCVComingFeaturesViewController

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
    [_btnEmail addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"sankurlabs@gmail.com"]];
        [composeViewController setSubject:@"I've got some suggestions for ResumeGen app"];
        [composeViewController setMessageBody:@"Sent from ResumeGen app" isHTML:YES];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark Ads Delegate

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
