//
//  UserWorkingHistory.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 26/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserWorkingHistory : NSManagedObject

@property (nonatomic, retain) NSString * jobTitle;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * firstMonth;
@property (nonatomic, retain) NSString * firstYear;
@property (nonatomic, retain) NSString * lastMonth;
@property (nonatomic, retain) NSString * lastYear;
@property (nonatomic, retain) NSString * jobDescription;

@end
