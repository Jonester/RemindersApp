//
//  MasterTableViewController.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-06.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "MasterTableViewController.h"
#import "ReminderManager.h"
#import "NewReminderViewController.h"
#import "AppDelegate.h"
#import "ReminderTableViewCell.h"

@interface MasterTableViewController () <NewReminderViewControllerDelegate>

//@property (strong, nonatomic) ReminderManager *manager;
@end

@implementation MasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.manager = [ReminderManager new];
    [super viewDidLoad];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self getContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminders" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    self.remindersArray = fetchedObjects;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addreminder"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        NewReminderViewController *newReminderViewController = [navigationController viewControllers][0];
        newReminderViewController.delegate = self;
    }
  
}
-(void)newReminderViewControllerDidCancel:(Reminders *)reminderToDelete {
    NSManagedObjectContext *context = [self getContext];
    [context deleteObject:reminderToDelete];
    
     [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)newReminderViewControllerDidAdd {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self getContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminders" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"error: %@", error.localizedDescription);
    }
    self.remindersArray = fetchedObjects;
    
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
