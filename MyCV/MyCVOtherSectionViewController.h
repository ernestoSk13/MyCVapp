//
//  MyCVOtherSectionViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 27/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAdditionalSection.h"

@interface MyCVOtherSectionViewController : MyCVBaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    MyCVAppDelegate *appDelegate;
    BOOL goesEdit;
    NSInteger sectionIndex;
}


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
@property (weak, nonatomic) IBOutlet UITableView *tblSectionList;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong)NSArray* fetchedSectionsArray;
@property(nonatomic) BOOL hasDataStored;
@property(nonatomic) BOOL comesFromConfirmPage;
@end
