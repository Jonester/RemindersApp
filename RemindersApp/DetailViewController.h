//
//  DetailViewController.h
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-06.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Reminder;

@interface DetailViewController : UIViewController

- (void)displayDetailView:(Reminder*)reminder;

@end
