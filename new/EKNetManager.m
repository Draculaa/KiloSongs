//
//  NetManager.m
//  HomeWork41
//
//  Created by Евгений on 06.09.15.
//  Copyright (c) 2015 Eugene Kirtaev. All rights reserved.
//

#import "EKNetManager.h"
#import "Song.h"


NSString* const SongDidCompleteNotification             = @"SongDidCompleteNotification";
NSString* const SongDidCompleteNotificationUserInfoKey  = @"SongDidCompleteNotificationUserInfoKey";

NSString* const kUrlSongs = @"http://kilograpp.com:8080/songs/api/songs";

@implementation EKNetManager

+ (EKNetManager *)sharedManager{
    
    static EKNetManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EKNetManager alloc]init];
    });
    return manager;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}
#pragma mark - Download

-(void)downloadSongs{
    __weak typeof(self) wSelf = self;
    self.dataTask = [self searchWebcompletionHandler:^(NSArray *objects) {
                      [[NSNotificationCenter defaultCenter]postNotificationName:SongDidCompleteNotification
                                                                         object:wSelf
                                                                       userInfo:@{SongDidCompleteNotificationUserInfoKey: objects}];
                  }];
    
}

-(NSURLSessionDataTask *)searchWebcompletionHandler:(void(^)(NSArray *objects))handler{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kUrlSongs]];
    NSURLSessionDataTask* task = [self.session dataTaskWithRequest:request
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        id responseObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                            options:0
                                                                                              error:nil];
                                        NSMutableArray * objects = [NSMutableArray new];
                                        NSArray * songs = responseObject;
                                        for (NSDictionary *songDesc in songs) {
                                            Song * song = [Song new];
                                            song.songId = songDesc[@"id"];
                                            song.version = songDesc[@"version"];
                                            song.label = songDesc[@"label"];
                                            song.author = songDesc[@"author"];
                                            
                                            [objects addObject:song];
                                        }
                                        handler(objects);
                                        NSLog(@"%@", responseObject);
                                    }];
    [task resume];
    return task;
}

- (void)cancel{
    [self.dataTask cancel];
}

-(BOOL)isLoading{
    return self.dataTask && self.dataTask.state == NSURLSessionTaskStateRunning;
}
@end