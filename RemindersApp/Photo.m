//
//  Photo.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-07.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "Photo.h"

@implementation Photo

-(instancetype)initWithURL:(NSURL *)photoDownloadURL {
    self = [super init];
    
    if (self) {
        _photoDownloadURL = photoDownloadURL;
    }
    return self;
}

@end
