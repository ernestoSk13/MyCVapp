//
//  MyCVCustomDatePickerViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 19/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCVPicker.h"

@protocol MyCVDatePickerDelegate;

@interface MyCVCustomDatePickerViewController : UIViewController <MyCVPicker>
@property (weak, nonatomic) id<MyCVDatePickerDelegate> delegate;
@property (strong, nonatomic) id pickerTag;                     ///< A arbitrary value that can be associated with the picker.
@property (nonatomic) CGFloat pickerHeight;
@property (weak, nonatomic) IBOutlet UILabel *toolbarLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (weak, nonatomic) IBOutlet UIView *fadeView;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

- (id)initWithDelegate:(id<MyCVDatePickerDelegate>)delegate;
- (void)showInViewController:(UIViewController *)parentVC;


@end

@protocol MyCVDatePickerDelegate <NSObject>

- (void)pickerWasCancelled:(MyCVCustomDatePickerViewController *)picker;
- (void)picker:(MyCVCustomDatePickerViewController *)picker pickedDate:(NSDate *)date;

@end