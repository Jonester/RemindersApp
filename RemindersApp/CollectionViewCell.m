//
//  CollectionViewCell.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-07.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "CollectionViewCell.h"
#import "Photo.h"

@implementation CollectionViewCell

- (void)setPhoto:(Photo *)photo {
    
     if (photo.image == nil) {
        [self fetchImage];
    } else {
        self.onlineImagesView.image = photo.image;
    }
    _photo = photo;
}

-(void)fetchImage {
    NSURL *downloadURL = self.photo.photoDownloadURL;
    
    if (downloadURL == nil) {
        return;
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:downloadURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error : %@", error.localizedDescription);
            
        }
        if (location) {
            NSData *data = [NSData dataWithContentsOfURL:location];
            UIImage *image = [UIImage imageWithData:data];
            
            self.photo.image = image;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.onlineImagesView.image = self.photo.image;
            });
        }
    }];
    [downloadTask resume];
}

@end
