//
//  MyCVWorkingHistoryViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 26/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserWorkingHistory.h"

@import CoreData;
@interface MyCVWorkingHistoryViewController : MyCVBaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    MyCVAppDelegate *appDelegate;
    BOOL goesToEdit;
    NSInteger workIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tblWorkingHistory;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong)NSArray* fetchedWorkArray;
@property(nonatomic) BOOL hasDataStored;
@property (weak, nonatomic) IBOutlet UIButton *btnAddWork;
@property(nonatomic) BOOL comesFromConfirmPage;
@end
