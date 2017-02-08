//
//  NewReminderViewController.h
//  RemindersApp
//


@import UserNotifications;

#import <UIKit/UIKit.h>
#import "Reminders+CoreDataClass.h"
#import "NotificationsManager.h"

@protocol NewReminderViewControllerDelegate;



@interface NewReminderViewController : UIViewController

@property (weak, nonatomic) id<NewReminderViewControllerDelegate>delegate;

@property (strong, nonatomic) Reminders *reminder;

@end

@protocol NewReminderViewControllerDelegate <NSObject>

-(void)newReminderViewControllerDidAdd;
-(void)newReminderViewControllerDidCancel:(Reminders*)reminderToDelete;

@end
