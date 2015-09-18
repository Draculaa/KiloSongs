//
//  TableViewController.m
//  HomeWork21(Nib)
//
//  Created by Евгений on 21.08.15.
//  Copyright (c) 2015 Eugene Kirtaev. All rights reserved.
//

#import "SongsTableViewController.h"
#import "SongTableViewCell.h"


static NSString * cellIdentifier = @"SongCell";

@implementation SongsTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    self.netManager = [EKNetManager new];
    self.dataManager = [ EKDataManager new];
    self.managedObjectContext = self.dataManager.managedObjectContext;
    [self.dataManager deleteObjects];
    __weak typeof(EKDataManager *) wDataManager = self.dataManager;
    __weak typeof(self) wSelf = self;
    self.changeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:SongDidCompleteNotification
                                                                            object:self.netManager
                                                                             queue:[NSOperationQueue mainQueue]
                                                                        usingBlock:^(NSNotification *note) {
                                                                            
                                                                            wSelf.objects = [wDataManager addDataWithArray:note.userInfo[SongDidCompleteNotificationUserInfoKey]];
                                                                            NSLog(@"%@", wSelf.objects);
                                                                            [wSelf.tableView reloadData];
                                                                        }];
    [self.netManager downloadSongs];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"KiloSongs";
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl = self.refreshControl;
    [self.refreshControl addTarget:self action:@selector(refresh:)
                  forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(performAdd:)];
}
- (void)performAdd:(id)paramSender{
    [self.netManager cancel];
    [self.netManager downloadSongs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"CoreDataSong"
                inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:description];
    
    NSSortDescriptor* nameDescription =
    [[NSSortDescriptor alloc] initWithKey:@"author" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[nameDescription]];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(SongTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    CoreDataSong *song = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textLabel.text = [NSString stringWithFormat:@"%@", song.author];
    cell.songLabel.text = [NSString stringWithFormat:@"%@", song.label];
    
}

#pragma mark - UITableViewDelegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

- (SongTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[SongTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

-(void)refresh:(UIRefreshControl *)sender{
    [self.netManager cancel];
    [self.netManager downloadSongs];
}

@end
