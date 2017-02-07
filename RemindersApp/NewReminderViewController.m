//
//  NewReminderViewController.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-06.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "NewReminderViewController.h"
#import "Reminder.h"
#import "ReminderManager.h"

@interface NewReminderViewController ()

@property (weak, nonatomic) IBOutlet UITextField *reminderTitle;
@property (weak, nonatomic) IBOutlet UITextField *reminderDetails;
@property (weak, nonatomic) IBOutlet UIImageView *reminderImage;
@property (weak, nonatomic) IBOutlet UILabel *timesPerDayLabel;
@property (strong, nonatomic) ReminderManager *manager;

@end

@implementation NewReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [ReminderManager new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newReminder:(UIBarButtonItem *)sender {
    Reminder *reminder = [[Reminder alloc]initWithTitle:self.reminderTitle.text Body:self.reminderDetails.text Image:self.reminderImage.image displayFrequency:[self.timesPerDayLabel.text integerValue] uniqueID:@"FirstID" hasImage:NO];
    
    [self.manager.remindersArray addObject:reminder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)reminderTimesPerDay:(UIStepper *)sender {
    self.timesPerDayLabel.text = @(sender.value).stringValue;
}

- (IBAction)cancelReminder:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
