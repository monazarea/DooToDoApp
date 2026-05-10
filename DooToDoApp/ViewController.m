//
//  ViewController.m
//  DooToDoApp
//
//  Created by Mona Zarea on 07/04/2026.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define MainColor UIColorFromRGB(0xFFB77D)
#define SecondaryColor UIColorFromRGB(0xFFDCC3)
#define LightBgColor UIColorFromRGB(0xFFEDE3)

#import "ViewController.h"
#import "AppDelegate.h"
#import "Task+CoreDataClass.h"
#import "TaskTableViewCell.h"
#import "Add&EditTaskViewController.h"
#import "detailsViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addTaskBtn;
- (IBAction)addTask:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegment;
- (IBAction)statusChanged:(id)sender;
@property (strong, nonatomic) NSMutableArray<Task *> *tasksArray;
@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSMutableArray<Task *> *highPriorityTasks;
@property (strong, nonatomic) NSMutableArray<Task *> *medPriorityTasks;
@property (strong, nonatomic) NSMutableArray<Task *> *lowPriorityTasks;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"TaskTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TaskCell"];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.context = appDelegate.persistentContainer.viewContext;
    //[self createTestTasks];
    [self setupTheme];
    [self fetchAllTasks];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchAllTasks];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self fetchAllTasks];
}
- (void)fetchAllTasks {
    NSFetchRequest *fetchRequest = [Task fetchRequest];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        self.highPriorityTasks = [NSMutableArray new];
        self.medPriorityTasks = [NSMutableArray new];
        self.lowPriorityTasks = [NSMutableArray new];
                
        for (Task *task in results) {
            if (task.priority == 2) [self.highPriorityTasks addObject:task];
            else if (task.priority == 1) [self.medPriorityTasks addObject:task];
            else [self.lowPriorityTasks addObject:task];
        }
        self.tasksArray = [results mutableCopy];
        [self.tableView reloadData];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.statusSegment.selectedSegmentIndex == 4) {
            return 3;
        }
        return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.statusSegment.selectedSegmentIndex == 4) {
        NSArray *tasks = [self tasksForSection:section];
        if (tasks.count == 0) return nil;
        
        if (section == 0) return @"High Priority";
        if (section == 1) return @"Medium Priority";
        return @"Low Priority";
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    if (self.statusSegment.selectedSegmentIndex == 4) {
        rows = [self tasksForSection:section].count;
    } else {
        rows = self.tasksArray.count;
    }

    BOOL isActuallyEmpty = NO;
    if (self.statusSegment.selectedSegmentIndex == 4) {
        NSInteger totalPriorityTasks = [self tasksForSection:0].count + [self tasksForSection:1].count + [self tasksForSection:2].count;
        isActuallyEmpty = (totalPriorityTasks == 0);
    } else {
        isActuallyEmpty = (self.tasksArray.count == 0);
    }

    if (isActuallyEmpty) {
        [self showEmptyMessage:@"No Tasks Yet! \nTap + to add your first task." forTableView:tableView];
        return 0;
    } else {
        [self hideEmptyMessageForTableView:tableView];
        return rows;
    }
}

- (NSArray *)tasksForSection:(NSInteger)section {
    int16_t priorityTarget;
    if (section == 0) priorityTarget = 2;
    else if (section == 1) priorityTarget = 1;
    else priorityTarget = 0;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"priority == %d", priorityTarget];
    return [self.tasksArray filteredArrayUsingPredicate:predicate];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    Task *currentTask;
        
        if (self.statusSegment.selectedSegmentIndex == 4) {
            NSArray *sectionTasks = [self tasksForSection:indexPath.section];
            currentTask = sectionTasks[indexPath.row];
        } else {
            currentTask = self.tasksArray[indexPath.row];
        }
    
    cell.taskTitleLable.text = currentTask.title;
    cell.taskDescription.text = currentTask.taskDescription;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    cell.taskCreationDate.text = [formatter stringFromDate:currentTask.createdAt];
    
    [self configurePriorityImageForCell:cell withPriority:currentTask.priority];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    detailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsVC"];
    
    Task *selectedTask;
    if (self.statusSegment.selectedSegmentIndex == 4) {
        selectedTask = [self tasksForSection:indexPath.section][indexPath.row];
    } else {
        selectedTask = self.tasksArray[indexPath.row];
    }
    
    detailsVC.selectedTask = selectedTask;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)configurePriorityImageForCell:(TaskTableViewCell *)cell withPriority:(int16_t)priority {
    switch (priority) {
        case 2: // High
            cell.taskImage.image = [UIImage imageNamed:@"high_icon"];
            break;
        case 1: // Med
            cell.taskImage.image = [UIImage imageNamed:@"med_icon"];
            break;
        default: // Low
            cell.taskImage.image = [UIImage imageNamed:@"low_icon"];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (IBAction)statusChanged:(UISegmentedControl *)sender {
    [self updateDataWithSearchText:self.searchBar.text];
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSString *trimmedText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self updateDataWithSearchText:trimmedText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Task?" message:@"Are you sure you want to remove this task forever, Moon?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            Task *taskToDelete = self.tasksArray[indexPath.row];
            [self.context deleteObject:taskToDelete];
            
            NSError *error = nil;
            if ([self.context save:&error]) {
                [self.tasksArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                NSLog(@"Task deleted!");
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        
        [alert addAction:deleteAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)addTask:(id)sender {
    Add_EditTaskViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAndEditTask"];
    
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:^{printf("Presented");}];
}


- (void)setupTheme {
    self.view.backgroundColor = LightBgColor;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.barTintColor = LightBgColor;
    self.searchBar.backgroundColor = [UIColor clearColor];
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    self.searchBar.placeholder = @"Search tasks by title...";
    if (searchField) {
        searchField.backgroundColor = [UIColor whiteColor];
        searchField.layer.cornerRadius = 15.0;
        searchField.layer.masksToBounds = YES;
        
        searchField.layer.borderWidth = 1.5;
        searchField.layer.borderColor = SecondaryColor.CGColor;
        
        UIImageView *searchIcon = (UIImageView *)searchField.leftView;
        if ([searchIcon isKindOfClass:[UIImageView class]]) {
            searchIcon.tintColor = MainColor;
        }
        
    }

    self.statusSegment.backgroundColor = SecondaryColor;
    self.statusSegment.selectedSegmentTintColor = MainColor;
    NSDictionary *selectedAttr = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    NSDictionary *normalAttr = @{NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    [self.statusSegment setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [self.statusSegment setTitleTextAttributes:selectedAttr forState:UIControlStateSelected];

    self.addTaskBtn.backgroundColor = MainColor;
    self.addTaskBtn.tintColor = [UIColor whiteColor];
    self.addTaskBtn.layer.cornerRadius = self.addTaskBtn.frame.size.height / 2;
    self.addTaskBtn.layer.shadowColor = MainColor.CGColor;
    self.addTaskBtn.layer.shadowOffset = CGSizeMake(0, 4);
    self.addTaskBtn.layer.shadowRadius = 6.0;
    self.addTaskBtn.layer.shadowOpacity = 0.4;
}

- (void)showEmptyMessage:(NSString *)message forTableView:(UITableView *)tableView {
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
    messageLabel.text = message;
    messageLabel.textColor = [UIColor darkGrayColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    [messageLabel sizeToFit];

    tableView.backgroundView = messageLabel;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)hideEmptyMessageForTableView:(UITableView *)tableView {
    tableView.backgroundView = nil;
}

- (void)updateDataWithSearchText:(NSString *)searchText {
    NSFetchRequest *fetchRequest = [Task fetchRequest];
    NSMutableArray *predicates = [NSMutableArray new];

    if (self.statusSegment.selectedSegmentIndex > 0 && self.statusSegment.selectedSegmentIndex < 4) {
        NSPredicate *statusPredicate = [NSPredicate predicateWithFormat:@"status == %d", (int)self.statusSegment.selectedSegmentIndex - 1];
        [predicates addObject:statusPredicate];
    }

    if (searchText.length > 0) {
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
        [predicates addObject:searchPredicate];
    }

    if (predicates.count > 0) {
        fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    }

    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
    [fetchRequest setSortDescriptors:@[sort]];

    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];

    if (!error) {
        self.tasksArray = [results mutableCopy];
        [self.tableView reloadData];
    }
}
@end
