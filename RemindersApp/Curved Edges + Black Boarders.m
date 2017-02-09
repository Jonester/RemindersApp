//
//  Curved Edges + Black Boarders.m
//  RemindersApp
//
//  Created by Tristan Wolf on 2017-02-09.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "Curved Edges + Black Boarders.h"

@implementation Curved_Edges___Black_Boarders

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return self;
}

@end
