//
//  PDFHelper.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 03/09/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyCVSections.h"


typedef void (^PdfSuccess)(NSMutableData *pdfFile);
typedef void (^PdfFailed)(NSString *failed);

@import CoreText;
@interface PDFHelper : NSObject
{
    UserInfo *currentInfo;
    UserEducation *currentEducation;
    UserCareerObjective *currentObjective;
    CGRect currentRect;
    CGFloat topOrigin;
    CGFloat sectionTitleX;
    int designNumber;
    CGRect sideBarRect;
    CGRect currentSideBarRect;
    NSLayoutManager *_layoutManager;
    NSTextStorage *_textStorage;
    
}
@property(nonatomic, readwrite) CGSize size;
@property (nonatomic, strong)NSMutableArray *confirmedBasicInfo;
@property (nonatomic, strong)NSMutableArray *confirmedEducation;
@property (nonatomic, strong)NSMutableArray *confirmedCareerObjective;
@property (nonatomic, strong)NSMutableArray *confirmedWorkHistory;
@property (nonatomic, strong)NSMutableArray *confirmedSkills;
@property (nonatomic, strong)NSMutableArray *confirmedAdditionalSections;
@property(nonatomic, strong)  NSMutableData *data;
@property (nonatomic) int designNumber;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
-(void)initContentOfFile;
-(void)addImageWithRect:(UIImage*)image inRect:(CGRect)rect;
-(void)addTextWithRect:(NSString*)text inRect:(CGRect)rect;
-(void)addHeadertWithRect:(NSString *)text inRect:(CGRect)rect;
//Design One
-(void)drawHeaderWithBasicInfo:(NSMutableArray *)basicInfoArray;
-(void)drawEducationSection: (NSMutableArray *)educationArray;
-(void)drawCareerObjective:(NSMutableArray *)careerObjective;
-(void)drawWorkExperience: (NSMutableArray *)workArray;
-(void)drawSkills: (NSMutableArray *)skillsArray;
-(void)drawOtherSection: (NSMutableArray *)otherSection;
//Design Two
-(void)drawHeaderforDesignTwoWithBasicInfo:(NSMutableArray *)basicInfoArray;
-(void)drawCareerObjectiveForDesignTwo:(NSMutableArray *)careerObjective;
-(void)drawEducationSectionForDesignTwo: (NSMutableArray *)educationArray;



- (void) drawText;
- (void) drawHeader;
- (void) drawImage;
- (NSMutableData*) generatePdfWithFilePath: (NSString *)thefilePath withSuccess: (PdfSuccess)pdfFile;

-(void)createNewPdf;
@end
