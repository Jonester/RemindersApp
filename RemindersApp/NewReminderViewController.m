//
//  NewReminderViewController.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-06.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "NewReminderViewController.h"
#import "ReminderManager.h"
#import "PhotoManager.h"
#import "AppDelegate.h"

@interface NewReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *reminderTitle;
@property (weak, nonatomic) IBOutlet UITextField *reminderDetails;
@property (weak, nonatomic) IBOutlet UIImageView *reminderImage;
@property (weak, nonatomic) IBOutlet UILabel *timesPerDayLabel;
@property (strong, nonatomic) ReminderManager *remindManager;
@property (strong, nonatomic) PhotoManager *photoManager;

@end

@implementation NewReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.remindManager = [ReminderManager new];
    self.photoManager = [PhotoManager new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newReminder:(UIBarButtonItem *)sender {
    NSString *title = self.reminderTitle.text;
    UIImage *image = [UIImage imageNamed:@"front"];
  
    
    [self.remindManager.remindersArray addObject:reminder];
    NSString *details = self.reminderDetails.text;
    NSInteger displayFrequency = self.timesPerDayLabel.text.integerValue;
    
    NSManagedObjectContext *context = [self getContext];
    Reminders *reminders = [NSEntityDescription insertNewObjectForEntityForName:@"Reminders" inManagedObjectContext:context];
    reminders.title = title;
    reminders.details = details;
    reminders.uniqueID = [[NSUUID UUID] UUIDString];
    reminders.displayFrequency = displayFrequency;
    reminders.image = UIImagePNGRepresentation(image);
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Save Failed: %@", error.localizedDescription);
    }
    [self.delegate newReminderViewControllerDidAdd];
}

- (IBAction)reminderTimesPerDay:(UIStepper *)sender {
    self.timesPerDayLabel.text = @(sender.value).stringValue;
}

- (IBAction)cancelReminder:(UIBarButtonItem *)sender {
   [self.delegate newReminderViewControllerDidCancel:[self reminders]];    
   
}

- (IBAction)takePhoto:(UIButton *)sender {
    
}

- (IBAction)chooseFromLibrary:(UIButton *)sender {
    
}

- (IBAction)onlinePhoto:(UIButton *)sender {
    
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
