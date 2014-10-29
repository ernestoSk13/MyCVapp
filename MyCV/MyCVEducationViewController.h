//
//  MyCVEducationMenuViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 24/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCVPickerViewController.h"
#import "UserEducation.h"
@import CoreData;

@interface MyCVEducationViewController : MyCVBaseViewController<UITableViewDataSource, UITableViewDataSource, MyCVPickerDelegate>
{
    MyCVAppDelegate *appDelegate;
    UserEducation *currentEducation;
    NSArray *degreesArray;
    NSString *highestDegree;
    BOOL goesToEdit;
    NSInteger experienceIndex;
    NSInteger educationIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectDegree;
@property (weak, nonatomic) IBOutlet UITableView *educationTable;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *degreeLabel;
@property (nonatomic,strong)NSArray* fetchedEducationArray;
@property(nonatomic) BOOL hasDataStored;
@property(nonatomic) BOOL comesFromConfirmPage;
@end
