//
//  MyCVAppDelegate.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 05/08/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface MyCVAppDelegate : UIResponder <UIApplicationDelegate>
{
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;

-(NSArray*)getUserInfo;
-(NSArray*)getUserEducation;
-(NSArray*)getUserCareerObjective;
-(NSArray*)getUserWorkingHistory;
-(NSArray*)getUserSkills;
-(NSArray*)getUserCustomSections;
@end
