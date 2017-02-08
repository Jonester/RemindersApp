//
//  OnlinePhotosViewController.h
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-07.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "CollectionViewCell.h"

@protocol OnlinePhotosViewControllerDelegate;

@interface OnlinePhotosViewController : UIViewController

@property (nonatomic) Photo *photo;
@property (nonatomic, weak) id<OnlinePhotosViewControllerDelegate>delegate;

@end

@protocol OnlinePhotosViewControllerDelegate <NSObject>

-(void)onlinePhotosViewController:(OnlinePhotosViewController *)controller didAddPhoto:(Photo *)image;

@end
