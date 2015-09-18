//
//  EKDataManager.h
//  HomeWork21(Nib)
//
//  Created by Евгений on 21.08.15.
//  Copyright (c) 2015 Eugene Kirtaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataSong.h"

@interface EKDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property NSMutableArray* objects;

+ (EKDataManager*)sharedManager;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) createData;
- (NSArray*) allObjects;
- (void) deleteObjects;
- (void) printArray:(NSArray*) array;
- (void) createDataWithArray:(NSMutableArray *) array;
- (NSArray *) getSavedSongsWithObjects:(NSMutableArray *)objects;
- (NSArray *)addDataWithArray:(NSArray *)array;

@end