//
//  Curved Edges + Black Boarders.m
//  RemindersApp
//
//  Created by Tristan Wolf on 2017-02-09.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "LabelStyling.h"

@implementation LabelStyling

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.cornerRadius = 8.0;
    }
    return self;
}

@end
