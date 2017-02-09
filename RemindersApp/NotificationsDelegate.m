//
//  NotificationsDelegate.m
//  RemindersApp
//
//  Created by Rajeev Ruparell on 2017-02-08.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "NotificationsDelegate.h"

@implementation NotificationsDelegate


-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    completionHandler(UNNotificationPresentationOptionAlert);
    
}


@end
