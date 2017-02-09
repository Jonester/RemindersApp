//
//  Reminders+CoreDataProperties.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-08.
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
@dynamic image;
@dynamic startDate;
@dynamic title;
@dynamic uniqueID;
@dynamic identifier;

@end
