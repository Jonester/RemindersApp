//
//  Reminders+CoreDataProperties.h
//  RemindersApp
//
//  Created by Tristan Wolf on 2017-02-08.
//  Copyright © 2017 Jonescr. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Reminders+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Reminders (CoreDataProperties)

+ (NSFetchRequest<Reminders *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *details;
@property (nonatomic) int16_t displayFrequency;
@property (nonatomic) BOOL hasImage;
@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *uniqueID;
@property (nullable, nonatomic, copy) NSDate *startDate;
@property (nullable, nonatomic, copy) NSDate *endDate;

@end

NS_ASSUME_NONNULL_END
