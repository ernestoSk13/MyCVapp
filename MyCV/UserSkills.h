//
//  UserSkills.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 27/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserSkills : NSManagedObject

@property (nonatomic, retain) NSString * skillName;
@property (nonatomic, retain) NSString * skillExperience;

@end
