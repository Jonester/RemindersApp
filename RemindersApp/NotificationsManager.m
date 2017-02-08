//
//  NotificationsManager.m
//  RemindersApp
//


#import "NotificationsManager.h"


@implementation NotificationsManager


+(void)SetupAndAskUserPermissions {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            NSLog(@"Error");
        }
    }];
    
};


// Create Action

-(UNNotificationAction*)createAction:(NSString*)identifier title:(NSString*)title {
    
    UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:identifier title:title options:UNNotificationActionOptionNone];
    
    return action;
    
};


// Build Request (+ Helper Methods)

-(UNNotificationRequest*)makeRequestFromReminderAndDateAndIdentifier:(Reminders*)reminder date:(NSDate*)date identifer:(NSString*)identifier {
    
    
    UNMutableNotificationContent *content = [self makeContentFromReminder:reminder];
    
    UNCalendarNotificationTrigger *trigger = [self makeTriggerFromDate:date];
    
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    
    
    
    return request;
    
}

-(UNMutableNotificationContent*)makeContentFromReminder: (Reminders*)reminder {
    
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    
    content.title = reminder.title;
    content.body = reminder.details;
    content.categoryIdentifier = @"Reminders";
    
    
    return content;
    
}

-(UNCalendarNotificationTrigger*)makeTriggerFromDate:(NSDate*)date {
    
    NSDateComponents *triggerDate = [[NSCalendar currentCalendar] components:NSCalendarUnitYear+NSCalendarUnitMonth+NSCalendarUnitDay+NSCalendarUnitHour+NSCalendarUnitMinute+NSCalendarUnitSecond fromDate:date];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
    
    return trigger;
    
}


// Add to Notification Center

-(void)addToNotificationCenter:(UNNotificationRequest*)request {
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error !=nil) {
            NSLog(@"%@",error);
        }
    }];
    
}


-(NSMutableArray*) generateArrayOfRandomTimes:(NSDate*) startTime toTime:(NSDate *) endTime numberOfReminders: (int) elements{
    
    NSMutableArray * timesArray = [NSMutableArray array];
    
    NSDate * newDate;
    
    for (int i = 0; i < elements; i++) {
        
        NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:startTime];
        NSTimeInterval randomInterval = arc4random_uniform(timeInterval);
        newDate = [NSDate dateWithTimeInterval: randomInterval sinceDate:startTime];
        [timesArray addObject:newDate];
        
    }
    
    return timesArray;
}


-(void)showPendingNotifications {
UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
[center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
    
    for (int i =0; i<requests.count; i++) {
        NSLog(@"%@",requests[i]);
    }
}];
}

@end
