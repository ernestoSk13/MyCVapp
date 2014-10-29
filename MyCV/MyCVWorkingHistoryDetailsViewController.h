//
//  MyCVWorkingHistoryDetailsViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 27/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserWorkingHistory.h"
#import "MyCVPickerViewController.h"
#import "UserInfo.h"

typedef void (^WorkingHistorySavedSuccessfully)(NSString *success);
typedef void (^WorkingHistorySavedFailed)(NSString *failed);
@interface MyCVWorkingHistoryDetailsViewController : MyCVBaseViewController <UITextFieldDelegate, UITextViewDelegate, MyCVPickerDelegate, UIGestureRecognizerDelegate>
{
    MyCVAppDelegate *appDelegate;
    NSMutableArray *monthsArray;
    NSMutableArray *yearsArray;
    NSMutableArray *lastYearsArray;
    UserWorkingHistory *currentUserWork;
    UserInfo *currentUser;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnFirstMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstMonth;
@property (weak, nonatomic) IBOutlet UIButton *btnFirstYear;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstYear;
@property (weak, nonatomic) IBOutlet UIButton *btnLastMonth;
@property (weak, nonatomic) IBOutlet UILabel *lblLastMonth;
@property (weak, nonatomic) IBOutlet UIButton *btnLastYear;
@property (weak, nonatomic) IBOutlet UILabel *lblLastYear;
@property (weak, nonatomic) IBOutlet UITextField *txtJobTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtCompany;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextView *txtJobDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong)NSArray* fetchedWorkArray;
@property (nonatomic, strong)NSArray *fetchedUserArray;
@property (nonatomic)NSInteger selectedWorkIndex;
@property(nonatomic) BOOL hasDataStored;

@end
