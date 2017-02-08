//
//  DetailViewController.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-06.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "DetailViewController.h"
#import "Reminders+CoreDataClass.h"
#import "Reminders+CoreDataProperties.h"
#import "MasterTableViewController.h"
#import "AppDelegate.h"
#import "NewReminderViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailDetails;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;

@property (strong, nonatomic) Reminders *reminder;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailTitle.text = self.reminder.title;
    self.detailDetails.text = self.reminder.details;
    self.detailImage.image = [UIImage imageWithData:self.reminder.image];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayDetailView:(Reminders*)reminder {
    if (_reminder != reminder) {
        _reminder = reminder;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"NewReminderViewController"])  {
        NewReminderViewController *nrvc = [segue destinationViewController];
        nrvc.reminder = self.reminder;
    }
}
- (IBAction)backButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
