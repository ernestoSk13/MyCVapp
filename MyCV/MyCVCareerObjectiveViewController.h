//
//  MyCVCareerObjectiveViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 26/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCareerObjective.h"
typedef void (^ObjectiveSavedSuccessfully)(NSString *success);
typedef void (^ObjectivSavedFailed)(NSString *failed);
@import CoreData;
@interface MyCVCareerObjectiveViewController : MyCVBaseViewController <UITextViewDelegate, UIGestureRecognizerDelegate>
{
    UserCareerObjective *currentObjective;
    BOOL hasObjectiveStored;
    MyCVAppDelegate *appDelegate;
}

@property (weak, nonatomic) IBOutlet UITextView *txtCareerObjective;
@property (weak, nonatomic) IBOutlet UIButton *btnContinue;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *imageURL;
@property (nonatomic,strong)NSArray* fetchedObjectiveArray;
@property (nonatomic) BOOL hasDataStored;
@property(nonatomic) BOOL comesFromConfirmPage;
@end
