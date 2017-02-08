//
//  NewReminderViewController.m
//  RemindersApp



#import "NewReminderViewController.h"
#import "AppDelegate.h"


@interface NewReminderViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *reminderTitle;
@property (weak, nonatomic) IBOutlet UITextField *reminderDetails;
@property (weak, nonatomic) IBOutlet UIImageView *reminderImage;
@property (weak, nonatomic) IBOutlet UILabel *timesPerDayLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTime;

@property (nonatomic) NSMutableArray *remindersIDArray;

@end

@implementation NewReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self displayReminderForEdit:self.reminder];
    
    // Set Date Picker Time Zone
    self.startTime.timeZone = [NSTimeZone defaultTimeZone];
    self.endTime.timeZone = [NSTimeZone defaultTimeZone];
    
    // Set initial value for Display
    self.timesPerDayLabel.text = @"5";
    
}



- (IBAction)newReminder:(UIBarButtonItem *)sender {
    
    if (self.reminder != nil) {
        
        self.reminder.title = self.reminderTitle.text;
        self.reminder.details = self.reminderDetails.text;
        self.reminder.image = [NSData dataWithData:UIImagePNGRepresentation(self.reminderImage.image)];
    } else {
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
        
// ADD NOTIFICATIONS
        
        
         NotificationsManager *notificationsManager = [NotificationsManager new];
        
        // Build randomTimes Array
        
        
        
        NSInteger timesPerDay = [self.timesPerDayLabel.text intValue];
        
        NSDate *startTime = self.startTime.date;
        NSDate *endTime = self.endTime.date;
        NSArray *randomTimesArray = [notificationsManager generateArrayOfRandomTimes:startTime toTime:endTime numberOfReminders:timesPerDay];
        
        
        // Schedule Notifcations
        
        NSString* idString = @"identifier";
        self.remindersIDArray = [NSMutableArray new];
        
        for (int i =0; i<randomTimesArray.count; i++) {

            // Grab a time from randomTimes Array
            NSDate *scheduledTime = randomTimesArray[i];
            NSLog(@"Will fire at %@", scheduledTime);
            
            
            // Make Identifiers, pass into Local Array (*this needs to persist)
            
            NSString* identifier = [NSString stringWithFormat:@"%@%i", idString, i];
            NSLog(@"%@",identifier);
            [self.remindersIDArray addObject:identifier];

            
            // Add Requests to Notification Center
            // For Testing: NSDate *testDate = [NSDate dateWithTimeIntervalSinceNow:10];
            UNNotificationRequest *request = [notificationsManager makeRequestFromReminderAndDateAndIdentifier:reminders date:scheduledTime identifer:identifier];
            [notificationsManager addToNotificationCenter:request];
            
        }
        
        // Show Pending Requests
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            
            for (int i =0; i<requests.count; i++) {
                NSLog(@"%@",requests[i]);
            }
        }];
    }

    
    [self.delegate newReminderViewControllerDidAdd];
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

- (IBAction)reminderTimesPerDay:(UIStepper *)sender {
    self.timesPerDayLabel.text = @(sender.value).stringValue;
}

- (IBAction)cancelReminder:(UIBarButtonItem *)sender {
    if (self.reminder != nil) {
    [self.delegate newReminderViewControllerDidCancel:self.reminder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

-(void)displayReminderForEdit: (Reminders *)reminder {
    self.reminderTitle.text = reminder.title;
    self.reminderDetails.text = reminder.details;
    self.reminderImage.image = [UIImage imageWithData:reminder.image];
}

@end
