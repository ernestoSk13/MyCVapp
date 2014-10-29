//
//  UserInfo.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 15/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserInfo : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * degree;
@property (nonatomic, retain) NSString * birthdate;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * profilePicUrl;

@end
