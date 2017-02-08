//
//  Photo.h
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-07.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject

@property (nonatomic, strong) NSURL *photoDownloadURL;
@property (nonatomic, strong) NSString *title;

@property (nonatomic) UIImage *image;


-(instancetype)initWithURL:(NSURL*)photoDownloadURL andTitle:(NSString *)title;

@end
