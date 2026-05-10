//
//  Add&EditTaskViewController.m
//  DooToDoApp
//
//  Created by Mona Zarea on 07/04/2026.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MainColor UIColorFromRGB(0xFFB77D)
#define SecondaryColor UIColorFromRGB(0xFFDCC3)
#define LightBgColor UIColorFromRGB(0xFFEDE3)
#import "Add&EditTaskViewController.h"
#import "AppDelegate.h"
#import "Task+CoreDataClass.h"



@interface Add_EditTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextView *screenTitle;
@property (weak, nonatomic) IBOutlet UITextView *titleInpu;
@property (weak, nonatomic) IBOutlet UITextView *descriptionInput;
@property (weak, nonatomic) IBOutlet UILabel *addTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addPriorityLabel;
@property (weak, nonatomic) IBOutlet UILabel *addStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addDescriptionLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *PrioritySegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegment;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
- (IBAction)saveTask:(id)sender;
- (IBAction)goBack:(id)sender;

@end

@implementation Add_EditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descriptionInput.delegate = self;
    [self setupScreenDesign];
    
    if (self.taskToEdit) {
        self.screenTitle.text = @"Edit Task";
        self.titleInpu.text = self.taskToEdit.title;
        self.descriptionInput.text = self.taskToEdit.taskDescription;
        self.descriptionInput.textColor = [UIColor darkGrayColor];
        self.PrioritySegment.selectedSegmentIndex = self.taskToEdit.priority;
        self.stateSegment.selectedSegmentIndex = self.taskToEdit.status;
        [self configureStateWorkflow:self.taskToEdit.status];
        }
    else {
            [self.stateSegment setEnabled:NO forSegmentAtIndex:2];
            
            self.stateSegment.selectedSegmentIndex = 0;
        }
}
- (void)configureStateWorkflow:(int16_t)currentStatus {
    if (currentStatus == 1) {
        [self.stateSegment setEnabled:NO forSegmentAtIndex:0];
    }
    else if (currentStatus == 2) {
        [self.stateSegment setEnabled:NO forSegmentAtIndex:0];
        [self.stateSegment setEnabled:NO forSegmentAtIndex:1];
    }
}
- (void)setupScreenDesign {
    self.view.backgroundColor = LightBgColor;

    self.screenTitle.font = [UIFont boldSystemFontOfSize:22];
    self.screenTitle.textColor = [UIColor darkGrayColor];
    self.screenTitle.backgroundColor = [UIColor clearColor];
    self.screenTitle.textAlignment = NSTextAlignmentCenter;

    NSArray *inputs = @[self.titleInpu, self.descriptionInput];
    for (UITextView *tv in inputs) {
        tv.layer.cornerRadius = 15.0;
        tv.layer.borderWidth = 0.5;
        tv.layer.borderColor = SecondaryColor.CGColor;
        tv.backgroundColor = [UIColor whiteColor];
        tv.textContainerInset = UIEdgeInsetsMake(12, 12, 12, 12);
        
        tv.layer.shadowColor = MainColor.CGColor;
        tv.layer.shadowOffset = CGSizeMake(0, 2);
        tv.layer.shadowRadius = 4.0;
        tv.layer.shadowOpacity = 0.15;
        tv.layer.masksToBounds = NO;
        tv.scrollEnabled = YES;
        tv.userInteractionEnabled = YES;
        tv.clipsToBounds = YES;
    }

    NSArray *labels = @[self.addTitleLabel, self.addPriorityLabel, self.addStateLabel, self.addDescriptionLabel];
    for (UILabel *lbl in labels) {
        lbl.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
        lbl.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    }
    self.titleInpu.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.titleInpu.textColor = [UIColor darkGrayColor];
    self.descriptionInput.scrollEnabled = YES;
    self.descriptionInput.showsVerticalScrollIndicator = YES;
    self.descriptionInput.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.descriptionInput.textColor = [UIColor darkGrayColor];
        
    self.descriptionInput.text = @"Enter task details here...";
    self.descriptionInput.textColor = [UIColor lightGrayColor];

    self.PrioritySegment.backgroundColor = SecondaryColor;
    self.PrioritySegment.selectedSegmentTintColor = MainColor;
    
    self.stateSegment.backgroundColor = SecondaryColor;
    self.stateSegment.selectedSegmentTintColor = MainColor;
    
    NSDictionary *selectedAttr = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [self.PrioritySegment setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];
    [self.stateSegment setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];

        self.saveBtn.configuration = nil;
        [self.saveBtn setTitle:@"Save" forState:UIControlStateNormal];
        
        self.saveBtn.backgroundColor = MainColor;
        [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        self.saveBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.saveBtn.layer.cornerRadius = 12.0;
        
        self.saveBtn.layer.shadowColor = MainColor.CGColor;
        self.saveBtn.layer.shadowOffset = CGSizeMake(0, 4);
        self.saveBtn.layer.shadowRadius = 6.0;
        self.saveBtn.layer.shadowOpacity = 0.3;
        
        self.saveBtn.clipsToBounds = NO;
        self.backBtn.configuration = nil;
        [self.backBtn setTitle:@"Back" forState:UIControlStateNormal];
        [self.backBtn setTitleColor:MainColor forState:UIControlStateNormal];
        self.backBtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        
        self.backBtn.layer.cornerRadius = 12.0;
        self.backBtn.layer.borderWidth = 1.0;
        self.backBtn.layer.borderColor = MainColor.CGColor;
        self.backBtn.backgroundColor = [UIColor clearColor];
}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveTask:(id)sender {
    if (self.titleInpu.text.length == 0 || [self.titleInpu.text isEqualToString:@"Enter title here..."]) {
        [self showAlertWithTitle:@"Wait a second! ✋" message:@"Please make sure to add a title for your task."];
        return;
    }

    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;

    Task *task;
        if (self.taskToEdit) {
            task = self.taskToEdit;
            task.lastEdit = [NSDate date];
        } else {
            task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
            task.createdAt = [NSDate date]; 
        }

        task.title = self.titleInpu.text;
        task.taskDescription = self.descriptionInput.text;
        task.priority = (int16_t)self.PrioritySegment.selectedSegmentIndex;
        task.status = (int16_t)self.stateSegment.selectedSegmentIndex;

        NSError *error = nil;
        if ([context save:&error]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Enter task details here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor darkGrayColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Enter task details here...";
        textView.textColor = [UIColor lightGrayColor];
    }
}
@end
