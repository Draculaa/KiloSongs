//
//  NetManager.h
//  HomeWork41
//
//  Created by Евгений on 06.09.15.
//  Copyright (c) 2015 Eugene Kirtaev. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const SongDidCompleteNotification;
extern NSString* const SongDidCompleteNotificationUserInfoKey;


@interface EKNetManager : NSObject

@property (strong, nonatomic) NSURLSession* session;
@property (strong, nonatomic) NSURLSessionDataTask* dataTask;

+ (EKNetManager* )sharedManager;
- (void)cancel;
- (BOOL)isLoading;
- (void)downloadSongs;


@end
