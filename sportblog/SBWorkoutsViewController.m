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

@interface SBWorkoutsViewController ()
@property (nonatomic, strong) RKTabView *tabView;
@property (nonatomic, strong) RLMArray *workouts;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation SBWorkoutsViewController

RKTabItem *tabItem1;
RKTabItem *tabItem2;

SBWorkout *highlightedWorkout;

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
    
    
    tabItem1 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    
    tabItem1.tabState = TabStateEnabled;
    
    tabItem2 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    RKTabItem *tabItem3 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    RKTabItem *tabItem4 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    
    self.tabView = [[RKTabView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 64 - 44, self.view.frame.size.width, 44)];
    self.tabView.tabItems = @[tabItem1, tabItem2, tabItem3, tabItem4];
    
    self.tabView.horizontalInsets = HorizontalEdgeInsetsMake(25, 25);
    self.tabView.darkensBackgroundForEnabledTabs = YES;
    self.tabView.enabledTabBackgrondColor = [UIColor colorWithRed:0.8 green:0.8 blue:1 alpha:1];
    self.tabView.backgroundColor = [UIColor navigationBarColor];
    self.tabView.delegate = self;
    
    
    self.tableView.dataSource = self;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor tableViewColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.workouts = [[SBWorkout allObjects] arraySortedByProperty:@"date" ascending:NO];
 
    [self startTapTutorialWithInfo:NSLocalizedString(@"Add a new workout", nil)
                           atPoint:CGPointMake(160, self.view.frame.size.height / 2 - 50)
              withFingerprintPoint:CGPointMake(self.view.frame.size.width - 25, 42)
              shouldHideBackground:NO];
    
    
    [self.view addSubview:self.tabView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    tabItem1.tabState = TabStateEnabled;
    tabItem2.tabState = TabStateDisabled;
    [self.tabView setNeedsDisplay];
    
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.workouts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"workoutCell";
    
    SBSmallTopBottomCell *workoutCell = (SBSmallTopBottomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    if (workoutCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBSmallTopBottomCell" owner:self options:nil];
        workoutCell = [nib objectAtIndex:0];
    }
    
    SBWorkout *workout = [self.workouts objectAtIndex:indexPath.row];
    workoutCell.topLabel.text = workout.name;
    workoutCell.topLabel.textColor = [UIColor textColor];
    
    workoutCell.bottomLabel.text = [self.dateFormatter stringFromDate:workout.date];
    workoutCell.bottomLabel.textColor = [UIColor textColor];
    
    
    workoutCell.layoutMargins = UIEdgeInsetsZero;
    workoutCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([highlightedWorkout isEqualToObject:workout]) {
        workoutCell.backgroundColor = [UIColor highlightColor];
        [UIView animateWithDuration:1.0 animations:^{
            workoutCell.backgroundColor = [UIColor clearColor];
        }];
    } else {
        workoutCell.backgroundColor = [UIColor clearColor];
    }

    
    return workoutCell;
}

- (void)addWorkoutViewController:(SBWorkoutViewController *)controller newWorkout:(SBWorkout *)workout {
    highlightedWorkout = workout;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SBWorkout *workout = [self.workouts objectAtIndex:indexPath.row];
    
    SBWorkoutViewController* workoutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBWorkoutViewController"];

    workoutViewController.workout = workout;
    workoutViewController.delegate = self;
    
    [self.navigationController pushViewController:workoutViewController animated:YES];
}

- (void)onAddWorkout:(id)sender {
    SBWorkoutViewController* workoutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBWorkoutViewController"];
    workoutViewController.delegate = self;
    
    [self.navigationController pushViewController:workoutViewController animated:YES];
}

- (void)createDateFormatter {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        SBWorkout *workout = [self.workouts objectAtIndex:indexPath.row];

        [RLMRealm.defaultRealm beginWriteTransaction];
        
        for (SBExerciseSet *exercise in workout.exercises) {
            for (SBSet *set in exercise.sets) {
                [workout.exercises.realm deleteObject:set];
            }
            
            [workout.realm deleteObject:exercise];
        }
        
        [RLMRealm.defaultRealm deleteObject:workout];
        [RLMRealm.defaultRealm commitWriteTransaction];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (void)tabView:(RKTabView *)tabView tabBecameDisabledAtIndex:(int)index tab:(RKTabItem *)tabItem
{
    
}

- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(int)index tab:(RKTabItem *)tabItem
{
    if (index == 1) {
        SBFinishedExercisesViewController *finishedExercises = [self.storyboard instantiateViewControllerWithIdentifier:@"SBFinishedExercisesViewController"];
        [self.navigationController pushViewController:finishedExercises animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}
@end
