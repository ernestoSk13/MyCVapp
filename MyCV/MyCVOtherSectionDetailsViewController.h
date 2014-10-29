//
//  MyCVOtherSectionDetailsViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 27/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAdditionalSection.h"

typedef void (^SectionSavedSuccessfully)(NSString *success);
typedef void (^SectionSavedFailed)(NSString *failed);
@interface MyCVOtherSectionDetailsViewController : UIViewController <UIGestureRecognizerDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    MyCVAppDelegate *appDelegate;
    BOOL goesToEdit;
    UserAdditionalSection *currentSection;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtSectionName;
@property (weak, nonatomic) IBOutlet UITextView *txtSectionDescription;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong)NSArray* fetchedSectionsArray;
@property (nonatomic)NSInteger selectedSectionIndex;
@property(nonatomic) BOOL hasDataStored;
@end
