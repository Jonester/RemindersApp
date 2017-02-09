//
//  NotificationsDelegate.h
//  RemindersApp
//
//  Created by Rajeev Ruparell on 2017-02-08.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UserNotifications;

@interface NotificationsDelegate : NSObject <UNUserNotificationCenterDelegate>


-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler;

@end
