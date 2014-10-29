//
//  MyCVCustomDatePickerViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 19/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVCustomDatePickerViewController.h"

@interface MyCVCustomDatePickerViewController ()
- (void)dismissPickerView;
@end

@implementation MyCVCustomDatePickerViewController
@synthesize fadeView            = _fadeView;

@synthesize delegate            = _delegate;
@synthesize pickerTag           = _pickerTag;
@synthesize pickerHeight        = _pickerHeight;
@synthesize toolbarLabel        = _toolbarLabel;
@synthesize pickerView          = _pickerView;

- (id)init
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self = [self initWithNibName:@"MyCVCustomDatePickerViewController" bundle:nil];
    }else{
        self = [self initWithNibName:@"MyCVCustomDatePickerViewController" bundle:nil];
    }
    return self;
}

- (id)initWithDelegate:(id<MyCVDatePickerDelegate>)delegate
{
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.pickerHeight = 460;
    }else{
        self.pickerHeight = 960;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPickerView:nil];
    [self setToolbarLabel:nil];
    [self setFadeView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate pickerWasCancelled:self];
    [self dismissPickerView];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.delegate picker:self pickedDate:[self.pickerView date]];
    [self dismissPickerView];
}

- (void)dismissPickerView
{
    [UIView animateWithDuration:0.3 delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame = CGRectMake(0, self.parentViewController.view.frame.size.height, self.view.frame.size.width, self.pickerHeight);
                     } completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

- (void)showInViewController:(UIViewController *)parentVC
{
    [self.view setNeedsDisplay];
    self.fadeView.alpha = 1;
    
    self.view.frame = CGRectMake(0, parentVC.view.frame.size.height, self.view.frame.size.width, self.pickerHeight);
    CGRect framOne = self.view.frame;
    [parentVC addChildViewController:self];
    [parentVC.view addSubview:self.view];
    [UIView animateWithDuration:0.3 delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame = CGRectMake(0, parentVC.view.frame.size.height-self.pickerHeight, self.view.frame.size.width, self.view.frame.size.height);
                     } completion:^(BOOL finished) {
                         //[self.pickerView setDate:[NSDate date] animated:YES];
                     }];
    CGRect frameTwo = self.view.frame;
}

@end
