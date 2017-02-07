//
//  NewReminderViewController.h
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-06.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminders+CoreDataClass.h"

@protocol NewReminderViewControllerDelegate;



@interface NewReminderViewController : UIViewController

@property (weak, nonatomic) id<NewReminderViewControllerDelegate>delegate;

@property (strong, nonatomic) Reminders *reminder;

@end

@protocol NewReminderViewControllerDelegate <NSObject>

-(void)newReminderViewControllerDidAdd;
-(void)newReminderViewControllerDidCancel:(Reminders*)reminderToDelete;

@end
