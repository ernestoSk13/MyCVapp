//
//  MyCVCoreDataHelper.m
//  MyCV
//
//  Created by Ernesto Sánchez Kuri on 05/11/14.
//  Copyright (c) 2014 SK Labs. All rights reserved.
//

#import "MyCVCoreDataHelper.h"
#import "MyCVSections.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

static MyCVCoreDataHelper *_sharedHelper;

@implementation MyCVCoreDataHelper
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(MyCVCoreDataHelper *)sharedModelHelper
{
    if (!_sharedHelper) {
        _sharedHelper = [[MyCVCoreDataHelper alloc]init];
    }
    return _sharedHelper;
}


-(void)setUpCoreData
{
    self.itemsInDB = @[@"UserInfo",
                       @"UserEducation",
                       @"UserWorkingHistory",
                       @"UserCareerObjective",
                       @"UserSkills",
                       @"UserAdditionalSection"];
    
}

-(NSArray *)getInfoForItem:(NSString *)itemName
{
    // initializing NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Setting Entity to be Queried
    NSEntityDescription *entity = [NSEntityDescription entityForName:itemName
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    
    // Query on managedObjectContext With Generated fetchRequest
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Returning Fetched Records
    return fetchedRecords;
}

- (NSManagedObjectContext *) managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"DataModel.sqlite"]];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return _persistentStoreCoordinator;
}
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (id)singleInstanceOf:(NSString *)entityName where:(NSString *)condition isEqualTo:(id)value
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Error: Couldn't fetch: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:entityName
                                               inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // If 'condition' is not nil, limit results to that condition
    if (condition && value)
    {
        NSPredicate *pred;
        if([value isKindOfClass:[NSManagedObject class]])
        {
            value = [((NSManagedObject *)value) objectID];
            pred = [NSPredicate predicateWithFormat:@"(%@ = %@)", condition, value];
        } else if ([value isKindOfClass:[NSString class]])
        {
            NSString *format  = [NSString stringWithFormat:@"%@ LIKE '%@'", condition, value];
            pred = [NSPredicate predicateWithFormat:format];
        } else {
            NSString *format  = [NSString stringWithFormat:@"%@ == %@", condition, value];
            pred = [NSPredicate predicateWithFormat:format];
        }
        [fetchRequest setPredicate:pred];
    }
    [fetchRequest setFetchLimit:1];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest
                                                     error:&error];
    
    return [fetchedObjects count] > 0 ? [fetchedObjects objectAtIndex:0] : nil;
}

- (NSArray *)allInstancesOf:(NSString *)entityName
                      where:(NSString *)condition
                  isEqualto:(id)value
                  orderedBy:(NSString *)property
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    if (![context save:&error])
    {
        NSLog(@"Error: Couldn't fetch: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity  = [NSEntityDescription entityForName:entityName
                                               inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // If 'condition' is not nil, limit results to that condition
    if (condition && value)
    {
        NSPredicate *pred;
        if([value isKindOfClass:[NSManagedObject class]])
        {
            value = [((NSManagedObject *)value) objectID];
            pred = [NSPredicate predicateWithFormat:@"%@ == %@", condition, value];
        } else {
            NSString *format  = [NSString stringWithFormat:@"%@ == %@", condition, value];
            pred = [NSPredicate predicateWithFormat:format];
        }
        [fetchRequest setPredicate:pred];
    }
    
    // If 'property' is not nil, have the results sorted
    if (property)
    {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:property
                                                           ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:sd];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest
                                                     error:&error];
    
    return fetchedObjects;
}
//Basic Info
-(void)setNewUser:(NSDictionary *)params withSuccess:(SavedContexSuccess)success orError:(SavedContextError)saveError
{
    
    NSString *userId = [params objectForKey:@"userId"];
    
    UserInfo *userInfo = [self singleInstanceOf:@"UserInfo" where:@"userId" isEqualTo:userId];
    
    NSArray *oldInfo = [self allInstancesOf:@"UserInfo" where:@"UserInfo.userId" isEqualto:userInfo.userId orderedBy:nil];
    
    for (UserInfo *data in oldInfo) {
        [self deleteEntity:data];
    }
    
    UserInfo *newUser = [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:[self managedObjectContext]];
    
    newUser.userId = userId;
    newUser.firstName = [params objectForKey:@"firstName"];
    newUser.lastName = [params objectForKey:@"lastName"];
    newUser.country = [params objectForKey:@"country"];
    newUser.mobile = [params objectForKey:@"mobile"];
    newUser.email = [params objectForKey:@"email"];
    newUser.degree = [params objectForKey:@"degree"];
    newUser.profilePicUrl = [params objectForKey:@"profilePicUrl"];
    newUser.zipcode = [params objectForKey:@"zipcode"];
    newUser.address = [params objectForKey:@"address"];
    newUser.birthdate = [params objectForKey:@"birthdate"];
    newUser.city = [params objectForKey:@"city"];
    
    
    [self saveContextWithSuccess:^(NSString *successString) {
        success(successString);
    } orError:^(NSString *errorString, NSDictionary *errorDict) {
        saveError(errorString, errorDict);
    }];
}
-(UserInfo *)savedUserInfo
{
    UserInfo *savedData = [_sharedHelper singleInstanceOf:@"UserInfo" where:nil isEqualTo:nil];
    return savedData;
}
//UserEducation
-(void)setNewUserEducation:(NSDictionary *)params withSuccess:(SavedContexSuccess)success orError:(SavedContextError)saveError
{
    NSManagedObjectContext *context = [self managedObjectContext];
    UserEducation *education = [NSEntityDescription insertNewObjectForEntityForName:@"UserEducation" inManagedObjectContext:context];
    education.majorDegree   = [params objectForKey:@"majorDegree"];
    education.schoolName    = [params objectForKey:@"schoolName"];
    education.location      = [params objectForKey:@"location"];
    education.firstMonth    = [params objectForKey:@"firstMonth"];
    education.firstYear     = [params objectForKey:@"firstYear"];
    education.lastMonth     = [params objectForKey:@"lastMonth"];
    if ([education.lastMonth isEqualToString:@"Present"]) {
        education.lastYear  = @"";
    }else{
        education.lastYear  = [params objectForKey:@"lastYear"];
    }
    education.degree        = [params objectForKey:@"degree"];;
    
    
    [self saveContextWithSuccess:^(NSString *successString) {
        success(successString);
    } orError:^(NSString *errorString, NSDictionary *errorDict) {
        saveError(errorString, errorDict);
    }];

}

-(void)updateEducation:(NSDictionary *)params forManagedObject: (NSManagedObject *)mObject withSuccess:(SavedContexSuccess)success onError:(SavedContextError)saveError
{
    
}

-(UserEducation *)savedUserEducation
{
    UserEducation *savedData = [_sharedHelper singleInstanceOf:@"UserEducation" where:nil isEqualTo:nil];
    return savedData;
}



- (void)deleteEntity:(NSManagedObject *)entity
{
    [_managedObjectContext deleteObject:entity];
    [self saveContextWithSuccess:^(NSString *successString) {
        
    } orError:^(NSString *errorString, NSDictionary *errorDict) {
        
    }];
}
- (void)saveContextWithSuccess:(SavedContexSuccess)success orError:(SavedContextError)saveError
{
    NSError *error = nil;
    NSManagedObjectContext *context = _managedObjectContext;
    if (context != nil)
    {
        if ([context hasChanges] && ![context save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            saveError(error.description, [error userInfo]);
            abort();
        }
    }
    success(@"saved successfully");
}

@end
