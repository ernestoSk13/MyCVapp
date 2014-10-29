//
//  MyCVSkillDetailsViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 27/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSkills.h"
#import "MyCVPickerViewController.h"

typedef void (^SkillSavedSuccessfully)(NSString *success);
typedef void (^SkillSavedFailed)(NSString *failed);
@interface MyCVSkillDetailsViewController : MyCVBaseViewController <UITextFieldDelegate, MyCVPickerDelegate, UIGestureRecognizerDelegate>
{
    MyCVAppDelegate *appDelegate;
    NSArray *yearsArray;
    UserSkills *currentSkill;
}

@property (weak, nonatomic) IBOutlet UILabel *lblExperienceYears;
@property (weak, nonatomic) IBOutlet UITextField *txtSkillName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnExperience;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong)NSArray* fetchedSkillArray;
@property (nonatomic)NSInteger selectedSkillIndex;
@property(nonatomic) BOOL hasDataStored;
@end
