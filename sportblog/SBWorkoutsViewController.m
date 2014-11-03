//
//  SBViewController.m
//  sportblog
//
//  Created by Marco Bullin on 07/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

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

#define iPhone6Plus ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 736)

@interface SBWorkoutsViewController ()

@property (nonatomic, strong) RLMArray *workouts;

@end

static NSString * const WorkoutCellIdentifier = @"WorkoutCell";
static NSString * const AddWorkoutCEllIdentifier = @"AddWorkoutCell";

@implementation SBWorkoutsViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Workouts Screen";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.workouts = [self.indicator findWorkouts];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor = [UIColor tableViewColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.tableView registerNib:[SBSmallTopBottomCell nib] forCellReuseIdentifier:WorkoutCellIdentifier];

    [self.view addSubview:self.tableView];
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    SBHelperView *helperView =[[SBHelperView alloc] initWithMessage:NSLocalizedString(@"Add a new workout", nil)
                                                            onPoint:CGPointMake(20, 100)
                                                     andHintOnPoint:CGRectMake(0, 64, self.view.frame.size.width, 44)
                                                    andRenderOnView:self.parentViewController.view];
    
    helperView.frame = self.view.frame;
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self onAddWorkout];
        return;
    }
    
    int index = (int)indexPath.row - 1;
    
    SBWorkout *workout = [self.workouts objectAtIndex:index];
    
    SBWorkoutViewController* workoutViewController = [[SBWorkoutViewController alloc] initWithNibName:@"SBWorkoutViewController" bundle:nil];

    workoutViewController.workout = workout;
    
    [self.navigationController pushViewController:workoutViewController animated:YES];
}

- (void)onAddWorkout {
    SBWorkoutViewController* workoutViewController = [[SBWorkoutViewController alloc] initWithNibName:@"SBWorkoutViewController" bundle:nil];
    
    SBWorkout *workout = [self.indicator createWorkoutWithName:NSLocalizedString(@"Workout", nil)
                                                  andDate:[NSDate date]];

    workoutViewController.workout = workout;
    [self.navigationController pushViewController:workoutViewController animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
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
    
    SBWorkout *workout = [self.workouts objectAtIndex:index];
    
    SBWorkoutViewModel *vm = [[SBWorkoutViewModel alloc] initWithWorkout:workout];
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
        SBWorkout *workout = [self.workouts objectAtIndex:index];
        
        [self.indicator deleteWorkout:workout];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        if ([self.workouts count] == 0) {
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
@end
