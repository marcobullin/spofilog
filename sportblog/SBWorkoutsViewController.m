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
    //[self tests];
    
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
    
    CGPoint hintPoint;
    if (iPhone6Plus) {
        hintPoint = CGPointMake(self.view.frame.size.width - 54, 15);
    } else {
        hintPoint = CGPointMake(self.view.frame.size.width - 50, 15);
    }
    
    SBHelperView *helperView =[[SBHelperView alloc] initWithMessage:NSLocalizedString(@"Add a new workout", nil)
                                                            onPoint:CGPointMake(20, 100)
                                                     andHintOnPoint:hintPoint
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

- (void)tests {
    int WORKOUT_COUNT = 10;
    int EXERCISES_COUNT = 10;
    int SET_COUNT = 10;
    
    int x = 0;
    for (x = 0; x < WORKOUT_COUNT; x++) {
        SBWorkout *workout = [SBWorkout new];
        workout.name = [NSString stringWithFormat:@"workout_%d", x];
        workout.date = [NSDate date];
        
        
        
        int y = 0;
        for (y = 0; y < EXERCISES_COUNT; y++) {
            SBExerciseSet *exercise = [SBExerciseSet new];
            exercise.name =  [NSString stringWithFormat:@"exercise_%d", y];
            exercise.date = [NSDate date];
            
            int z = 0;
            for (z = 0; z < SET_COUNT; z++) {
                SBSet *set = [SBSet new];
                set.weight = 10.0 * z;
                set.repetitions = 10;
                set.number = z;
                
                [RLMRealm.defaultRealm beginWriteTransaction];
                [RLMRealm.defaultRealm addObject:set];
                [RLMRealm.defaultRealm commitWriteTransaction];

                [RLMRealm.defaultRealm beginWriteTransaction];
                [exercise.sets addObject:set];
                [RLMRealm.defaultRealm commitWriteTransaction];
            }
            
            [RLMRealm.defaultRealm beginWriteTransaction];
            [workout.exercises addObject:exercise];
            [RLMRealm.defaultRealm commitWriteTransaction];
        }
        
        [RLMRealm.defaultRealm beginWriteTransaction];
        [RLMRealm.defaultRealm addObject:workout];
        [RLMRealm.defaultRealm commitWriteTransaction];
    }
    
    RLMArray *workouts = [SBWorkout allObjects];
    if ([workouts count] == WORKOUT_COUNT) {
        NSLog(@"All Workouts successfuly added!!");
        
        for (SBWorkout *w in workouts) {
            if ([w.exercises count] == EXERCISES_COUNT) {
                NSLog(@"All exercises successfuly added!!");
                
                for (SBExerciseSet *e in w.exercises) {
                    if ([e.sets count] == SET_COUNT) {
                        NSLog(@"All sets successfuly added!!");
                    } else {
                        NSLog([NSString stringWithFormat:@"Sets are missing!! Expected %d but found %d", SET_COUNT, [w.exercises count]]);
                    }
                }
            } else {
                NSLog([NSString stringWithFormat:@"Exercises are missing!! Expected %d but found %d", EXERCISES_COUNT, [w.exercises count]]);
            }
        }
    } else {
        NSLog([NSString stringWithFormat:@"Workouts are missing!! Expected %d but found %d", WORKOUT_COUNT, [workouts count]]);
    }

    for (SBWorkout *w in workouts) {
        [self.indicator deleteWorkout:w];
    }
    
    if ([workouts count] == 0) {
        NSLog(@"All Workouts successfuly deleted");
        
        RLMArray *exercises = [SBExerciseSet allObjects];
        RLMArray *sets = [SBSet allObjects];
        
        if ([exercises count] == 0) {
            NSLog(@"All exercises successfuly deleted");
        } else {
            NSLog(@"ERROR: Could not delete all exercises!");
        }
        
        if ([sets count] == 0) {
            NSLog(@"All sets successfuly deleted");
        } else {
            NSLog(@"ERROR: Could not delete all sets!");
        }
    } else {
        NSLog(@"ERROR: Could not delete all workouts!");
    }
    
}

@end
