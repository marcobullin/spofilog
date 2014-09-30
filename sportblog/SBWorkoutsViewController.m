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
#import "UIViewController+Tutorial.h"
#import "UIColor+SBColor.h"
#import "SBArrayDataSource.h"
#import "SBWorkoutViewModel.h"
#import "SBAppDelegate.h"

@interface SBWorkoutsViewController () <UITableViewDelegate>

@property (nonatomic, strong) RLMArray *workouts;
@property (nonatomic, strong) SBArrayDataSource *arrayDataSource;

@end

static NSString * const WorkoutCellIdentifier = @"WorkoutCell";

@implementation SBWorkoutsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Workouts", nil);
        self.tabBarItem.title = NSLocalizedString(@"Workouts", nil);
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(onAddWorkout:)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.workouts = [[SBWorkout allObjects] arraySortedByProperty:@"date" ascending:NO];
    
    SBCellBlock cellBlock = ^(SBSmallTopBottomCell *workoutCell, SBWorkout *workout) {
        SBWorkoutViewModel *vm = [[SBWorkoutViewModel alloc] initWithWorkout:workout];
        
        workoutCell.topLabel.text = vm.nameText;
        workoutCell.topLabel.textColor = [UIColor textColor];
        
        workoutCell.bottomLabel.text = vm.dateText;
        workoutCell.bottomLabel.textColor = [UIColor textColor];
        
        workoutCell.layoutMargins = UIEdgeInsetsZero;
        workoutCell.selectionStyle = UITableViewCellSelectionStyleNone;
        workoutCell.backgroundColor = [UIColor clearColor];
    };
    
    SBOnDeleteBlock deleteBlock = ^(SBWorkout *workout) {
        [RLMRealm.defaultRealm beginWriteTransaction];
        
        for (SBExerciseSet *exercise in workout.exercises) {
            for (SBSet *set in exercise.sets) {
                [workout.exercises.realm deleteObject:set];
            }
            
            [workout.realm deleteObject:exercise];
        }
        
        [RLMRealm.defaultRealm deleteObject:workout];
        [RLMRealm.defaultRealm commitWriteTransaction];
    };
    
    self.arrayDataSource = [[SBArrayDataSource alloc] initWithItems:self.workouts
                                                     cellIdentifier:WorkoutCellIdentifier
                                                 configureCellBlock:cellBlock
                                                      onDeleteBlock:deleteBlock];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor tableViewColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.tableView.dataSource = self.arrayDataSource;
    self.tableView.delegate = self;
    
    
    [self.tableView registerNib:[SBSmallTopBottomCell nib] forCellReuseIdentifier:WorkoutCellIdentifier];

    [self startTapTutorialWithInfo:NSLocalizedString(@"Add a new workout", nil)
                           atPoint:CGPointMake(160, self.view.frame.size.height / 2 - 50)
              withFingerprintPoint:CGPointMake(self.view.frame.size.width - 25, 40)
              shouldHideBackground:NO];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SBWorkout *workout = [self.workouts objectAtIndex:indexPath.row];
    
    SBWorkoutViewController* workoutViewController = [[SBWorkoutViewController alloc] initWithNibName:@"SBWorkoutViewController" bundle:nil];

    workoutViewController.workout = workout;
    
    [self.navigationController pushViewController:workoutViewController animated:YES];
}

- (void)onAddWorkout:(id)sender {
    SBWorkoutViewController* workoutViewController = [[SBWorkoutViewController alloc] initWithNibName:@"SBWorkoutViewController" bundle:nil];
    [self.navigationController pushViewController:workoutViewController animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}

@end
