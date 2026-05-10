//
//  TaskTableViewCell.h
//  DooToDoApp
//
//  Created by Mona Zarea on 07/04/2026.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *taskImage;
@property (weak, nonatomic) IBOutlet UITextView *taskCreationDate;
@property (weak, nonatomic) IBOutlet UITextView *taskDescription;


@end

NS_ASSUME_NONNULL_END
