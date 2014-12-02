#import "SBWorkoutsViewController.h"
#import "SBWorkout.h"
#import "SBSmallTopBottomCell.h"
#import "SBWorkoutViewController.h"
#import "SBStatisticViewController.h"
#import "SBFinishedExercisesViewController.h"
#import "UIColor+SBColor.h"
#import "SBWorkoutViewModel.h"
#import "SBAppDelegate.h"
#import "SBHelperView.h"
#import "SBAddEntryViewModel.h"
#import "SBAddEntryTableViewCell.h"
#import "SBWorkoutListInteractor.h"
#import "SBWorkoutInteractor.h"

@interface SBWorkoutsViewController ()
@end

static NSString * const WorkoutCellIdentifier = @"WorkoutCell";
static NSString * const AddWorkoutCEllIdentifier = @"AddWorkoutCell";

@implementation SBWorkoutsViewController

#pragma mark - lifecycle methods

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Workouts", nil);
        self.tabBarItem.title = NSLocalizedString(@"Workouts", nil);
        self.tabBarItem.image = [[UIImage imageNamed:@"hantelUnselected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"hantel"];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Workouts Screen";
    [self.workoutPresenter findWorkouts];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    SBHelperView *helperView =[[SBHelperView alloc] initWithMessage:NSLocalizedString(@"Add a new workout", nil)
                                                            onPoint:CGPointMake(20, 100)
                                                     andHintOnPoint:CGRectMake(0, 64, self.view.frame.size.width, 44)
                                                    andRenderOnView:self.parentViewController.view];
    
    helperView.frame = self.view.frame;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}

#pragma mark - actions

- (void)displayWorkouts:(NSArray *)workouts {
    self.workouts = [NSMutableArray arrayWithArray:workouts];
    [self.tableView reloadData];
}

- (void)displayCreatedWorkout:(NSDictionary *)workout {
    [self.workouts addObject:workout];
    [self displayWorkoutDetails:workout];
}

- (void)displayWorkoutDetails:(NSDictionary *)workout {
    SBWorkoutViewController* workoutViewController = [[SBWorkoutViewController alloc] initWithNibName:@"SBWorkoutViewController" bundle:nil];
    
    SBWorkoutPresenter *workoutPresenter = [SBWorkoutPresenter new];
    SBWorkoutInteractor *workoutInteractor = [SBWorkoutInteractor new];
    
    workoutViewController.workoutPresenter = workoutPresenter;
    workoutPresenter.view = workoutViewController;
    workoutPresenter.workoutInteractor = workoutInteractor;
    workoutInteractor.output = workoutPresenter;
    
    workoutViewController.workout = [NSMutableDictionary dictionaryWithDictionary:workout];
    
    [self.navigationController pushViewController:workoutViewController animated:YES];
}

- (void)removeWorkoutAtIndex:(int)index {
    [self.workouts removeObjectAtIndex:index];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index+1 inSection:0];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    if ([self.workouts count] == 0) {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.workoutPresenter createWorkout];
        return;
    }
    
    int index = (int)indexPath.row - 1;
    [self displayWorkoutDetails:[self.workouts objectAtIndex:index]];
}


#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SBAddEntryTableViewCell *addWorkoutCell = (SBAddEntryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:AddWorkoutCEllIdentifier];
        
        if (addWorkoutCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBAddEntryTableViewCell" owner:self options:nil];
            addWorkoutCell = [nib objectAtIndex:0];
        }
        
        SBAddEntryViewModel *addEntryViewModel = [[SBAddEntryViewModel alloc] initWithWorkouts:self.workouts];
        
        [addWorkoutCell render:addEntryViewModel];
        
        return addWorkoutCell;
    }
    
    int index = (int)indexPath.row - 1;
    
    SBSmallTopBottomCell *cell = (SBSmallTopBottomCell *)[tableView dequeueReusableCellWithIdentifier:WorkoutCellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBSmallTopBottomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    SBWorkoutViewModel *vm = [[SBWorkoutViewModel alloc] initWithWorkout:[self.workouts objectAtIndex:index]];
    [cell render:vm];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.workouts count] + 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int index = (int)indexPath.row - 1;
        [self.workoutPresenter deleteWorkout:[self.workouts objectAtIndex:index] atIndex:index];
    }
}

@end
