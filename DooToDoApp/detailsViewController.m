//
//  detailsViewController.m
//  DooToDoApp
//
//  Created by Mona Zarea on 07/04/2026.
//

#import "detailsViewController.h"
#import "Task+CoreDataClass.h"
#import "Add&EditTaskViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MainColor      UIColorFromRGB(0xFFB77D)
#define SecondaryColor UIColorFromRGB(0xFFDCC3)
#define LightBgColor   UIColorFromRGB(0xFFEDE3)
#define DarkBrown      UIColorFromRGB(0x3D1C00)
#define MedBrown       UIColorFromRGB(0x7A4E30)
#define CardBorder     UIColorFromRGB(0xFFD5B0)

@interface detailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *taskImage;
@property (weak, nonatomic) IBOutlet UITextView  *taskDescription;
@property (weak, nonatomic) IBOutlet UITextView  *taskTitle;
@property (weak, nonatomic) IBOutlet UIView      *stateBackground;
@property (weak, nonatomic) IBOutlet UILabel     *stateLabel;
@property (weak, nonatomic) IBOutlet UIView      *dateCardBackground;
@property (weak, nonatomic) IBOutlet UIImageView *DateCardImage;
@property (weak, nonatomic) IBOutlet UIButton    *editButton;
@property (weak, nonatomic) IBOutlet UITextView *createdAtDate;
@property (weak, nonatomic) IBOutlet UITextView *date;
- (IBAction)editTask:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton    *deleteTaskBtn;
- (IBAction)deleteTask:(id)sender;

@end

@implementation detailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = MainColor;
    [self setupDetailsDesign];
    [self displayTaskData];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    for (CALayer *layer in self.view.layer.sublayers) {
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            layer.frame = self.view.bounds;
            break;
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self displayTaskData];
}


- (void)setupDetailsDesign {

    CAGradientLayer *bg   = [CAGradientLayer layer];
    bg.colors             = @[(id)LightBgColor.CGColor, (id)[UIColor whiteColor].CGColor];
    bg.startPoint         = CGPointMake(0, 0);
    bg.endPoint           = CGPointMake(0, 1);
    bg.frame              = self.view.bounds;
    [self.view.layer insertSublayer:bg atIndex:0];

    self.taskImage.layer.cornerRadius  = 22;
    self.taskImage.layer.masksToBounds = YES;
    self.taskImage.contentMode         = UIViewContentModeScaleAspectFit;
    self.taskImage.backgroundColor     = [UIColor colorWithWhite:1.0 alpha:0.6];
    self.taskImage.layer.borderWidth   = 0.5;
    self.taskImage.layer.borderColor   = CardBorder.CGColor;

    self.stateBackground.layer.cornerRadius  = 12;
    self.stateBackground.layer.masksToBounds = YES;
    self.stateLabel.font      = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];

    self.dateCardBackground.backgroundColor     = [UIColor whiteColor];
    self.dateCardBackground.layer.cornerRadius  = 18;
    self.dateCardBackground.layer.masksToBounds = NO;
    self.dateCardBackground.layer.borderWidth   = 0.5;
    self.dateCardBackground.layer.borderColor   = CardBorder.CGColor;
    self.dateCardBackground.layer.shadowColor   = MainColor.CGColor;
    self.dateCardBackground.layer.shadowOffset  = CGSizeMake(0, 6);
    self.dateCardBackground.layer.shadowRadius  = 14;
    self.dateCardBackground.layer.shadowOpacity = 0.12;

    self.taskTitle.font               = [UIFont systemFontOfSize:26 weight:UIFontWeightMedium];
    self.taskTitle.textColor          = DarkBrown;
    self.taskTitle.backgroundColor    = [UIColor clearColor];
    self.taskTitle.textContainerInset = UIEdgeInsetsZero;
    self.taskTitle.editable           = NO;
    self.taskTitle.scrollEnabled      = NO;
    self.taskTitle.selectable         = NO;

    self.taskDescription.backgroundColor = [UIColor clearColor];
    self.taskDescription.editable        = NO;
    self.taskDescription.scrollEnabled   = YES;
    self.taskDescription.selectable      = NO;
    self.taskDescription.userInteractionEnabled = YES;

    //self.editButton.backgroundColor    = MainColor;
    self.editButton.backgroundColor = SecondaryColor;
    self.editButton.layer.cornerRadius = 14;
    self.editButton.layer.masksToBounds = NO;
    self.editButton.layer.borderWidth = 0.5;
    self.editButton.layer.borderColor = CardBorder.CGColor;
    self.editButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.deleteTaskBtn.layer.borderColor    = UIColorFromRGB(0xFFCAC4).CGColor;
    [self.editButton setTitleColor:DarkBrown forState:UIControlStateNormal];
    [self.editButton setTitle:@"Edit Task" forState:UIControlStateNormal];

    self.deleteTaskBtn.backgroundColor      = UIColorFromRGB(0xFFF0EE);
    self.deleteTaskBtn.layer.cornerRadius   = 14;
    self.deleteTaskBtn.layer.masksToBounds  = NO;
    self.deleteTaskBtn.layer.borderWidth    = 0.5;
    self.deleteTaskBtn.layer.borderColor    = UIColorFromRGB(0xFFCAC4).CGColor;
    self.deleteTaskBtn.titleLabel.font      = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    [self.deleteTaskBtn setTitleColor:[UIColor colorWithRed:0.85 green:0.2 blue:0.2 alpha:1.0] forState:UIControlStateNormal];
    [self.deleteTaskBtn setTitle:@"Delete" forState:UIControlStateNormal];
}
- (void)displayTaskData {
    if (!self.selectedTask) return;

    self.taskTitle.text = (self.selectedTask.title.length > 0) ? self.selectedTask.title : @"Untitled task";
    [self fitTextView:self.taskTitle];

    CGRect descFrame = self.taskDescription.frame;
    descFrame.origin.y = CGRectGetMaxY(self.taskTitle.frame) + 15;
    descFrame.size.height = 250;
    self.taskDescription.frame = descFrame;

    if (self.selectedTask.taskDescription.length > 0) {
        [self applyStyledText:self.selectedTask.taskDescription toTextView:self.taskDescription];
    } else {
        self.taskDescription.text = @"No description provided.";
        self.taskDescription.textColor = [UIColor lightGrayColor];
    }
   // [self fitTextView:self.taskDescription];

    CGRect cardFrame = self.dateCardBackground.frame;
    cardFrame.origin.y = CGRectGetMaxY(self.taskDescription.frame) + 25;
    self.dateCardBackground.frame = cardFrame;

    if (self.selectedTask.createdAt) {
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"MMMM d, yyyy"];
        
        self.createdAtDate.text = self.selectedTask.lastEdit ? @"CREATED & LAST EDITED AT" : @"CREATED AT";
        self.createdAtDate.font = [UIFont systemFontOfSize:11 weight:UIFontWeightBold];
        self.createdAtDate.textColor = MedBrown;

        NSString *createdStr = [fmt stringFromDate:self.selectedTask.createdAt];
        
        if (!self.selectedTask.lastEdit) {
            self.date.text = createdStr;
            self.date.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
            self.date.textColor = DarkBrown;
        } else {
            NSString *editedStr = [fmt stringFromDate:self.selectedTask.lastEdit];
            NSString *fullText = [NSString stringWithFormat:@"%@\nEdited: %@", createdStr, editedStr];
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:fullText];
            
            [attString addAttributes:@{
                NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold],
                NSForegroundColorAttributeName: DarkBrown
            } range:[fullText rangeOfString:createdStr]];
            
            NSRange editedRange = [fullText rangeOfString:[NSString stringWithFormat:@"Edited: %@", editedStr]];
            [attString addAttributes:@{
                NSFontAttributeName: [UIFont systemFontOfSize:13 weight:UIFontWeightMedium],
                NSForegroundColorAttributeName: [UIColor grayColor]
            } range:editedRange];
            
            self.date.attributedText = attString;
        }

        self.date.textContainerInset = UIEdgeInsetsZero;
        [self fitTextView:self.date];
    }
    
    self.DateCardImage.image = [UIImage imageNamed:@"calender"];
    self.DateCardImage.tintColor = MainColor;

    CGRect editFrame = self.editButton.frame;
    editFrame.origin.y = CGRectGetMaxY(self.dateCardBackground.frame) + 40;
    self.editButton.frame = editFrame;

    CGRect deleteFrame = self.deleteTaskBtn.frame;
    if (self.editButton.hidden) {
            deleteFrame.origin.y = editFrame.origin.y;
        } else {
            deleteFrame.origin.y = CGRectGetMaxY(self.editButton.frame) + 15;
        }
    self.deleteTaskBtn.frame = deleteFrame;

    [self configureStatusBadge:self.selectedTask.status];
    [self configurePriorityIcon:self.selectedTask.priority];
    if (self.selectedTask.status == 2) {
            self.editButton.hidden = YES;
        } else {
            self.editButton.hidden = NO;
        }
}

- (void)applyStyledText:(NSString *)text toTextView:(UITextView *)tv {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing              = 6;
    style.paragraphSpacing         = 4;

    tv.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{
        NSParagraphStyleAttributeName : style,
        NSFontAttributeName           : [UIFont systemFontOfSize:15 weight:UIFontWeightRegular],
        NSForegroundColorAttributeName: [UIColor colorWithRed:0.29 green:0.16 blue:0.07 alpha:1.0]
    }];
}


- (void)configureStatusBadge:(int16_t)status {
    switch (status) {
        case 0:   // Todo
            self.stateLabel.text              = @"Todo";
            self.stateBackground.backgroundColor = SecondaryColor;
            self.stateLabel.textColor         = MedBrown;
            break;
        case 1:   // In Progress
            self.stateLabel.text              = @"In Progress";
            self.stateBackground.backgroundColor =
                [UIColor colorWithRed:1.0 green:0.95 blue:0.80 alpha:1.0];
            self.stateLabel.textColor         =
                [UIColor colorWithRed:0.48 green:0.35 blue:0.0 alpha:1.0];
            break;
        default:  // Done
            self.stateLabel.text              = @"Done";
            self.stateBackground.backgroundColor =
                [UIColor colorWithRed:0.87 green:0.97 blue:0.87 alpha:1.0];
            self.stateLabel.textColor         =
                [UIColor colorWithRed:0.15 green:0.50 blue:0.15 alpha:1.0];
            break;
    }

    [self.stateLabel sizeToFit];
    CGRect f       = self.stateBackground.frame;
    f.size.width   = self.stateLabel.frame.size.width + 24;
    f.size.height  = 28;
    self.stateBackground.frame = f;
}


- (void)configurePriorityIcon:(int16_t)priority {
    switch (priority) {
        case 2:  self.taskImage.image = [UIImage imageNamed:@"high_icon"]; break;
        case 1:  self.taskImage.image = [UIImage imageNamed:@"med_icon"];  break;
        default: self.taskImage.image = [UIImage imageNamed:@"low_icon"];  break;
    }
}


- (void)fitTextView:(UITextView *)tv {
    CGFloat width = tv.frame.size.width;
    CGSize  size  = [tv sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    CGRect  frame = tv.frame;
    frame.size    = CGSizeMake(MAX(size.width, width), size.height);
    tv.frame      = frame;
}


- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editTask:(id)sender {
    Add_EditTaskViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAndEditTask"];
    vc.taskToEdit = self.selectedTask;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:^{printf("Presented");}];
}

- (IBAction)deleteTask:(id)sender {
    UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Delete task"
                                            message:@"This action cannot be undone."
                                     preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:nil]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Delete"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *a) {
        NSManagedObjectContext *ctx = self.selectedTask.managedObjectContext;
        [ctx deleteObject:self.selectedTask];
        NSError *err = nil;
        if (![ctx save:&err]) {
            NSLog(@"Delete error: %@", err.localizedDescription);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
