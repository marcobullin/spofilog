//
//  SBViewController.m
//  sportblog
//
//  Created by Marco Bullin on 07/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBWorkoutsViewController.h"
#import "SBWorkout.h"
#import "SBWorkoutTableViewCell.h"
#import "SBWorkoutViewController.h"

@interface SBWorkoutsViewController ()
@property (nonatomic, strong) RKTabView *tabView;
@property (nonatomic, strong) RLMArray *workouts;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation SBWorkoutsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createDateFormatter];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.navigationItem.title = NSLocalizedString(@"Workouts", nil);
    
    RKTabItem *tabItem1 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    
    tabItem1.tabState = TabStateEnabled;
    
    RKTabItem *tabItem2 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    RKTabItem *tabItem3 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    RKTabItem *tabItem4 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    
    self.tabView = [[RKTabView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    self.tabView.tabItems = @[tabItem1, tabItem2, tabItem3, tabItem4];
    
    self.tabView.horizontalInsets = HorizontalEdgeInsetsMake(25, 25);
    self.tabView.darkensBackgroundForEnabledTabs = YES;
    self.tabView.enabledTabBackgrondColor = [UIColor darkGrayColor];
    self.tabView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    self.tabView.delegate = self;
  
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tabView];
    
    self.tableView.dataSource = self;
    
    self.workouts = [[SBWorkout allObjects] arraySortedByProperty:@"date" ascending:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.workouts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"workoutCell";
    
    SBWorkoutTableViewCell *workoutCell = (SBWorkoutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    if (workoutCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBWorkoutTableViewCell" owner:self options:nil];
        workoutCell = [nib objectAtIndex:0];
    }
    
    SBWorkout *workout = [self.workouts objectAtIndex:indexPath.row];
    workoutCell.workoutLabel.text = workout.name;
    workoutCell.dateLabel.text = [self.dateFormatter stringFromDate:workout.date];
    
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
    
}

- (IBAction)createWorkout:(id)sender {
}
@end
