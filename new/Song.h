//
//  Song.h
//  new
//
//  Created by Евгений on 15.09.15.
//  Copyright (c) 2015 Eugene Kirtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property(nonatomic)NSNumber* songId;
@property(nonatomic)NSNumber* version;
@property(copy, nonatomic)NSString* label;
@property(copy, nonatomic)NSString* author;

@end
