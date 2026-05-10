//
//  Task+CoreDataProperties.h
//  DooToDoApp
//
//  Created by Mona Zarea on 07/04/2026.
//
//

#import "Task+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *taskDescription;
@property (nonatomic) int16_t priority;
@property (nonatomic) int16_t status;
@property (nullable, nonatomic, copy) NSDate *createdAt;
@property (nullable, nonatomic, copy) NSDate *lastEdit;
@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, copy) NSDate *reminderDate;
@property (nullable, nonatomic, copy) NSString *attachmentPath;
@property (nonatomic) BOOL isReminderEnabled;

@end

NS_ASSUME_NONNULL_END
