//
//  MyCVPickerViewController.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 24/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVPickerViewController.h"

@interface MyCVPickerViewController ()
- (void)dismissPickerView;
@end

@implementation MyCVPickerViewController
@synthesize fadeView = _fadeView;

@synthesize delegate            = _delegate;
@synthesize pickerTag           = _pickerTag;
@synthesize pickerHeight        = _pickerHeight;
@synthesize pickerItems         = _pickerItems;
@synthesize toolbarLabel        = _toolbarLabel;
@synthesize pickerView          = _pickerView;

- (id)init
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self = [self initWithNibName:@"MyCVPickerViewController" bundle:nil];
    }else{
       // self = [self initWithNibName:@"iPadPickerView" bundle:nil];
    }
    return self;
}

- (id)initWithDelegate:(id<MyCVPickerDelegate>)delegate
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
    if (self) {
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            self.pickerHeight = 460;
        }else{
            self.pickerHeight = 660;
        }
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
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate pickerWasCancelled:self];
    [self dismissPickerView];
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.delegate picker:self pickedValueAtIndex:[self.pickerView selectedRowInComponent:0]];
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
    self.fadeView.alpha = 0.0;
    
    self.view.frame = CGRectMake(0, parentVC.view.frame.size.height, self.view.frame.size.width, self.pickerHeight);
    CGRect frameOne = self.view.frame;
    [parentVC addChildViewController:self];
    [parentVC.view addSubview:self.view];
    [UIView animateWithDuration:0.3 delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.view.frame = CGRectMake(0, parentVC.view.frame.size.height-self.pickerHeight, self.view.frame.size.width, self.view.frame.size.height);
                         
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    CGRect frameTwo = self.view.frame;
}

#pragma mark - UIPickerViewDelegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.pickerItems count] > 0) {
        return [self.pickerItems objectAtIndex:row];
    }
    else {
        return @"";
    }
}

#pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerItems) {
        return [self.pickerItems count];
    }
    else {
        return 0;
    }
}

@end
