//
//  DetailViewController.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-06.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "DetailViewController.h"
#import "Reminder.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailDetails;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;

@property (strong, nonatomic) Reminder *reminder;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  self.detailTitle.text = self.reminder.title;
  //  self.detailDetails.text = self.reminder.details;
  //  self.detailImage.image = self.reminder.image;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayDetailView:(Reminder*)reminder {
    if (_reminder != reminder) {
        _reminder = reminder;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
