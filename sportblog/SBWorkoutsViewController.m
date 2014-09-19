//
//  SBViewController.m
//  sportblog
//
//  Created by Marco Bullin on 07/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBWorkoutsViewController.h"
#import "SBWorkout.h"
#import "SBLeftRightTableViewCell.h"
#import "SBWorkoutViewController.h"
#import "SBStatisticViewController.h"
#import "SBFinishedExercisesViewController.h"
#import "UIViewController+Tutorial.h"

@interface SBWorkoutsViewController ()
@property (nonatomic, strong) RKTabView *tabView;
@property (nonatomic, strong) RLMArray *workouts;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation SBWorkoutsViewController

RKTabItem *tabItem1;
RKTabItem *tabItem2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createDateFormatter];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.navigationItem.title = NSLocalizedString(@"Workouts", nil);
    
    tabItem1 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    
    tabItem1.tabState = TabStateEnabled;
    
    tabItem2 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    RKTabItem *tabItem3 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    RKTabItem *tabItem4 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    
    self.tabView = [[RKTabView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    self.tabView.tabItems = @[tabItem1, tabItem2, tabItem3, tabItem4];
    
    self.tabView.horizontalInsets = HorizontalEdgeInsetsMake(25, 25);
    self.tabView.darkensBackgroundForEnabledTabs = YES;
    self.tabView.enabledTabBackgrondColor = [UIColor colorWithRed:0.8 green:0.8 blue:1 alpha:1];
    self.tabView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    self.tabView.delegate = self;
  
    [self.view addSubview:self.tabView];
    
    self.tableView.dataSource = self;
    
    self.workouts = [[SBWorkout allObjects] arraySortedByProperty:@"date" ascending:NO];
 
    [self startTapTutorialWithInfo:NSLocalizedString(@"Add a new workout", nil)
                           atPoint:CGPointMake(160, self.view.frame.size.height / 2 - 50)
              withFingerprintPoint:CGPointMake(self.view.frame.size.width - 25, 42)
              shouldHideBackground:NO];
}

- (void)viewDidAppear:(BOOL)animated {
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
    
    SBLeftRightTableViewCell *workoutCell = (SBLeftRightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    if (workoutCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBLeftRightTableViewCell" owner:self options:nil];
        workoutCell = [nib objectAtIndex:0];
    }
    
    SBWorkout *workout = [self.workouts objectAtIndex:indexPath.row];
    workoutCell.leftLabel.text = workout.name;
    workoutCell.rightLabel.text = [self.dateFormatter stringFromDate:workout.date];
    
    return workoutCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SBWorkout *workout = [self.workouts objectAtIndex:indexPath.row];
    
    SBWorkoutViewController* workoutViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SBWorkoutViewController"];

    workoutViewController.workout = workout;
    
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
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:workout];
        [realm commitWriteTransaction];
        
        [self.tableView reloadData];
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

- (IBAction)createWorkout:(id)sender {
}
@end
