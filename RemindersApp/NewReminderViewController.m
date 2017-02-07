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
#import "PhotoManager.h"

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
    Reminder *reminder = [[Reminder alloc]initWithTitle:self.reminderTitle.text Body:self.reminderDetails.text Image:self.reminderImage.image displayFrequency:[self.timesPerDayLabel.text integerValue] uniqueID:@"FirstID" hasImage:NO];
    
    [self.remindManager.remindersArray addObject:reminder];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)reminderTimesPerDay:(UIStepper *)sender {
    self.timesPerDayLabel.text = @(sender.value).stringValue;
}

- (IBAction)cancelReminder:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)takePhoto:(UIButton *)sender {
    
}

- (IBAction)chooseFromLibrary:(UIButton *)sender {
    
}

- (IBAction)onlinePhoto:(UIButton *)sender {
    
}


@end
