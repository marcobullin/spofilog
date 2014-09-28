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

@interface SBWorkoutsViewController () <UITableViewDelegate>

@property (nonatomic, strong) RLMArray *workouts;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) SBArrayDataSource *arrayDataSource;

@end

static NSString * const WorkoutCellIdentifier = @"WorkoutCell";

@implementation SBWorkoutsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createDateFormatter];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.barTintColor = [UIColor navigationBarColor];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.title = NSLocalizedString(@"Workouts", nil);
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddWorkout:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.workouts = [[SBWorkout allObjects] arraySortedByProperty:@"date" ascending:NO];
    
    SBCellBlock cellBlock = ^(SBSmallTopBottomCell *workoutCell, SBWorkout *workout) {
        workoutCell.topLabel.text = workout.name;
        workoutCell.topLabel.textColor = [UIColor textColor];
        
        workoutCell.bottomLabel.text = [self.dateFormatter stringFromDate:workout.date];
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
    self.tableView.dataSource = self.arrayDataSource;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor tableViewColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self.tableView registerNib:[SBSmallTopBottomCell nib] forCellReuseIdentifier:WorkoutCellIdentifier];
    
    [self startTapTutorialWithInfo:NSLocalizedString(@"Add a new workout", nil)
                           atPoint:CGPointMake(160, self.view.frame.size.height / 2 - 50)
              withFingerprintPoint:CGPointMake(self.view.frame.size.width - 25, 42)
              shouldHideBackground:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [self.arrayDataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    //return cell.frame.size.height;
    
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SBWorkout *workout = [self.workouts objectAtIndex:indexPath.row];
    
    SBWorkoutViewController* workoutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBWorkoutViewController"];

    workoutViewController.workout = workout;
    
    [self.navigationController pushViewController:workoutViewController animated:YES];
}

- (void)onAddWorkout:(id)sender {
    SBWorkoutViewController* workoutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBWorkoutViewController"];
    
    [self.navigationController pushViewController:workoutViewController animated:YES];
}

- (void)createDateFormatter {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}

@end
