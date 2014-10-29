//
//  MyCVPickerViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 24/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCVPicker.h"

@protocol MyCVPickerDelegate;
@interface MyCVPickerViewController : UIViewController <MyCVPicker, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) id<MyCVPickerDelegate> delegate;
@property (strong, nonatomic) id pickerTag;                     ///< A arbitrary value that can be associated with the picker.
@property (nonatomic) CGFloat pickerHeight;
@property (strong, nonatomic) NSArray *pickerItems;
@property (weak, nonatomic) IBOutlet UILabel *toolbarLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIView *fadeView;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

- (id)initWithDelegate:(id<MyCVPickerDelegate>)delegate;
- (void)showInViewController:(UIViewController *)parentVC;

@end

@protocol MyCVPickerDelegate <NSObject>

- (void)pickerWasCancelled:(MyCVPickerViewController *)picker;
- (void)picker:(MyCVPickerViewController *)picker pickedValueAtIndex:(NSInteger)index;
@end