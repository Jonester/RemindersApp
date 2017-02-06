//
//  Reminder.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-06.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

- (instancetype)initWithTitle:(NSString*)title Body:(NSString*)body Image:(UIImage*)image
{
    self = [super init];
    if (self) {
        _title = title;
        _body = body;
        _image = image;
    }
    return self;
}

@end
