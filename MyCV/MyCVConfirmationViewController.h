//
//  MyCVConfirmationViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 28/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCVSections.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>



typedef void (^initialAnimationSuccess)(NSString *success);
typedef void (^midAnimationSuccess)(NSString *success);
typedef void (^finalAnimationSuccess)(NSString *success);
typedef NS_ENUM(NSInteger, sectionNumbers) {
    kBasicInfo = 0,
    kEducation,
    kCareerObjective,
    kWorkingHistory,
    kSkills,
    kOtherSections
};
typedef NS_ENUM(NSInteger, completionStatus) {
   sectionCompleted = 1,
   sectionHasStarted,
   sectionNotStarted
};

@interface MyCVConfirmationViewController : MyCVBaseViewController<MFMailComposeViewControllerDelegate, UIActionSheetDelegate>
{
    BOOL isComplete;
    BOOL isStarted;
    MyCVAppDelegate *appDelegate;
    NSInteger completionStatus;
    UserInfo *currentBasicInfo;
    UserEducation *currentEducation;
    UserSkills *currentSkills;
    UserWorkingHistory *currentWorks;
    UserAdditionalSection *currentSections;
    UserCareerObjective *currentObjective;
    NSMutableData *generatedFile;
}

@property (weak, nonatomic) IBOutlet UIView *viewBasicInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblBasicInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnBasicInfo;

@property (weak, nonatomic) IBOutlet UIView *viewEducationInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblEducation;
@property (weak, nonatomic) IBOutlet UIButton *btnEducation;

@property (weak, nonatomic) IBOutlet UIView *viewCareerObjective;
@property (weak, nonatomic) IBOutlet UILabel *lblCareerObjective;
@property (weak, nonatomic) IBOutlet UIButton *btnCareerObjective;

@property (weak, nonatomic) IBOutlet UIView *viewWorkingHistory;
@property (weak, nonatomic) IBOutlet UILabel *lblWorkingHistory;
@property (weak, nonatomic) IBOutlet UIButton *btnWorkingHistory;

@property (weak, nonatomic) IBOutlet UIView *viewSkills;
@property (weak, nonatomic) IBOutlet UILabel *lblSkills;
@property (weak, nonatomic) IBOutlet UIButton *btnSkills;

@property (weak, nonatomic) IBOutlet UIView *viewOtherSections;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherSections;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherSections;

@property (nonatomic, strong) NSArray *viewArray;

//Core Data Arrays
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong)NSArray* fetchedInfoArray;
@property (nonatomic,strong)NSArray* fetchedEducationArray;
@property (nonatomic,strong)NSArray* fetchedSkillsArray;
@property (nonatomic,strong)NSArray* fetchedWorksArray;
@property (nonatomic,strong)NSArray* fetchedObjectiveArray;
@property (nonatomic,strong)NSArray* fetchedSectionsArray;



@property (weak, nonatomic) IBOutlet UIButton *btnBuildResumé;
@end
