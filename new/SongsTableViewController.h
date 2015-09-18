//
//  TableViewController.h
//  HomeWork21(Nib)
//
//  Created by Евгений on 21.08.15.
//  Copyright (c) 2015 Eugene Kirtaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKCoreDataViewController.h"
#import "EKDataManager.h"
#import "EKNetManager.h"

@interface SongsTableViewController : EKCoreDataViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) EKDataManager *dataManager;
@property (strong, nonatomic) EKNetManager *netManager;
@property (strong, nonatomic) id changeObserver;
- (IBAction)refresh:(UIRefreshControl *)sender;

@property NSArray* objects;



@end
