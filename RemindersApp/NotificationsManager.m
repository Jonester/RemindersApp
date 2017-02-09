//
//  NotificationsManager.m
//  RemindersApp
//


#import "NotificationsManager.h"
#import <MobileCoreServices/MobileCoreServices.h>


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


// Build Request

-(UNNotificationRequest*)makeRequestFromReminder:(Reminders*)reminder andDate:(NSDate*)date andIdentifer:(NSString*)identifier {
    
    // Content
    UNMutableNotificationContent *content = [self makeContentFromReminder:reminder];
    
    // Trigger
    UNCalendarNotificationTrigger *trigger = [self makeTriggerFromDate:date];
    
    // Build and Return Request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];

    return request;
    
}

-(UNMutableNotificationContent*)makeContentFromReminder: (Reminders*)reminder {
    
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    
    content.title = reminder.title;
    content.body = reminder.details;
    content.categoryIdentifier = @"Reminders";
    
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Getting a URL to the temp file to a randomly named file in the temp directory
    NSURL *tmpFileURL = [[fileManager temporaryDirectory]
                         URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", [NSUUID new]]];
    
    // Copying the image from the path to the temp file
    [fileManager copyItemAtURL:[NSURL fileURLWithPath:reminder.imagePath]
                         toURL:tmpFileURL
                         error:nil];
    
    

    
    // Make Attachment Object
    
    NSError *err;
    UNNotificationAttachment *attachment =
    [UNNotificationAttachment
     attachmentWithIdentifier:@""
     URL:tmpFileURL
     options:@{UNNotificationAttachmentOptionsTypeHintKey: (__bridge NSString*)kUTTypeJPEG}
     error:&err];
    if (err) {
        NSLog(@"Error creating attachment %@", err.localizedDescription);
    } else {
        content.attachments = @[attachment];
    }
    
    
    return content;
    
}


-(UNCalendarNotificationTrigger*)makeTriggerFromDate:(NSDate*)date {
    
    NSDateComponents *triggerDate = [[NSCalendar currentCalendar] components:NSCalendarUnitYear+NSCalendarUnitMonth+NSCalendarUnitDay+NSCalendarUnitHour+NSCalendarUnitMinute+NSCalendarUnitSecond fromDate:date];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
    
    return trigger;
    
}


// Add to Notification Center

-(void)addRequestToNotificationCenter:(UNNotificationRequest*)request {
    
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


// Create Action

-(UNNotificationAction*)createAction:(NSString*)identifier title:(NSString*)title {
    
    UNNotificationAction *action = [UNNotificationAction actionWithIdentifier:identifier title:title options:UNNotificationActionOptionNone];
    return action;
    
};

@end
