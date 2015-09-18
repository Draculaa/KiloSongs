//
//  CoreDataSong.h
//  new
//
//  Created by Евгений on 17.09.15.
//  Copyright (c) 2015 Eugene Kirtaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CoreDataSong : NSManagedObject

@property (nonatomic, retain) NSNumber * songId;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * author;

@end
