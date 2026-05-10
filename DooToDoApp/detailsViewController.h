//
//  detailsViewController.h
//  DooToDoApp
//
//  Created by Mona Zarea on 07/04/2026.
//

#import <UIKit/UIKit.h>
#import "Task+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface detailsViewController : UIViewController
@property (strong, nonatomic) Task *selectedTask;
@end

NS_ASSUME_NONNULL_END
