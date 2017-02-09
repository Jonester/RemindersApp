//
//  Reminders+CoreDataProperties.m
//  RemindersApp
//
//  Created by Rajeev Ruparell on 2017-02-09.
//  Copyright © 2017 Jonescr. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Reminders+CoreDataProperties.h"

@implementation Reminders (CoreDataProperties)

+ (NSFetchRequest<Reminders *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Reminders"];
}

@dynamic details;
@dynamic displayFrequency;
@dynamic endDate;
@dynamic hasImage;
@dynamic startDate;
@dynamic title;
@dynamic uniqueID;
@dynamic imagePath;
@dynamic identifier;

@end
