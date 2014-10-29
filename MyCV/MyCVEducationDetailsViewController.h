//
//  MyCVEducationDetailsViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 26/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCVPickerViewController.h"
#import "UserEducation.h"
#import "UserInfo.h"
typedef void (^EducationSavedSuccessfully)(NSString *success);
typedef void (^EducationSavedFailed)(NSString *failed);
@interface MyCVEducationDetailsViewController : MyCVBaseViewController <UITextFieldDelegate, MyCVPickerDelegate>
{
    
    NSArray *degreesArray;
    NSMutableArray *monthsArray;
    NSMutableArray *yearsArray;
    NSMutableArray *lastYearsArray;
    MyCVAppDelegate *appDelegate;
    UserEducation *currentUserEducation;
    UserInfo *currentUser;
    
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (weak, nonatomic) IBOutlet UILabel *lblDegree;
@property (weak, nonatomic) IBOutlet UIButton *btnDegree;
@property (weak, nonatomic) IBOutlet UITextField *txtSchoolName;
@property (weak, nonatomic) IBOutlet UITextField *txtMajorName;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnFirstMonth;
@property (weak, nonatomic) IBOutlet UIButton *btnFirstYear;
@property (weak, nonatomic) IBOutlet UIButton *btnLastMonth;
@property (weak, nonatomic) IBOutlet UIButton *btnLastYear;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstYear;
@property (weak, nonatomic) IBOutlet UILabel *lblLastYear;
@property (weak, nonatomic) IBOutlet UILabel *lblLastMonth;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;
@property (nonatomic,strong)NSArray* fetchedEducationArray;
@property (nonatomic,strong)NSArray* fetchedUserArray;
@property(nonatomic) BOOL hasDataStored;
@property (nonatomic)NSInteger selectedEducationIndex;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstMonth;


@end
