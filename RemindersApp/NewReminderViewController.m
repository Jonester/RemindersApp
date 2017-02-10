//
//  NewReminderViewController.m
//  RemindersApp

#import "NewReminderViewController.h"
#import "NotificationsManager.h"
#import "AppDelegate.h"
#import "Identifier+CoreDataClass.h"
#import "OnlinePhotosViewController.h"

@interface NewReminderViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, OnlinePhotosViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *reminderTitle;

@property (weak, nonatomic) IBOutlet UIImageView *reminderImage;
@property (weak, nonatomic) IBOutlet UITextView *reminderDetails;

@property (weak, nonatomic) IBOutlet UILabel *timesPerDayLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTime;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTime;

@property (nonatomic) NSMutableArray *IdentifiersArray;
@property (strong, nonatomic) Reminders *reminderNew;
@property (weak, nonatomic) IBOutlet UIStepper *timesPerDayStepper;

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation NewReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self displayReminderForEdit:self.reminder];
    
    self.startTime.timeZone = [NSTimeZone defaultTimeZone];
    self.endTime.timeZone = [NSTimeZone defaultTimeZone];
    self.reminderDetails.delegate = self;
    self.reminderDetails.text = @"Enter reminder details...";
    self.reminderDetails.textColor = [UIColor lightGrayColor];
    self.reminderTitle.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
//    self.timesPerDayStepper.minimumValue = 1;
    
    if (self.reminder != nil) {
        self.startTime.date = self.reminder.startDate;
        self.endTime.date = self.reminder.endDate;
        self.reminderDetails.text = self.reminder.details;
        self.reminderDetails.textColor = [UIColor blackColor];
        self.reminderTitle.text = self.reminder.title;
        self.timesPerDayLabel.text = @(self.reminder.displayFrequency).stringValue;
        self.timesPerDayStepper.value = self.reminder.displayFrequency;
        self.reminderImage.image = [UIImage imageWithContentsOfFile:self.reminder.imagePath];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDidHide:)];
    [self.view addGestureRecognizer:tapGesture];
}


-(void)keyboardDidHide:(UITapGestureRecognizer *)tapGesture {
    [self.reminderTitle resignFirstResponder];
}

- (NSString*)saveImage:(UIImage*)toSave {
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpeg", [NSUUID new]];
    NSString *filePath = [documentDirPath stringByAppendingPathComponent:imageName];
    NSData *imageData = UIImageJPEGRepresentation(toSave, 0.3);
    // May want to consider scaling image down to reduce file size
    // http://stackoverflow.com/questions/36624195/effective-way-to-generate-thumbnail-from-uiimage
    
    if([imageData writeToFile:filePath atomically:YES]) {
        return filePath;
    } else {
        NSLog(@"Failed to save image");
        return nil;
    }
}


- (IBAction)newReminder:(UIBarButtonItem *)sender {
    
    if (self.reminder != nil) {
        //EDIT EXISTING REMINDER
        
        self.reminder.title = self.reminderTitle.text;
        self.reminder.details = self.reminderDetails.text;
        self.reminder.displayFrequency = self.timesPerDayLabel.text.integerValue;

        self.reminder.uniqueID = [[NSUUID UUID]UUIDString];
        
        self.reminder.startDate = self.startTime.date;
        self.reminder.endDate= self.endTime.date;
        
        self.reminder.imagePath = [self saveImage:self.reminderImage.image];

        [[self appDelegate] saveContext];
        
        self.context = [self getContext];
        
//        NSMutableArray *identifiers = [NSMutableArray new];
//        
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Identifier" inManagedObjectContext:self.context];
//        [fetchRequest setEntity:entity];
        //
        //        NSError *error = nil;
        //        NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
        //        if (fetchedObjects == nil) {
        //            NSLog(@"error: %@", error.localizedDescription);
        //        }
        //
        //        identifiers = [fetchedObjects mutableCopy];
        //
        
        NSArray<Identifier*> *tempIdentifierArray = self.reminder.identifier.allObjects;
        
        NSMutableArray<NSString*> *tempIDStringArray = [NSMutableArray new];
        
        for (Identifier* ident in tempIdentifierArray) {
            [tempIDStringArray addObject:ident.scheduleIdentifier];
        };
        
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removePendingNotificationRequestsWithIdentifiers:tempIDStringArray];
        
        [self.reminder removeIdentifier:self.reminder.identifier];
        
        [[self appDelegate] saveContext];
        
        
    } else {
        // NEW REMINDER
        
        
        NSString *title = self.reminderTitle.text;
        UIImage *image = self.reminderImage.image;
        NSString *details = self.reminderDetails.text;
        NSInteger displayFrequency = self.timesPerDayLabel.text.integerValue;
        NSDate *startDate = self.startTime.date;
        NSDate *endDate = self.endTime.date;
        
        
        NSManagedObjectContext *context = [self getContext];
        self.reminderNew = [NSEntityDescription insertNewObjectForEntityForName:@"Reminders" inManagedObjectContext:context];
        self.reminderNew.title = title;
        self.reminderNew.details = details;
       // self.reminderNew.uniqueID = [[NSUUID UUID] UUIDString];
        self.reminderNew.displayFrequency = displayFrequency;
        self.reminderNew.startDate = startDate;
        self.reminderNew.endDate = endDate;
        self.reminderNew.imagePath = [self saveImage:image];
        
        
        [[self appDelegate] saveContext];
    }
    
    // ADD TO NOTIFICATIONS CENTER
    NotificationsManager *notificationsManager = [NotificationsManager new];
    
    // 1. Build randomTimes Array
    NSInteger timesPerDay = [self.timesPerDayLabel.text intValue]; // # Items in Array
    NSDate *startTime = self.startTime.date;
    NSDate *endTime = self.endTime.date;
    NSArray *randomTimesArray = [notificationsManager generateArrayOfRandomTimes:startTime toTime:endTime numberOfReminders:(int)timesPerDay];
    
    // (An array for Request UniqueIDs)
    self.IdentifiersArray = [NSMutableArray new];
    
    // 2. Use randomTimes Array to schedule notifcations
    
    for (int i =0; i<randomTimesArray.count; i++) {
        // Grab a time from randomTimes Array
        NSDate *scheduledTime = randomTimesArray[i];
        NSLog(@"Will fire at %@", scheduledTime);
        
        // Make Identifiers, pass into Local Array (*this needs to persist*)
        NSString* requestIdentifier = [[NSUUID UUID] UUIDString];
        NSLog(@"%@",requestIdentifier);
        [self.IdentifiersArray addObject:requestIdentifier];
        
        
        if (self.reminder == nil) {
            // CREATE REQUEST
            UNNotificationRequest *request = [notificationsManager makeRequestFromReminder:self.reminderNew andDate:scheduledTime andIdentifer:requestIdentifier];
            
            // Pass to Notification Center
            [notificationsManager addRequestToNotificationCenter:request];
            NSLog(@"New requests sent");
        } else {
            UNNotificationRequest *request =
            [notificationsManager makeRequestFromReminder:self.reminder andDate:scheduledTime andIdentifer:requestIdentifier];

            [notificationsManager addRequestToNotificationCenter:request];
        }
        
        
        NSManagedObjectContext *context = [self getContext];
        Identifier *identifier = [NSEntityDescription insertNewObjectForEntityForName:@"Identifier" inManagedObjectContext:context];
        identifier.scheduleIdentifier = requestIdentifier;
        //To set relationship in core data do this or the next commented out line
        
        if (self.reminder == nil) {
        identifier.reminder = self.reminderNew;
        } else {
            identifier.reminder = self.reminder;
        }
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Save Failed: %@", error.localizedDescription);
            
        }
    }
    
    // Log Pending Requests
    [notificationsManager showPendingNotifications];
    

    [self.delegate newReminderViewControllerDidAdd];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma Stepper

- (IBAction)reminderTimesPerDay:(UIStepper *)sender {
    
    self.timesPerDayLabel.text = @(sender.value).stringValue;
    sender.minimumValue = 1;

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
    //self.reminderImage.image = [UIImage imageWithData:reminder.image];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"collectionviewcontroller"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        OnlinePhotosViewController *onlinePhotosViewController = [navigationController viewControllers][0];
        onlinePhotosViewController.delegate = self;
    }
}

-(void)onlinePhotosViewController:(OnlinePhotosViewController *)controller didAddPhoto:(Photo *)photo {
    
    [self.reminderImage setImage:photo.image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.reminderDetails.text isEqualToString:@"Enter reminder details..."]) {
        self.reminderDetails.text = @"";
        self.reminderDetails.textColor = [UIColor blackColor];
    }
    [self.reminderDetails becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.reminderDetails.text isEqualToString:@""]) {
        self.reminderDetails.text = @"Enter reminder details...";
        self.reminderDetails.textColor = [UIColor lightGrayColor];
    }
    [self.reminderDetails resignFirstResponder];
}

@end
