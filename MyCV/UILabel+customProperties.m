//
//  UILabel+customProperties.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 12/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "UILabel+customProperties.h"

@implementation UILabel (customProperties)
-(void)primaryTextForNames
{
    [self setFont:[UIFont fontWithName:@"Helvetica-Light" size:14.0f]];
    [self setTextColor:[UIColor whiteColor]];
    
}
-(void)primaryTextForTitles
{
    [self setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];
    [self setTextColor:[UIColor whiteColor]];
}

@end
