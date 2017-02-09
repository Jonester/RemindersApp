//
//  NotificationsManager.h
//  RemindersApp

@import UserNotifications;
#import <Foundation/Foundation.h>
#import "Reminders+CoreDataClass.h"

@interface NotificationsManager : NSObject


+(void)SetupAndAskUserPermissions;

-(UNNotificationAction*)createAction:(NSString*)identifier title:(NSString*)title;

-(UNNotificationRequest*)makeRequestFromReminder:(Reminders*)reminder andDate:(NSDate*)date andIdentifer:(NSString*)identifier;
-(void)addRequestToNotificationCenter:(UNNotificationRequest*)request;

-(UNMutableNotificationContent*)makeContentFromReminder: (Reminders*)reminder;
-(UNCalendarNotificationTrigger*)makeTriggerFromDate:(NSDate*)date;

-(NSMutableArray*) generateArrayOfRandomTimes:(NSDate*) startTime toTime:(NSDate *) endTime numberOfReminders: (int) elements;

-(void)showPendingNotifications;

@end
