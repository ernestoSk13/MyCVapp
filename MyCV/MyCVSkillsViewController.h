//
//  MyCVSkillsViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 27/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSkills.h"

@import CoreData;
@interface MyCVSkillsViewController : MyCVBaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    MyCVAppDelegate *appDelegate;
    BOOL goesToEdit;
     NSInteger skillIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UITableView *tblSkills;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong)NSArray* fetchedSkillsArray;
@property(nonatomic) BOOL hasDataStored;
@property(nonatomic) BOOL comesFromConfirmPage;

@end
