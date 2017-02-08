//
//  NotificationsManager.h
//  RemindersApp

@import UserNotifications;
#import <Foundation/Foundation.h>
#import "Reminders+CoreDataClass.h"

@interface NotificationsManager : NSObject


+(void)SetupAndAskUserPermissions;


-(UNNotificationAction*)createAction:(NSString*)identifier title:(NSString*)title;


-(UNNotificationRequest*)makeRequestFromReminderAndDateAndIdentifier:(Reminders*)reminder date:(NSDate*)date identifer:(NSString*)identifier;
-(UNMutableNotificationContent*)makeContentFromReminder: (Reminders*)reminder;
-(UNCalendarNotificationTrigger*)makeTriggerFromDate:(NSDate*)date;


-(void)addToNotificationCenter:(UNNotificationRequest*)request;
-(NSMutableArray*) generateArrayOfRandomTimes:(NSDate*) startTime toTime:(NSDate *) endTime numberOfReminders: (int) elements;

-(void)showPendingNotifications;

@end
