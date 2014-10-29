//
//  MyCUtilities.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 15/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyCVHomeControllerViewController.h"
#import "MyCVViewController.h"
#import "MenuController.h"
@interface MyCVUtilities : NSObject
+(id)sharedInstance;
@property(nonatomic, strong)MyCVHomeControllerViewController *homeVCObject;
@property(nonatomic, strong)MyCVViewController *viewControllerObject;
@property (nonatomic, strong)NSMutableArray *basicInfoArray;
@property (nonatomic, strong)NSMutableArray *educationArray;
@end
