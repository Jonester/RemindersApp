//
//  Identifier+CoreDataProperties.h
//  RemindersApp
//
//  Created by Rajeev Ruparell on 2017-02-08.
//  Copyright © 2017 Jonescr. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Identifier+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Identifier (CoreDataProperties)

+ (NSFetchRequest<Identifier *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *scheduleIdentifier;
@property (nullable, nonatomic, retain) Reminders *reminder;

@end

NS_ASSUME_NONNULL_END
