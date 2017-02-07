//
//  Reminders+CoreDataProperties.m
//  RemindersApp
//
//  Created by Tristan Wolf on 2017-02-06.
//  Copyright © 2017 Jonescr. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Reminders+CoreDataProperties.h"

@implementation Reminders (CoreDataProperties)

+ (NSFetchRequest<Reminders *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Reminders"];
}

@dynamic title;
@dynamic details;
@dynamic image;
@dynamic displayFrequency;
@dynamic hasImage;
@dynamic uniqueID;

@end
