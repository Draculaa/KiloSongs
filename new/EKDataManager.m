//
//  EKDataManager.m
//  HomeWork21(Nib)
//
//  Created by Евгений on 21.08.15.
//  Copyright (c) 2015 Eugene Kirtaev. All rights reserved.
//

#import "EKDataManager.h"
#import "Song.h"

@implementation EKDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (EKDataManager*) sharedManager {
    
    static EKDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EKDataManager alloc] init];
    });
    return manager;
}
-(void)createData {
        
    [self printArray:[self allObjects]];
}
-(NSArray *)getSavedSongsWithObjects:(NSMutableArray *)objects{
    [self createDataWithArray:objects];
    return [self allObjects];
}

- (CoreDataSong *)addCoreDataSongWithSong:(Song *) song{
    
    CoreDataSong *cdSong = [self CoreDataSongWithSong:song];
    cdSong = [NSEntityDescription insertNewObjectForEntityForName:@"CoreDataSong"
                                           inManagedObjectContext:self.managedObjectContext];
    return cdSong;
}

- (CoreDataSong *)CoreDataSongWithSong:(Song *) song{
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CoreDataSong" inManagedObjectContext:self.managedObjectContext];
    
    CoreDataSong *cdSong = [[CoreDataSong alloc]initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
    
    cdSong.songId = song.songId;
    cdSong.version = song.version;
    cdSong.author = song.author;
    cdSong.label = song.label;
    
    return cdSong;
}

- (NSArray *)addDataWithArray:(NSArray *)array{
    
    NSError *error = nil;
    NSMutableArray * newData = [self DataWithArray:array];
    
    for (CoreDataSong* cdSong in [self allObjects]) {
        if (![newData containsObject:cdSong]) {
            [self.managedObjectContext deleteObject:cdSong];
        }
    }
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    for (CoreDataSong* cdSong in newData) {
        if (![[self allObjects] containsObject:cdSong]) {
            [self.managedObjectContext insertObject:cdSong];
        }
    }
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [self printArray:[self allObjects]];
    return [self allObjects];
}

- (NSMutableArray *)DataWithArray:(NSArray *)array{
    NSMutableArray * data = [NSMutableArray new];
    for (Song * song in array) {
        CoreDataSong * cdSong = [self CoreDataSongWithSong:song];
        [data addObject:cdSong];
    }
    return data;
}

- (void)createDataWithArray:(NSMutableArray *)array{
    
    NSError *error = nil;
   
    for (Song * song in array) {
        CoreDataSong * cdSong = [self addCoreDataSongWithSong:song];
    }
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    [self printArray:[self allObjects]];
}

- (NSArray*) allObjects {
        
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription* description =
        [NSEntityDescription entityForName:@"CoreDataSong"
                    inManagedObjectContext:self.managedObjectContext];
        
        [request setEntity:description];
        
        NSError* requestError = nil;
        NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
        if (requestError) {
            NSLog(@"%@", [requestError localizedDescription]);
        }
        return resultArray;
}
    
- (void) printArray:(NSArray*) array {
        
        for (id object in array) {
            
            if ([object isKindOfClass:[CoreDataSong class]]) {
                
                CoreDataSong* song = (CoreDataSong*) object;
                NSLog(@"Song: %d, %d, %@, %@", song.songId, song.version, song.label, song.author);
            }
        }
        
        NSLog(@"COUNT = %lu", (unsigned long)[array count]);
}

-(void)deleteObjects{
    NSArray* allObjets = [self allObjects];
    for (id object in allObjets) {
        [self.managedObjectContext deleteObject:object];
    }
    
    NSError* saveError = nil;
    if ([self.managedObjectContext save:&saveError])
    {
        NSLog(@"Succes");
    }else{
        NSLog(@"Fail: %@", saveError);
    }
}    

#pragma mark - Core Data stack



- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Eugene-Kirtaev.HomeWork21_Nib_" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"new" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"new.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
