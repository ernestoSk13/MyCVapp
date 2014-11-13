//
//  MyCVCoreDataHelper.h
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 05/11/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MyCVSections.h"
typedef void (^SavedContexSuccess)(NSString *successString);
typedef void (^SavedContextError)(NSString *errorString, NSDictionary *errorDict);
@interface MyCVCoreDataHelper : NSObject
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@property (nonatomic, retain) NSArray *itemsInDB;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
//@property (nonatomic, readonly) NSPersistentStore            *store;

//-(void)initDB;
+(MyCVCoreDataHelper *)sharedModelHelper;
-(NSArray *)getInfoForItem:(NSString *)itemName;
-(void)setNewUser:(NSDictionary *)params withSuccess:(SavedContexSuccess)success orError:(SavedContextError)saveError;;
-(void)setUpCoreData;
- (void)saveContextWithSuccess:(SavedContexSuccess)success orError:(SavedContextError)saveError;

//Single Instances
-(UserInfo *)savedUserInfo;

@end
