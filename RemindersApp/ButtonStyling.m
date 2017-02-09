//
//  ButtonStyling.m
//  RemindersApp
//
//  Created by Tristan Wolf on 2017-02-09.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "ButtonStyling.h"

@implementation ButtonStyling

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.cornerRadius = 8.0;
    }
    return self;
}/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
