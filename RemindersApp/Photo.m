//
//  Photo.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-07.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(instancetype)initWithURL:(NSURL *)photoDownloadURL andTitle:(NSString *)title {
    self = [super init];
    
    if (self) {
        _photoDownloadURL = photoDownloadURL;
        _title = title;
    }
    return self;
}

@end
