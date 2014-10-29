//
//  MyCUtilities.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 15/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVUtilities.h"

@implementation MyCVUtilities
+(id)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
        
    });
    
    // returns the same object each time
    return _sharedObject;
}
@end
