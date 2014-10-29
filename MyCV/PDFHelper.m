//
//  PDFHelper.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 03/09/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "PDFHelper.h"
#import "UIImage+customProperties.h"
#import "UIColor+customProperties.h"

@implementation PDFHelper

-(void) initContentOfFile
{
    self.data = [NSMutableData data];
}

-(void)drawBackGround
{
    
}

-(void)drawHeaderWithBasicInfo:(NSMutableArray *)basicInfoArray
{
   // designNumber = 1;
    designNumber = self.designNumber;
   // [self drawBackGround];
    self.confirmedBasicInfo = basicInfoArray;
    currentInfo = [self.confirmedBasicInfo objectAtIndex:0];
   
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
     UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height / 3.5)];
    if (designNumber == 3) {
        [backgroundView setFrame:CGRectMake(0, 0, self.size.width, 50)];
    }
   
    [backgroundView setBackgroundColor:[UIColor colorWithHexString:@"404749"]];
    [backgroundView.layer renderInContext:currentContext];
    
    UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:currentInfo.profilePicUrl]];
    profileImage = [UIImage imageWithImage:profileImage scaledToNewSize:CGSizeMake(120, 120)];
    profileImage = [UIImage imageWithRoundCorner:profileImage andCornerSize:CGSizeMake(60, 60)];
    UIImage *skLogo = [UIImage imageNamed:@"SKLogo"];
    NSString *userName = [NSString stringWithFormat:@"%@ %@", currentInfo.firstName, currentInfo.lastName];
     NSString *userTitle = currentInfo.degree;
    NSString *contactInfo = [NSString stringWithFormat:@"cel: %@ · %@ · %@, %@", currentInfo.mobile, currentInfo.email,currentInfo.city, currentInfo.country];
    switch (designNumber) {
        case 1:
        {
            
            [profileImage drawInRect:CGRectMake((self.size.width / 2) - 60, 10, 120, 120)];
            
            skLogo = [UIImage imageWithImage:skLogo scaledToNewSize:CGSizeMake(30, 30)];
            [skLogo drawInRect:CGRectMake(10, 10, 30, 30)];
            
           
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setAlignment:NSTextAlignmentCenter];
            CGRect renderingRect = CGRectMake(0, 140, self.size.width, 28);
            UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
            
            UIColor*color = [UIColor whiteColor];
            NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName: style};
            NSStringDrawingContext *context = [NSStringDrawingContext new];
            context.minimumScaleFactor = 0.1;
            //        [textToDraw drawInRect:renderingRect withAttributes:att];
            [userName drawWithRect:renderingRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
            renderingRect.origin.y += 20;
            [userTitle drawWithRect:renderingRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
            
            renderingRect.origin.y += 20;
            [contactInfo drawWithRect:renderingRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
            currentRect = renderingRect;
        }
            break;
        case 3:
        {
            userName = [NSString stringWithFormat:@"· %@ %@ ·", currentInfo.firstName, currentInfo.lastName];
            skLogo = [UIImage imageWithImage:skLogo scaledToNewSize:CGSizeMake(30, 30)];
            [skLogo drawInRect:CGRectMake(10, 10, 30, 30)];
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setAlignment:NSTextAlignmentCenter];
            CGRect renderingRect = CGRectMake(10, 15, self.size.width, 28);
            UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
            
            UIColor*color = [UIColor whiteColor];
            NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName: style};
            NSStringDrawingContext *context = [NSStringDrawingContext new];
            context.minimumScaleFactor = 0.1;
            [contactInfo drawWithRect:renderingRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
            currentRect = renderingRect;
            
            UIFont *nameFont = [UIFont fontWithName:@"HelveticaNeue" size:40.0f];
            color = [UIColor blackColor];
            NSAttributedString *attributedText =
            [[NSAttributedString alloc]
             initWithString:userName
             attributes:@
             {
             NSFontAttributeName: nameFont
             }];

            CGRect rectSchool = [attributedText boundingRectWithSize:(CGSize){(self.size.width - 20), CGFLOAT_MAX}
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                             context:nil];
            CGSize fontTextSize = rectSchool.size;
            att = @{NSFontAttributeName: nameFont, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName: style};
            
            
            currentRect = CGRectMake((self.size.width / 2) - (fontTextSize.width / 2), 60, fontTextSize.width, 42);
            [userName drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
            
            
            currentRect.origin.y += fontTextSize.height;
            nameFont = [UIFont fontWithName:@"HelveticaNeue-light" size:20];
            color = [UIColor darkGrayColor];
            attributedText =
            [[NSAttributedString alloc]
             initWithString:userTitle
             attributes:@
             {
             NSFontAttributeName: nameFont
             }];
            rectSchool = [attributedText boundingRectWithSize:(CGSize){(self.size.width - 20), CGFLOAT_MAX}
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                      context:nil];
            fontTextSize = rectSchool.size;
            att = @{NSFontAttributeName: nameFont, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName: style};
            [userTitle drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
            

        }
            break;
        default:
            break;
    }
   
}


-(void)drawHeaderforDesignTwoWithBasicInfo:(NSMutableArray *)basicInfoArray
{
    designNumber = 2;
    self.confirmedBasicInfo = basicInfoArray;
    
    currentInfo = [self.confirmedBasicInfo objectAtIndex:0];
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.size.width/ 3, self.size.height)];
    [backgroundView setBackgroundColor:[UIColor colorWithHexString:@"404749"]];
    [backgroundView.layer renderInContext:currentContext];
    sideBarRect = backgroundView.frame;
    UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:currentInfo.profilePicUrl]];
    profileImage = [UIImage imageWithImage:profileImage scaledToNewSize:CGSizeMake(120, 120)];
    profileImage = [UIImage imageWithRoundCorner:profileImage andCornerSize:CGSizeMake(60, 60)];
    [profileImage drawInRect:CGRectMake((backgroundView.frame.size.width / 2) - 60, 10, 120, 120)];
    
    
    UIImage *skLogo = [UIImage imageNamed:@"SKLogo"];
    skLogo = [UIImage imageWithImage:skLogo scaledToNewSize:CGSizeMake(30, 30)];
    [skLogo drawInRect:CGRectMake(10, self.size.height - 40, 30, 30)];
    
    NSString *userName = [NSString stringWithFormat:@"%@ %@", currentInfo.firstName, currentInfo.lastName];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    CGRect renderingRect = CGRectMake(backgroundView.frame.size.width + 10, 30, self.size.width - (backgroundView.frame.size.width + 20), 30);
    UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28.0];
    
    UIColor*color = [UIColor blackColor];
    NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName: style};
    NSStringDrawingContext *context = [NSStringDrawingContext new];
    context.minimumScaleFactor = 0.1;
    //        [textToDraw drawInRect:renderingRect withAttributes:att];
    [userName drawWithRect:renderingRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
    NSString *contactInfo = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", currentInfo.mobile, currentInfo.email,currentInfo.city, currentInfo.country];
    
    UIFont*infoFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0];
    
    UIColor*infoColor = [UIColor whiteColor];
    NSDictionary*attInfo = @{NSFontAttributeName: infoFont, NSForegroundColorAttributeName:infoColor, NSParagraphStyleAttributeName: style};
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:contactInfo
     attributes:@
     {
     NSFontAttributeName: infoFont
     }];
    CGRect rectSchool = [attributedText boundingRectWithSize:(CGSize){(sideBarRect.size.width - 20), CGFLOAT_MAX}
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                     context:nil];
    CGSize fontTextSize = rectSchool.size;

    
    CGRect newRect = CGRectMake(10, 150, sideBarRect.size.width - 20, fontTextSize.height);
    renderingRect.origin.y += 32;
    [contactInfo drawWithRect:newRect options:NSStringDrawingUsesLineFragmentOrigin attributes:attInfo context:context];
    currentSideBarRect = newRect;
    currentRect = renderingRect;
    
    
    
    
}





-(void)drawEducationSectionForDesignTwo: (NSMutableArray *)educationArray
{
    self.confirmedEducation = educationArray;
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    NSString *educationTitle = @"Education";
    currentRect.origin.y += currentRect.size.height + 20;
    currentRect.size.width = self.size.width - (sideBarRect.size.width - 40);
    currentRect.size.height = 15;
    topOrigin = currentRect.origin.y;
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UIColor *color = [UIColor darkGrayColor];
    NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
    NSStringDrawingContext *context = [NSStringDrawingContext new];
    context.minimumScaleFactor = 0.1;
    [educationTitle drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
    
    for (UserEducation *education in self.confirmedEducation) {
        NSString *dates;
        if ([education.lastMonth isEqualToString:@"Present"]) {
            dates   = [NSString stringWithFormat:@"%@ %@ - %@ // %@", education.firstMonth, education.firstYear , education.lastMonth, education.degree];
        }else{
            dates   = [NSString stringWithFormat:@"%@ %@ - %@ %@ // %@", education.firstMonth, education.firstYear , education.lastMonth, education.lastYear, education.degree];
        }
        currentRect.origin.y += currentRect.size.height + 10;
        currentRect.size.height = 14;
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        UIColor *color = [UIColor blackColor];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentJustified];
        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName: style};
        NSStringDrawingContext *context = [NSStringDrawingContext new];
        context.minimumScaleFactor = 0.1;
        [dates drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
        
        NSString *schoolName = [NSString stringWithFormat:@"· %@ : %@ \n %@" ,education.schoolName, education.majorDegree, education.location];
        //NSString *majorDegree = education.majorDegree;
        //NSString *schoolLocation = education.location;
        UIFont *infoFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        UIColor *infoColor = [UIColor lightGrayColor];
        
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:schoolName
         attributes:@
         {
         NSFontAttributeName: infoFont
         }];
        CGRect rectSchool = [attributedText boundingRectWithSize:(CGSize){(self.size.width / 3), CGFLOAT_MAX}
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil];
        CGSize fontTextSize = rectSchool.size;
        //currentRect.origin.x += 20;
        currentRect.origin.y += currentRect.size.height + 4;
        currentRect.size.width = (self.size.width) - ( sideBarRect.size.width -40);
        currentRect.size.height = fontTextSize.height;
        NSMutableParagraphStyle *infoStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [infoStyle setAlignment:NSTextAlignmentJustified];
        NSDictionary*att2 = @{NSFontAttributeName: infoFont, NSForegroundColorAttributeName:infoColor, NSParagraphStyleAttributeName: infoStyle};
        NSStringDrawingContext *contextSchool = [NSStringDrawingContext new];
        contextSchool.minimumScaleFactor = 0.1;
        
        [schoolName drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att2 context:contextSchool];
        
        
    }
}

-(void)drawEducationSection: (NSMutableArray *)educationArray
{
    self.confirmedEducation = educationArray;
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    NSString *educationTitle = @"Education";
    UIView *containerView;
    UILabel *educationLabel;
    switch (designNumber) {
            case 1:
        {
            currentRect.origin.x = 20;
            currentRect.origin.y += currentRect.size.height + 30;
            currentRect.size.width = (self.size.width / 2) - 40;
            currentRect.size.height = 15;
            topOrigin = currentRect.origin.y;
            
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14];
            UIColor *color = [UIColor darkGrayColor];
            NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
            NSStringDrawingContext *context = [NSStringDrawingContext new];
            context.minimumScaleFactor = 0.1;
            [educationTitle drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
        }
            break;
            case 3:
        {
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:16];
            NSAttributedString *attributedText =
            [[NSAttributedString alloc]
             initWithString:educationTitle
             attributes:@
             {
             NSFontAttributeName: font
             }];
            CGRect rectSchool = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, CGFLOAT_MAX}
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                             context:nil];
            CGSize fontTextSize = rectSchool.size;
            educationLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, currentRect.origin.y + fontTextSize.width,
                                                                               fontTextSize.width, fontTextSize.height)];
            containerView = [[UIView alloc]initWithFrame:CGRectMake(20, 300, 60, self.size.height)];
            [containerView addSubview:educationLabel];
            [containerView setBackgroundColor:[UIColor clearColor]];
            
            [educationLabel setFont:font];
            [educationLabel setTextColor:[UIColor darkGrayColor]];
            [educationLabel setText:educationTitle];
            [educationLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            
            
        }
            break;
        
    }
    float firstOrigin = currentRect.origin.y + currentRect.size.height;
    BOOL firstTime = YES;
    for (UserEducation *education in self.confirmedEducation) {
        NSString *dates;
        if ([education.lastMonth isEqualToString:@"Present"]) {
          dates   = [NSString stringWithFormat:@"%@ %@ - %@ // %@", education.firstMonth, education.firstYear , education.lastMonth, education.degree];
        }else{
          dates   = [NSString stringWithFormat:@"%@ %@ - %@ %@ // %@", education.firstMonth, education.firstYear , education.lastMonth, education.lastYear, education.degree];
        }
        currentRect.origin.x = (designNumber == 1) ? 20 : containerView.frame.size.width + 10;
        if (firstTime) {
            currentRect.origin.y += currentRect.size.height;
            firstTime = NO;
        }else{
         currentRect.origin.y += currentRect.size.height + 10;
        }
        currentRect.size.width = (designNumber == 1) ? (self.size.width / 2) - 20 : self.size.width - (self.size.width / 4);
        currentRect.size.height = 14;
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        UIColor *color = [UIColor blackColor];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment: (designNumber == 1) ? NSTextAlignmentRight : NSTextAlignmentLeft];
        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName: style};
        NSStringDrawingContext *context = [NSStringDrawingContext new];
        context.minimumScaleFactor = 0.1;
        [dates drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
        
        NSString *schoolName = [NSString stringWithFormat:@"· %@ : %@ \n %@" ,education.schoolName, education.majorDegree, education.location];
        //NSString *majorDegree = education.majorDegree;
        //NSString *schoolLocation = education.location;
         UIFont *infoFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        UIColor *infoColor = [UIColor lightGrayColor];
        
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:schoolName
         attributes:@
         {
         NSFontAttributeName: infoFont
         }];
        CGRect rectSchool = [attributedText boundingRectWithSize:(CGSize){(self.size.width / 3), CGFLOAT_MAX}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize fontTextSize = rectSchool.size;
        currentRect.origin.x = (designNumber == 1) ? 20 : containerView.frame.size.width + 10;
        currentRect.origin.y += currentRect.size.height + 4;
        currentRect.size.width = (designNumber == 1) ? (self.size.width / 2) - 20 : self.size.width - (self.size.width / 4);
        currentRect.size.height = fontTextSize.height;
        NSMutableParagraphStyle *infoStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [infoStyle setAlignment:(designNumber == 1) ? NSTextAlignmentRight : NSTextAlignmentLeft];
        NSDictionary*att2 = @{NSFontAttributeName: infoFont, NSForegroundColorAttributeName:infoColor, NSParagraphStyleAttributeName: infoStyle};
        NSStringDrawingContext *contextSchool = [NSStringDrawingContext new];
        contextSchool.minimumScaleFactor = 0.1;

        [schoolName drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att2 context:contextSchool];
    }
    if (designNumber == 3) {
       
        UIView *educationSeparator = [[UIView alloc]initWithFrame:CGRectMake(containerView.frame.size.width - 2, firstOrigin, 1, currentRect.origin.y + currentRect.size.height - firstOrigin)];
        if (educationLabel.frame.size.height > educationSeparator.frame.size.height) {
            [educationSeparator setFrame:CGRectMake(containerView.frame.size.width - 2, firstOrigin, 1, educationLabel.frame.size.height + 10)];
        }
        [educationSeparator setBackgroundColor:[UIColor lightGrayColor]];
        [containerView addSubview:educationSeparator];
        [containerView.layer renderInContext:currentContext];
        currentRect.origin.y = educationSeparator.frame.origin.y + educationSeparator.frame.size.height;
        currentRect.size.height = educationSeparator.frame.size.height;
    }
    containerView = nil;
    educationLabel = nil;

}
-(void)drawCareerObjectiveForDesignTwo:(NSMutableArray *)careerObjective
{
    self.confirmedCareerObjective = careerObjective;
    currentObjective = [self.confirmedCareerObjective objectAtIndex:0];
    // CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    // CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    NSString *objectiveTitle = @"Career Objective";
    currentRect.origin.x = sideBarRect.size.width + 20;
    currentRect.origin.y += 20;
    currentRect.size.width = self.size.width - (sideBarRect.size.width + 20);
    currentRect.size.height = 18;
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UIColor *color = [UIColor darkGrayColor];
    NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
    NSStringDrawingContext *context = [NSStringDrawingContext new];
    context.minimumScaleFactor = 0.1;
    [objectiveTitle drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
    
    NSString *objectiveString = currentObjective.careerObjective;
    
    UIFont *descriptionFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:objectiveString
     attributes:@
     {
     NSFontAttributeName: descriptionFont
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.size.width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize fontTextSize = rect.size;
    
    
    currentRect.origin.y += 20;
    currentRect.size.width = self.size.width - (sideBarRect.size.width + 40);
    currentRect.size.height = fontTextSize.height;
    
    UIColor *fontColor = [UIColor blackColor];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentJustified];
    NSDictionary*att2 = @{NSFontAttributeName: descriptionFont, NSForegroundColorAttributeName:fontColor, NSParagraphStyleAttributeName: style};
    [objectiveString drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att2 context:context];
}


-(void)drawCareerObjective:(NSMutableArray *)careerObjective
{
    self.confirmedCareerObjective = careerObjective;
    currentObjective = [self.confirmedCareerObjective objectAtIndex:0];
   // CGContextRef    currentContext = UIGraphicsGetCurrentContext();
   // CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    NSString *objectiveTitle = @"Professional Objective";
    
    switch (designNumber) {
        case 1:
        {
            currentRect.origin.x = 20;
            currentRect.origin.y = (self.size.height / 3.5) + 10;
            currentRect.size.width = (self.size.width / 2) - 40;
            currentRect.size.height = 18;
        }
            break;
        case 3:
        {
            
        }
            break;
        default:
            break;
    }
    
    
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    UIColor *color = [UIColor darkGrayColor];
    NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
    NSStringDrawingContext *context = [NSStringDrawingContext new];
    context.minimumScaleFactor = 0.1;
    [objectiveTitle drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
   
    NSString *objectiveString = currentObjective.careerObjective;
    
    UIFont *descriptionFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:objectiveString
     attributes:@
     {
     NSFontAttributeName: descriptionFont
     }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){self.size.width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize fontTextSize = rect.size;
    
   
    currentRect.origin.x = 20;
    currentRect.origin.y += 20;
    currentRect.size.width = self.size.width - 40;
    currentRect.size.height = fontTextSize.height;
   
    UIColor *fontColor = [UIColor blackColor];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentLeft];
    NSDictionary*att2 = @{NSFontAttributeName: descriptionFont, NSForegroundColorAttributeName:fontColor, NSParagraphStyleAttributeName: style};
    [objectiveString drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att2 context:context];
    
}

-(void)drawWorkExperience: (NSMutableArray *)workArray
{
    
    self.confirmedWorkHistory = workArray;
    BOOL firstColumnWork;
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    NSString *sectionTitle = @"Work Experience";
    UILabel *sectionLabel;
    UIView *containerView;
    
    
  /*  currentRect.origin.x = 20;
    currentRect.origin.y += currentRect.size.height + 20;
    currentRect.size.width = (self.size.width / 2) - 40;
    currentRect.size.height = 15;*/
    
    if (designNumber == 1) {
        if (currentRect.origin.y > 680) {
            firstColumnWork = NO;
            currentRect.origin.x = (designNumber == 1) ? ((self.size.width / 2) + 20) : (self.size.width - (sideBarRect.size.width + 20));
            currentRect.origin.y = topOrigin;
            currentRect.size.width = (self.size.width / 2) - 40;
            currentRect.size.height = 18;
        }else if (currentRect.origin.x > 200)
        {  firstColumnWork = NO;
            currentRect.origin.x = (self.size.width / 2) + 20;
            currentRect.origin.y += currentRect.size.height + 20;
            currentRect.size.width = (designNumber == 1) ? (self.size.width / 2) - 40: (self.size.width - (sideBarRect.size.width + 20));
            currentRect.size.height = 18;
            
        }else{
            firstColumnWork = YES;
            currentRect.origin.x = 20;
            currentRect.origin.y += currentRect.size.height;
            currentRect.size.width = (self.size.width / 2) - 40;
            currentRect.size.height = 18;
            
        }
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        UIColor *color = [UIColor darkGrayColor];
        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
        NSStringDrawingContext *context = [NSStringDrawingContext new];
        context.minimumScaleFactor = 0.1;
        [sectionTitle drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];

    }else if (designNumber == 2){
        currentRect.origin.x = (designNumber == 1) ? ((self.size.width / 2) + 20) : sideBarRect.size.width + 20;
        currentRect.origin.y += currentRect.size.height + 10;
        currentRect.size.width = (self.size.width - (sideBarRect.size.width + 20));
        currentRect.size.height = 18;
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        UIColor *color = [UIColor darkGrayColor];
        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
        NSStringDrawingContext *context = [NSStringDrawingContext new];
        context.minimumScaleFactor = 0.1;
        [sectionTitle drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];

    }else if (designNumber == 3){
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:sectionTitle
         attributes:@
         {
         NSFontAttributeName: font
         }];
        CGRect rectSchool = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, CGFLOAT_MAX}
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil];
        CGSize fontTextSize = rectSchool.size;
        sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(-18, currentRect.origin.y + currentRect.size.height,
                                                                  fontTextSize.width, fontTextSize.height)];
        containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, self.size.height)];
        [containerView addSubview:sectionLabel];
        [containerView setBackgroundColor:[UIColor clearColor]];
        
        [sectionLabel setFont:font];
        [sectionLabel setTextColor:[UIColor darkGrayColor]];
        [sectionLabel setText:sectionTitle];
        [sectionLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    }
    float firstOrigin = currentRect.origin.y + 30;
    BOOL firstTime = YES;
    
    for (UserWorkingHistory *work in self.confirmedWorkHistory) {
        NSString *dates;
        if ([work.lastMonth isEqualToString:@"Present"]) {
            dates   = [NSString stringWithFormat:@"%@ %@ - %@ // %@", work.firstMonth, work.firstYear , work.lastMonth, work.jobTitle];
        }else{
            dates   = [NSString stringWithFormat:@"%@ %@ - %@ %@ // %@", work.firstMonth, work.firstYear , work.lastMonth, work.lastYear, work.jobTitle];
        }
        if (designNumber == 1) {
            if (currentRect.origin.y > 680) {
                firstColumnWork = NO;
                currentRect.origin.x = (self.size.width / 2); //+ 20;
                currentRect.origin.y = topOrigin;
                currentRect.size.width = (self.size.width / 2) - 20;
                currentRect.size.height = 18;
            }else if (currentRect.origin.x > 200)
            {  firstColumnWork = NO;
                currentRect.origin.x = (self.size.width / 2) + 20;
                currentRect.origin.y += currentRect.size.height ;
                currentRect.size.width = (self.size.width / 2) - 40;
                currentRect.size.height = 18;
                
            }else{
                firstColumnWork = YES;
                currentRect.origin.x = 20;
                currentRect.origin.y += currentRect.size.height;
                currentRect.size.width = (self.size.width / 2) - 20;
                currentRect.size.height = 18;
            }
        }else if(designNumber == 2){
            currentRect.origin.x = (designNumber == 1) ? ((self.size.width / 2) + 20) : sideBarRect.size.width + 20;
            currentRect.origin.y += currentRect.size.height + 5;
            currentRect.size.width = (self.size.width - (sideBarRect.size.width + 20));
            currentRect.size.height = 18;
        }else if (designNumber == 3){
            currentRect.origin.x = containerView.frame.size.width + 10;
            if (firstTime) {
               currentRect.origin.y += currentRect.size.height - 60;
                firstTime = NO;
            }else{
                currentRect.origin.y += currentRect.size.height + 10;
            }
            currentRect.size.width =self.size.width - (self.size.width / 4);
            currentRect.size.height = 18;
        }
        
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
        UIColor *color = [UIColor blackColor];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentJustified];
        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName: style};
        NSStringDrawingContext *context = [NSStringDrawingContext new];
        context.minimumScaleFactor = 0.1;
        [dates drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
        
        NSString *workDescription =(designNumber == 3) ? [NSString stringWithFormat:@"· %@ : \n %@ \n %@", work.company, work.jobDescription, work.location] : [NSString stringWithFormat:@"· %@ : %@ \n %@", work.company, work.jobDescription, work.location];
        //NSString *majorDegree = education.majorDegree;
        //NSString *schoolLocation = education.location;
        UIFont *infoFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        UIColor *infoColor = [UIColor lightGrayColor];
        
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:workDescription
         attributes:@
         {
         NSFontAttributeName: infoFont
         }];
        CGRect rectSchool = [attributedText boundingRectWithSize:(CGSize){(self.size.width / 3), CGFLOAT_MAX}
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil];
        CGSize fontTextSize = rectSchool.size;
        if (designNumber == 1) {
            currentRect.origin.x += 20;
            currentRect.origin.y += currentRect.size.height;
            currentRect.size.width = (self.size.width / 2) - 40;
            currentRect.size.height = fontTextSize.height;
        }else{
             currentRect.origin.y += currentRect.size.height;
             currentRect.size.width = (self.size.width) -(sideBarRect.size.width- 40);
            currentRect.size.height = fontTextSize.height;
        }
        
        NSMutableParagraphStyle *infoStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [infoStyle setAlignment:NSTextAlignmentJustified];
        NSDictionary*att2 = @{NSFontAttributeName: infoFont, NSForegroundColorAttributeName:infoColor, NSParagraphStyleAttributeName: infoStyle};
        NSStringDrawingContext *contextSchool = [NSStringDrawingContext new];
        contextSchool.minimumScaleFactor = 0.1;
        
        [workDescription drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att2 context:contextSchool];
    }
    if (designNumber == 3) {
        
        UIView *workSeparator = [[UIView alloc]initWithFrame:CGRectMake(containerView.frame.size.width - 2, firstOrigin, 1, currentRect.origin.y + currentRect.size.height - firstOrigin)];
        if (sectionLabel.frame.size.height > workSeparator.frame.size.height) {
            [workSeparator setFrame:CGRectMake(containerView.frame.size.width - 2, firstOrigin, 1, sectionLabel.frame.size.height + 10)];
        }
        [workSeparator setBackgroundColor:[UIColor lightGrayColor]];
        [containerView addSubview:workSeparator];
        [containerView.layer renderInContext:currentContext];
        currentRect.origin.y = workSeparator.frame.origin.y + workSeparator.frame.size.height;
        currentRect.size.height = workSeparator.frame.size.height;
    }


}

-(void)drawSkills: (NSMutableArray *)skillsArray
{
    BOOL firstColumnSkill = NO;
    self.confirmedSkills = skillsArray;
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    NSString *sectionTitle = @"Tools / Skills";
    UILabel *sectionLabel;
    UIView *containerView;
    
   /* currentRect.origin.x = 20;
    currentRect.origin.y += currentRect.size.height + 20;
    currentRect.size.width = (self.size.width / 2) - 40;
    currentRect.size.height = 15;*/
    if (designNumber == 1) {
        if (currentRect.origin.y > 680) {
        firstColumnSkill = NO;
        currentRect.origin.x = (self.size.width / 2) + 20;
        currentRect.origin.y = topOrigin;
        currentRect.size.width = (self.size.width / 2) - 40;
        currentRect.size.height = 18;
    }else if (currentRect.origin.x > 200)
    {  firstColumnSkill = NO;
        currentRect.origin.x = (self.size.width / 2) + 20;
        currentRect.origin.y += currentRect.size.height + 20;
        currentRect.size.width = (self.size.width / 2) - 40;
        currentRect.size.height = 18;
        
    }else{
        firstColumnSkill = YES;
        currentRect.origin.x = 20;
        currentRect.origin.y += currentRect.size.height + 20;
        currentRect.size.width = (self.size.width / 2) - 40;
        currentRect.size.height = 18;
    }
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        UIColor *color = (designNumber == 1) ? [UIColor darkGrayColor]: [UIColor whiteColor];
        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
        NSStringDrawingContext *context = [NSStringDrawingContext new];
        context.minimumScaleFactor = 0.1;
        
        
        [sectionTitle drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];

    }else if (designNumber == 2){
        currentSideBarRect.origin.y += currentSideBarRect.size.height + 10;
        currentRect = currentSideBarRect;
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        UIColor *color = (designNumber == 1) ? [UIColor darkGrayColor]: [UIColor whiteColor];
        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
        NSStringDrawingContext *context = [NSStringDrawingContext new];
        context.minimumScaleFactor = 0.1;
        
        
        [sectionTitle drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];

    }else if(designNumber == 3)
    {
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:sectionTitle
         attributes:@
         {
         NSFontAttributeName: font
         }];
        CGRect rectSchool = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, CGFLOAT_MAX}
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil];
        CGSize fontTextSize = rectSchool.size;
        sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, currentRect.origin.y + 60,
                                                                fontTextSize.width, fontTextSize.height)];
        containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, self.size.height)];
        //[containerView setBackgroundColor:[UIColor yellowColor]];
        [containerView addSubview:sectionLabel];
        [containerView setBackgroundColor:[UIColor clearColor]];
        
        [sectionLabel setFont:font];
        [sectionLabel setTextColor:[UIColor darkGrayColor]];
        [sectionLabel setText:sectionTitle];
        [sectionLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
        
    }
    

    
    
    float firstOrigin = currentRect.origin.y + 20;
    BOOL firstTime = YES;
    BOOL firstColumn = TRUE;
    float firstColumnY = 0.0f;
    sectionTitleX = currentRect.origin.x;
    for (UserSkills *skill in self.confirmedSkills) {
        NSString *skillName = skill.skillName;
        if (designNumber == 1) {
            if (firstColumn){
                if (firstColumnSkill) {
                    currentRect.origin.x = 100;
                }else{
                    currentRect.origin.x = (self.size.width / 2) + 20;
                }
                currentRect.origin.y += currentRect.size.height + 10;
                firstColumnY = currentRect.origin.y;
                currentRect.size.width = 100;
                currentRect.size.height = 14;
                firstColumn = FALSE;
            }else{
                currentRect.origin.x += currentRect.size.width;
                currentRect.origin.y =firstColumnY;
                currentRect.size.width = 100;
                currentRect.size.height = 14;
                firstColumn = TRUE;
            }

        }else if (designNumber == 2){
            skillName = [NSString stringWithFormat:@"%@            %@", skill.skillName, skill.skillExperience];
            currentRect.origin.y += 20;
            currentRect.size.height = 14;
            sideBarRect = currentRect;
        }else if (designNumber == 3)
        {
            skillName = [NSString stringWithFormat:@"%@ : %@", skill.skillName, skill.skillExperience];
            currentRect.origin.x = containerView.frame.size.width + 10;
            if (firstTime) {
                currentRect.origin.y += 25;
                firstTime = NO;
            }else{
                currentRect.origin.y += currentRect.size.height;
            }
            currentRect.size.width =self.size.width - (self.size.width / 4);
            currentRect.size.height = 18;

        }
        
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        UIColor *color = (designNumber == 1 || designNumber == 3) ? [UIColor blackColor] : [UIColor whiteColor];
        if (designNumber == 3) {
            color = [UIColor darkGrayColor];
        }
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setAlignment:NSTextAlignmentLeft];
        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color, NSParagraphStyleAttributeName: style};
        NSStringDrawingContext *context = [NSStringDrawingContext new];
        context.minimumScaleFactor = 0.1;
        [skillName drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
        
        if (designNumber == 1) {
            NSString *skillExperience = [NSString stringWithFormat:@"%@ years", skill.skillExperience];
            //NSString *majorDegree = education.majorDegree;
            //NSString *schoolLocation = education.location;
            UIFont *infoFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
            UIColor *infoColor = (designNumber == 1) ? [UIColor lightGrayColor] : [UIColor whiteColor];
            
            NSAttributedString *attributedText =
            [[NSAttributedString alloc]
             initWithString:skillExperience
             attributes:@
             {
             NSFontAttributeName: infoFont
             }];
            float maxWidth = (designNumber == 1) ? (self.size.width / 3) : (currentRect.size.width - 20);
            
            CGRect rectSchool = [attributedText boundingRectWithSize:(CGSize){maxWidth, CGFLOAT_MAX}
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                             context:nil];
            CGSize fontTextSize = rectSchool.size;
            
            currentRect.origin.x = (designNumber == 1) ? (currentRect.origin.x + 20) : currentRect.origin.x + (fontTextSize.width + 5);
            currentRect.origin.y = (designNumber == 1) ? ( currentRect.origin.y + currentRect.size.height + 4) : currentRect.origin.y + 5 ;
            currentRect.size.width = (designNumber == 1) ? 100: currentRect.size.width - 20;
            currentRect.size.height = fontTextSize.height;
            
            
            
            NSMutableParagraphStyle *infoStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [infoStyle setAlignment:NSTextAlignmentLeft];
            NSDictionary*att2 = @{NSFontAttributeName: infoFont, NSForegroundColorAttributeName:infoColor, NSParagraphStyleAttributeName: infoStyle};
            NSStringDrawingContext *contextSchool = [NSStringDrawingContext new];
            contextSchool.minimumScaleFactor = 0.1;
            
            [skillExperience drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att2 context:contextSchool];
        }else if (designNumber == 3)
        {
            
        }
    }
    if (designNumber == 3) {
        UIView *skillSeparator = [[UIView alloc]initWithFrame:CGRectMake(containerView.frame.size.width - 2, firstOrigin, 1, currentRect.origin.y + currentRect.size.height - firstOrigin)];
        if (sectionLabel.frame.size.height > skillSeparator.frame.size.height) {
            [skillSeparator setFrame:CGRectMake(containerView.frame.size.width - 2, firstOrigin, 1, sectionLabel.frame.size.height + 10)];
        }
        [skillSeparator setBackgroundColor:[UIColor lightGrayColor]];
        [containerView addSubview:skillSeparator];
        [containerView.layer renderInContext:currentContext];
        currentRect.origin.y = skillSeparator.frame.origin.y + skillSeparator.frame.size.height;
        currentRect.size.height = skillSeparator.frame.size.height;
    }
}

-(void)drawOtherSection: (NSMutableArray *)otherSection
{
    self.confirmedAdditionalSections = otherSection;
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    
    
    for (UserAdditionalSection *section in self.confirmedAdditionalSections) {
        NSString *sectionTitle = section.sectionName;
        UILabel *sectionLabel;
        UIView *containerView;
        if (designNumber == 1) {
            if (currentRect.origin.y > 680) {
                currentRect.origin.x = (self.size.width / 2) + 20;
                currentRect.origin.y = topOrigin;
                currentRect.size.width = (self.size.width / 2) - 40;
                currentRect.size.height = 18;
            }else if (currentRect.origin.x > 200)
            {
                currentRect.origin.x = (self.size.width / 2) + 20;
                currentRect.origin.y += currentRect.size.height + 20;
                currentRect.size.width = (self.size.width / 2) - 40;
                currentRect.size.height = 18;
                
            }else{
                currentRect.origin.x = 20;
                currentRect.origin.y += currentRect.size.height + 20;
                currentRect.size.width = (self.size.width / 2) - 40;
                currentRect.size.height = 18;
            }
        }else if (designNumber == 2){
            currentRect = sideBarRect;
            currentRect.origin.y += currentRect.size.height + 15;
            
        }else if (designNumber == 3)
        {
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:16];
            NSAttributedString *attributedText =
            [[NSAttributedString alloc]
             initWithString:sectionTitle
             attributes:@
             {
             NSFontAttributeName: font
             }];
            CGRect rectSchool = [attributedText boundingRectWithSize:(CGSize){CGFLOAT_MAX, CGFLOAT_MAX}
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                             context:nil];
            CGSize fontTextSize = rectSchool.size;
            sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, currentRect.origin.y + 60,
                                                                    fontTextSize.width, fontTextSize.height)];
            containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, self.size.height)];
            //[containerView setBackgroundColor:[UIColor yellowColor]];
            [containerView addSubview:sectionLabel];
            [containerView setBackgroundColor:[UIColor clearColor]];
            
            [sectionLabel setFont:font];
            [sectionLabel setTextColor:[UIColor darkGrayColor]];
            [sectionLabel setText:sectionTitle];
            [sectionLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
        }
        float firstOrigin = currentRect.origin.y + 20;
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        UIColor *color = (designNumber == 1) ? [UIColor darkGrayColor] : [UIColor whiteColor];
        NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
        NSStringDrawingContext *context = [NSStringDrawingContext new];
        context.minimumScaleFactor = 0.1;
        [sectionTitle drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
       
        NSString *sectionDescription = [NSString stringWithFormat:@"%@", section.sectionDescription];
        //NSString *majorDegree = education.majorDegree;
        //NSString *schoolLocation = education.location;
        UIFont *infoFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        UIColor *infoColor = (designNumber == 1) ? [UIColor lightGrayColor] : [UIColor whiteColor];
        if (designNumber == 3) {
            infoColor = [UIColor darkGrayColor];
        }
        
        NSAttributedString *attributedText =
        [[NSAttributedString alloc]
         initWithString:sectionDescription
         attributes:@
         {
         NSFontAttributeName: infoFont
         }];
        CGRect rectSchool = [attributedText boundingRectWithSize:(CGSize){(self.size.width / 3), CGFLOAT_MAX}
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil];
        CGSize fontTextSize = rectSchool.size;
        if (designNumber == 1) {
            currentRect.origin.x += 10;
            currentRect.origin.y += currentRect.size.height;
            currentRect.size.width = (self.size.width / 2) - 40;
            currentRect.size.height = fontTextSize.height;
        }else if (designNumber == 2){
            currentRect.origin.y += currentRect.size.height + 5;
            sideBarRect = currentRect;
        }else if (designNumber == 3)
        {
            currentRect.origin.y = firstOrigin + 10;
        }
        
        NSMutableParagraphStyle *infoStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [infoStyle setAlignment:NSTextAlignmentLeft];
        NSDictionary*att2 = @{NSFontAttributeName: infoFont, NSForegroundColorAttributeName:infoColor, NSParagraphStyleAttributeName: infoStyle};
        NSStringDrawingContext *contextSchool = [NSStringDrawingContext new];
        contextSchool.minimumScaleFactor = 0.1;
        
        [sectionDescription drawWithRect:currentRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att2 context:contextSchool];
        if (designNumber == 3) {
            UIView *sectionSeparator = [[UIView alloc]initWithFrame:CGRectMake(containerView.frame.size.width - 2, firstOrigin, 1, currentRect.origin.y + currentRect.size.height - firstOrigin)];
            if (sectionLabel.frame.size.height > sectionSeparator.frame.size.height) {
                [sectionSeparator setFrame:CGRectMake(containerView.frame.size.width - 2, firstOrigin, 1, sectionLabel.frame.size.height + 10)];
            }
            [sectionSeparator setBackgroundColor:[UIColor lightGrayColor]];
            [containerView addSubview:sectionSeparator];
            [containerView.layer renderInContext:currentContext];
            currentRect.origin.y = sectionSeparator.frame.origin.y + sectionSeparator.frame.size.height;
            currentRect.size.height = sectionSeparator.frame.size.height;
        }
    }
}



-(void)drawHeader
{
    CGContextRef    currentContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
    
    NSString *textToDraw = [NSString stringWithFormat:@"%@ %@", currentInfo.firstName, currentInfo.lastName];
    
    CGRect renderingRect = CGRectMake(20, 20, 500, 50);
    UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
    
    UIColor*color = [UIColor colorWithRed:255/255.0 green:79/255.0 blue:79/255.0 alpha:1.0];
    NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
    NSStringDrawingContext *context = [NSStringDrawingContext new];
    context.minimumScaleFactor = 0.1;
    //        [textToDraw drawInRect:renderingRect withAttributes:att];
    [textToDraw drawWithRect:renderingRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:context];
}
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void) drawText
{
    /*
     for (int i = 0; i < [textArray count]; i++) {
     
     
     CGContextRef    currentContext = UIGraphicsGetCurrentContext();
     CGContextSetRGBFillColor(currentContext, 0.0, 0.0, 0.0, 1.0);
     
     NSString *textToDraw = [textArray objectAtIndex:i];
     
     
     NSLog(@"Text to draw: %@", textToDraw);
     CGRect renderingRect = [[textRectArray objectAtIndex:i]CGRectValue];
     NSLog(@"x of rect is %f",  renderingRect.origin.x);
     
     
     UIFont*font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
     
     UIColor*color = [UIColor blackColor];
     NSDictionary*att = @{NSFontAttributeName: font, NSForegroundColorAttributeName:color};
     
     
     [textToDraw drawWithRect:renderingRect options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];

     */
}

-(void)drawImage
{
    /*for (int i = 0; i < [imageArray count]; i++) {
        [[imageArray objectAtIndex:i] drawInRect:[[imageRectArray objectAtIndex:i]CGRectValue]];
        
    }*/
}

-(void)addImageWithRect:(UIImage *)image inRect:(CGRect)rect{
    UIImage *newImage = [PDFHelper imageWithImage:image scaledToSize:CGSizeMake(rect.size.width, rect.size.height)];
    
    /*
    [imageArray addObject:newImage];
    [imageRectArray addObject:[NSValue valueWithCGRect:rect]];*/
}
-(void)addTextWithRect:(NSString *)text inRect:(CGRect)rect{
   // [textArray addObject:text];
 //   [textRectArray addObject:[NSValue valueWithCGRect:rect]];
}
-(void)addHeadertWithRect:(NSString *)text inRect:(CGRect)rect{
   // [header addObject:text];
   // [headerRect addObject:[NSValue valueWithCGRect:rect]];
}

-(void)designOneBuild
{
    [self drawHeaderWithBasicInfo:self.confirmedBasicInfo];
    if ([self.confirmedCareerObjective count] > 0) {
        [self drawCareerObjective:self.confirmedCareerObjective];
    }
    if ([self.confirmedEducation count] > 0) {
        [self drawEducationSection:self.confirmedEducation];
    }
    if ([self.confirmedWorkHistory count]>0) {
        [self drawWorkExperience:self.confirmedWorkHistory];
    }
    if ([self.confirmedSkills count]>0) {
        [self drawSkills:self.confirmedSkills];
    }
    if ([self.confirmedAdditionalSections count]>0) {
        [self drawOtherSection:self.confirmedAdditionalSections];
    }
}

-(void)designTwoBuild
{
    [self drawHeaderforDesignTwoWithBasicInfo:self.confirmedBasicInfo];
    if ([self.confirmedCareerObjective count] > 0) {
        [self drawCareerObjectiveForDesignTwo:self.confirmedCareerObjective];
    }
    if ([self.confirmedEducation count] > 0) {
        [self drawEducationSectionForDesignTwo:self.confirmedEducation];
    }
    if ([self.confirmedWorkHistory count]>0) {
         [self drawWorkExperience:self.confirmedWorkHistory];
    }
    if ([self.confirmedSkills count]>0) {
        [self drawSkills:self.confirmedSkills];
    }
    if ([self.confirmedAdditionalSections count]>0) {
        [self drawOtherSection:self.confirmedAdditionalSections];
    }
    
    
}


-(void)designThreeBuild
{
    [self drawHeaderWithBasicInfo:self.confirmedBasicInfo];
    if (self.confirmedEducation) {
        [self drawEducationSection:self.confirmedEducation];
    }
    if (self.confirmedWorkHistory) {
        [self drawWorkExperience:self.confirmedWorkHistory];
    }
    if (self.confirmedSkills) {
        [self drawSkills:self.confirmedSkills];
    }
    if (self.confirmedAdditionalSections) {
        [self drawOtherSection:self.confirmedAdditionalSections];
    }
}


- (NSMutableData*) generatePdfWithFilePath: (NSString *)thefilePath withSuccess: (PdfSuccess)pdfFile
{
    
    UIGraphicsBeginPDFContextToFile(thefilePath, CGRectZero, nil);
   
    
    BOOL done = NO;
    do
    {
        //Start a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, _size.width, _size.height), nil);
        
        switch (designNumber) {
            case 1:
                [self designOneBuild];
                break;
            case 2:
                [self designTwoBuild];
                break;
            case 3:
                [self designThreeBuild];
                break;
            default:
                break;
        }
        
        done = YES;
    }
    while (!done);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    
    
    //For data
    UIGraphicsBeginPDFContextToData(_data, CGRectZero, nil);
    
    
    BOOL done1 = NO;
    do
    {
        //Start a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, _size.width, _size.height), nil);
        switch (designNumber) {
            case 1:
                [self designOneBuild];
                break;
            case 2:
                [self designTwoBuild];
                break;
            case 3:
                [self designThreeBuild];
                break;
            default:
                break;
        }
        done1 = YES;
    }
    while (!done1);
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    pdfFile(_data);
    return _data;
}

@end
