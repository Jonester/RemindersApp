//
//  Identifier+CoreDataProperties.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-08.
//  Copyright © 2017 Jonescr. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Identifier+CoreDataProperties.h"

@implementation Identifier (CoreDataProperties)

+ (NSFetchRequest<Identifier *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Identifier"];
}

@dynamic scheduleIdentifier;
@dynamic reminder;

@end