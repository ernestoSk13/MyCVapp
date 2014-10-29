//
//  MyCVBaseViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 17/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#import "MyCVBaseViewController.h"

@interface MyCVBaseViewController ()

@end

@implementation MyCVBaseViewController

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
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ipadBg"]]];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showLoadingIndicator
{
    self.viewBg = [[UIView alloc]initWithFrame:self.navigationController.view.frame];
    [self.viewBg setBackgroundColor:[UIColor blackColor]];
    [self.viewBg setAlpha:0.8];
    [self.view addSubview:self.viewBg];
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setFrame:CGRectMake(self.view.center.x - self.activityIndicator.frame.size.width, self.view.center.y - self.activityIndicator.frame.size.height, 100, 100)];
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

-(void)hideLoadingIndicator
{
    [self.activityIndicator stopAnimating];
    [self.viewBg removeFromSuperview];
    [self.activityIndicator removeFromSuperview];
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
