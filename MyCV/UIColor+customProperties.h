//
//  UIColor+customProperties.h
//  FootballGameApp
//
//  Created by Ernesto Sánchez Kuri on 07/08/14.
//  Copyright (c) 2014 Ernesto Sánchez Kuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (customProperties)
+(UIColor*)colorWithHexString:(NSString*)hex;
+(UIColor*)containerViewColor;
@end
