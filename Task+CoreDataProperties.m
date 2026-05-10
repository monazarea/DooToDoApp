//
//  Task+CoreDataProperties.m
//  DooToDoApp
//
//  Created by Mona Zarea on 07/04/2026.
//
//

#import "Task+CoreDataProperties.h"

@implementation Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Task"];
}

@dynamic title;
@dynamic taskDescription;
@dynamic priority;
@dynamic status;
@dynamic createdAt;
@dynamic imageName;
@dynamic reminderDate;
@dynamic attachmentPath;
@dynamic isReminderEnabled;
@dynamic lastEdit;

@end
