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

@interface NewReminderViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
    UIImage *image = self.reminderImage.image;
    
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
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)chooseFromLibrary:(UIButton *)sender {
    UIImagePickerController *picker2 = [[UIImagePickerController alloc]init];
    picker2.delegate = self;
    [picker2 setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker2 animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [[UIImage alloc]init];
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.reminderImage setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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
