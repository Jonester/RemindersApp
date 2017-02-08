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
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [self getContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Reminders" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
   // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
   // [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
   // NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"<#key#>"
   //                                                                ascending:YES];
   // [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"error : %@", error.localizedDescription);
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *startTimeString = [dateFormatter stringFromDate:self.reminder.startDate];
    NSString *endTimeString = [dateFormatter stringFromDate:self.reminder.endDate];
    
    
    
    self.detailTitle.text = self.reminder.title;
    self.detailDetails.text = self.reminder.details;
    self.detailImage.image = [UIImage imageWithData:self.reminder.image];
    self.timesPerDayLabel.text = @(self.reminder.displayFrequency).stringValue;
    self.startTimeLabel.text  = startTimeString;
    self.endTimeLabel.text = endTimeString;
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
