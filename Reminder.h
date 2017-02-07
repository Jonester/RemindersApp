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
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) UIImage *image;
@property (assign, nonatomic) NSInteger displayFrequency;
@property (strong, nonatomic) NSString *uniqueID;
@property (assign, nonatomic) BOOL hasImage;

- (instancetype)initWithTitle:(NSString*)title Body:(NSString*)details Image:(UIImage*)image displayFrequency:(NSInteger)frequency uniqueID:(NSString *)uniqueID hasImage:(BOOL)hasImage;

@end
