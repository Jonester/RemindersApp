//
//  DetailViewController.m
//  RemindersApp


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
@property (weak, nonatomic) IBOutlet UILabel *timesPerDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (strong, nonatomic) Reminders *reminder;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self getContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminders" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"error : %@", error.localizedDescription);
    }
    
    NSString *startTimeString = [dateFormatter stringFromDate:self.reminder.startDate];
    NSString *endTimeString = [dateFormatter stringFromDate:self.reminder.endDate];
    
    self.detailTitle.text = self.reminder.title;
    self.detailDetails.text = self.reminder.details;
    
    
    NSString *imagePath = self.reminder.imagePath;
    NSString *imageName = imagePath.lastPathComponent;
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentDirPath stringByAppendingPathComponent:imageName];
    self.detailImage.image = [UIImage imageWithContentsOfFile:filePath];
    
//    self.detailImage.image = [UIImage imageWithContentsOfFile:self.reminder.imagePath];
    self.timesPerDayLabel.text = [NSString stringWithFormat:@"Times Per Day: %@", @(self.reminder.displayFrequency).stringValue];
    self.startTimeLabel.text  = [NSString stringWithFormat:@"Between: %@", startTimeString];
    self.endTimeLabel.text = [NSString stringWithFormat:@"End: %@", endTimeString];
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
