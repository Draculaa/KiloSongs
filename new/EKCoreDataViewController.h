//
//  ASCoreDataViewController.h
//  CoreDataTest
//
//  Created by Oleksii Skutarenko on 13.02.14.
//  Copyright (c) 2014 Alex Skutarenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface EKCoreDataViewController : UITableViewController 
<NSFetchedResultsControllerDelegate>



@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
