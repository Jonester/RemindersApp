//
//  MasterTableViewController.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-06.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "MasterTableViewController.h"
#import "NewReminderViewController.h"
#import "AppDelegate.h"
#import "ReminderTableViewCell.h"
#import "DetailViewController.h"

//Notifcations
#import "NotificationsManager.h"

@import UserNotifications;
@interface MasterTableViewController () <NewReminderViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *context;

- (NSManagedObjectContext *)getContext;

@end

@implementation MasterTableViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [NotificationsManager SetupAndAskUserPermissions];

    
    [super viewDidLoad];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    self.context = [self getContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminders" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    self.remindersArray = [fetchedObjects mutableCopy];
    
    [self.tableView reloadData];
}



-(void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.remindersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReminderTableViewCell *cell = (ReminderTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Reminders *object = self.remindersArray[indexPath.row];
    cell.titleLabel.text = object.title;
    cell.detailsLabel.text = object.details;
    cell.imageThumbnail.image = [UIImage imageWithData:object.image];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.context deleteObject:self.remindersArray[indexPath.row]];
        [self.remindersArray removeObjectAtIndex:indexPath.row];
        [[self appDelegate] saveContext];
        
        [tableView reloadData];
    }
}

#pragma Segue


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addreminder"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        NewReminderViewController *newReminderViewController = [navigationController viewControllers][0];
        newReminderViewController.delegate = self;
    }
    if ([segue.identifier isEqualToString:@"DetailViewController"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Reminder *reminder = self.remindersArray[indexPath.row];
        UINavigationController *nav = segue.destinationViewController;
        DetailViewController *dvc = nav.viewControllers[0];
        [dvc displayDetailView:reminder];
    }
}

-(void)newReminderViewControllerDidCancel:(Reminders *)reminderToDelete {
    self.context = [self getContext];
    [self.context deleteObject:reminderToDelete];
    
     [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)newReminderViewControllerDidAdd {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    self.context = [self getContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminders" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    self.remindersArray = [fetchedObjects mutableCopy];
    
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSManagedObjectContext *)getContext {
    return [self getContainer].viewContext;
}

- (NSPersistentContainer *)getContainer{
    return [self appDelegate].persistentContainer;
}

- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
