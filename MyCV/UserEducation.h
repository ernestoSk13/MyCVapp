//
//  UserEducation.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 24/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserEducation : NSManagedObject

@property (nonatomic, retain) NSString * degree;
@property (nonatomic, retain) NSString * firstMonth;
@property (nonatomic, retain) NSString * firstYear;
@property (nonatomic, retain) NSString * lastMonth;
@property (nonatomic, retain) NSString * lastYear;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * majorDegree;
@property (nonatomic, retain) NSString * schoolName;

@end
