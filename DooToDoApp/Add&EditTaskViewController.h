//
//  Add&EditTaskViewController.h
//  DooToDoApp
//
//  Created by Mona Zarea on 07/04/2026.
//

#import <UIKit/UIKit.h>
#import "Task+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Add_EditTaskViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) Task *taskToEdit;
@end

NS_ASSUME_NONNULL_END
