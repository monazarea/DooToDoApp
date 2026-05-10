//
//  TaskTableViewCell.m
//  DooToDoApp
//
//  Created by Mona Zarea on 07/04/2026.
//
#define MainColor [UIColor colorWithRed:255.0/255.0 green:183.0/255.0 blue:125.0/255.0 alpha:1.0]
#define SecondaryColor [UIColor colorWithRed:255.0/255.0 green:220.0/255.0 blue:195.0/255.0 alpha:1.0]
#define LightBgColor [UIColor colorWithRed:255.0/255.0 green:237.0/255.0 blue:227.0/255.0 alpha:1.0]
#import "TaskTableViewCell.h"

@implementation TaskTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 20.0;
    self.contentView.layer.borderWidth = 1.0;
    self.contentView.layer.borderColor = SecondaryColor.CGColor;
    
    self.contentView.layer.shadowColor = MainColor.CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 4);
    self.contentView.layer.shadowRadius = 6.0;
    self.contentView.layer.shadowOpacity = 0.2;
    self.contentView.layer.masksToBounds = NO;
    
    self.taskImage.layer.cornerRadius = 30;
    
    self.taskImage.layer.masksToBounds = YES;
    //self.taskImage.layer.borderWidth = 2.0;
    //self.taskImage.layer.borderColor = LightBgColor.CGColor;
    
    self.taskTitleLable.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    
    NSArray *textViews = @[ self.taskCreationDate, self.taskDescription];
    for (UITextView *tv in textViews) {
        tv.backgroundColor = [UIColor clearColor];
        tv.textContainerInset = UIEdgeInsetsZero;
        tv.textContainer.lineFragmentPadding = 0;
        tv.editable = NO;
        tv.selectable = NO;
        tv.scrollEnabled = NO;
        
    }
    self.taskCreationDate.textColor = [UIColor systemGrayColor];
    self.taskCreationDate.textAlignment = NSTextAlignmentRight;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat horizontalPadding = 0.0;
    CGFloat verticalPadding = 5.0;
    
    CGRect frame = self.contentView.frame;
    frame.origin.x = horizontalPadding;
    frame.size.width = self.frame.size.width - (2 * horizontalPadding);
    frame.origin.y = verticalPadding;
    frame.size.height = self.frame.size.height - (2 * verticalPadding);
    
    self.contentView.frame = frame;
    
    self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds cornerRadius:self.contentView.layer.cornerRadius].CGPath;
    
    CGFloat margin = 10.0;
        CGFloat dateWidth = 90.0;
        CGFloat dateHeight = 20.0;
        
        self.taskCreationDate.frame = CGRectMake(self.contentView.bounds.size.width - dateWidth - margin,
                                                 self.contentView.bounds.size.height - dateHeight - margin,
                                                 dateWidth,
                                                 dateHeight);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.contentView.backgroundColor = LightBgColor;
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}@end
