//
//  NewReminderViewController.m
//  RemindersApp

#import "NewReminderViewController.h"
#import "NotificationsManager.h"
#import "AppDelegate.h"
#import "Identifier+CoreDataClass.h"

@interface NewReminderViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *reminderTitle;
@property (weak, nonatomic) IBOutlet UITextField *reminderDetails;
@property (weak, nonatomic) IBOutlet UIImageView *reminderImage;
@property (weak, nonatomic) IBOutlet UILabel *timesPerDayLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTime;

@property (nonatomic) NSMutableArray *remindersIDArray;
@property (strong, nonatomic) Reminders *reminderNew;

@end

@implementation NewReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self displayReminderForEdit:self.reminder];
    
    // Set Date Picker Time Zone
    self.startTime.timeZone = [NSTimeZone defaultTimeZone];
    self.endTime.timeZone = [NSTimeZone defaultTimeZone];
    
    // Set initial value for Display
    self.timesPerDayLabel.text = @"1";
    self.reminderDetails.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
}

- (IBAction)newReminder:(UIBarButtonItem *)sender {
    
    if (self.reminder != nil) {
        
        self.reminder.title = self.reminderTitle.text;
        self.reminder.details = self.reminderDetails.text;
        self.reminder.image = [NSData dataWithData:UIImagePNGRepresentation(self.reminderImage.image)];
        NSManagedObjectContext *context = [self getContext];
        
        [[self appDelegate] saveContext];
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Save Failed: %@", error.localizedDescription);
        }
        
        NSMutableArray *notifications = [NSMutableArray new];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSManagedObjectContext *context1 = [self getContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Identifier" inManagedObjectContext:context1];
        [fetchRequest setEntity:entity];
        
        NSError *error1 = nil;
        NSArray *fetchedObjects = [context1 executeFetchRequest:fetchRequest error:&error1];
        if (fetchedObjects == nil) {
            NSLog(@"error: %@", error.localizedDescription);
        }
        notifications = [fetchedObjects mutableCopy];
        
        for (Identifier *identifier in notifications) {
            [context deleteObject:identifier];
        }
            [notifications removeAllObjects];
        
        [[self appDelegate] saveContext];
        // Use the notifications array to clear the Notifications Center
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeDeliveredNotificationsWithIdentifiers:notifications];
        
        
        //[notifications removeAllObjects];
        
    } else {


    NSString *title = self.reminderTitle.text;
    UIImage *image = self.reminderImage.image;
    NSString *details = self.reminderDetails.text;
    NSInteger displayFrequency = self.timesPerDayLabel.text.integerValue;
    
    NSManagedObjectContext *context = [self getContext];
    self.reminderNew = [NSEntityDescription insertNewObjectForEntityForName:@"Reminders" inManagedObjectContext:context];
    self.reminderNew.title = title;
    self.reminderNew.details = details;
    self.reminderNew.uniqueID = [[NSUUID UUID] UUIDString];
    self.reminderNew.displayFrequency = displayFrequency;
    self.reminderNew.image = UIImagePNGRepresentation(image);
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Save Failed: %@", error.localizedDescription);

    }
}
    
// ADD NOTIFICATIONS
         NotificationsManager *notificationsManager = [NotificationsManager new];
        
        // Build randomTimes Array
        NSInteger timesPerDay = [self.timesPerDayLabel.text intValue]; // # Items in Array
        NSDate *startTime = self.startTime.date; // Start Range of Array
        NSDate *endTime = self.endTime.date; // End Range of Array
        NSArray *randomTimesArray = [notificationsManager generateArrayOfRandomTimes:startTime toTime:endTime numberOfReminders:(int)timesPerDay];
    
    
        // Use randomTimes Array to schedule notifcations
    
        self.remindersIDArray = [NSMutableArray new];
    
    
        for (int i =0; i<randomTimesArray.count; i++) {
            // Grab a time from randomTimes Array
            NSDate *scheduledTime = randomTimesArray[i];
            NSLog(@"Will fire at %@", scheduledTime);
            
            // Make Identifiers, pass into Local Array (*this needs to persist*)
            NSString* identifierID = [[NSUUID UUID] UUIDString];
            NSLog(@"%@",identifierID);
            [self.remindersIDArray addObject:identifierID];

            // Add Requests to Notification Center
            // For Testing: NSDate *testDate = [NSDate dateWithTimeIntervalSinceNow:10];
            UNNotificationRequest *request = [notificationsManager makeRequestFromReminderAndDateAndIdentifier:self.reminderNew date:scheduledTime identifer:identifierID];
            [notificationsManager addToNotificationCenter:request];
            NSLog(@"The new requests were sent");
            
            NSManagedObjectContext *context = [self getContext];
            Identifier *identifier = [NSEntityDescription insertNewObjectForEntityForName:@"Identifier" inManagedObjectContext:context];
            identifier.scheduleIdentifier = identifierID;
            
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Save Failed: %@", error.localizedDescription);
                
            }
        }
    
        // Show Pending Requests
        [notificationsManager showPendingNotifications];
    
    
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
