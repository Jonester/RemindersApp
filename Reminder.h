//
//  Reminder.h
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-06.
//  Copyright © 2017 Jonescr. All rights reserved.
//

@import UIKit;

@interface Reminder : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) NSInteger displayFrequency;
@property (assign, nonatomic) BOOL hasImage;
@property (strong, nonatomic) NSString *uniqueID;

- (instancetype)initWithTitle:(NSString*)title Body:(NSString*)body Image:(UIImage*)image;

@end
