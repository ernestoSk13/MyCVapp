//
//  MyCVPDFDesignOptionsViewController.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 05/09/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCVSections.h"
#import "PDFHelper.h"
#import "MyCVPDFPreviewViewController.h"
typedef enum{
    DesignOne = 1,
    DesignTwo,
    DesignThree
}DesignNumber;


@import iAd;
@interface MyCVPDFDesignOptionsViewController : MyCVBaseViewController <UIDocumentInteractionControllerDelegate, ADInterstitialAdDelegate, UIScrollViewDelegate>
{
    NSInteger theDesignNumber;
    CGRect returningRect;
    UserInfo *currentBasicInfo;
    NSMutableData *generatedFile;
    ADInterstitialAd *interstitial;
    UIView *AdView;
    NSArray *designs;
    NSDictionary *imageDict;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnHome;
@property (weak, nonatomic) IBOutlet UILabel *lblDesignTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDesign;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDesignTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewDesignThree;
@property (weak, nonatomic) IBOutlet UIButton *btnDesign;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPage;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


//Tutorial View
@property (nonatomic, strong) UIView *shadowView;


//Core Data Arrays
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong)NSArray* fetchedInfoArray;
@property (nonatomic, strong)NSMutableArray *confirmedBasicInfo;
@property (nonatomic, strong)NSMutableArray *confirmedEducation;
@property (nonatomic, strong)NSMutableArray *confirmedCareerObjective;
@property (nonatomic, strong)NSMutableArray *confirmedWorkHistory;
@property (nonatomic, strong)NSMutableArray *confirmedSkills;
@property (nonatomic, strong)NSMutableArray *confirmedAdditionalSections;
@property(nonatomic, strong)  NSMutableData *data;


@end
