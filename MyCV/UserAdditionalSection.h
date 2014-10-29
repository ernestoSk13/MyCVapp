//
//  UserAdditionalSection.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 28/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserAdditionalSection : NSManagedObject

@property (nonatomic, retain) NSString * sectionName;
@property (nonatomic, retain) NSString * sectionDescription;

@end
