//
//  SBViewController.m
//  sportblog
//
//  Created by Marco Bullin on 07/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBWorkoutsViewController.h"
#import "SBWorkout.h"

@interface SBWorkoutsViewController ()
    @property (nonatomic, strong) RKTabView *tabView;
    @property (nonatomic, strong) RLMArray *workouts;
@end

@implementation SBWorkoutsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    self.workouts = [SBWorkout allObjects];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.workouts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"workoutCell";
    
    UITableViewCell *workoutCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    if (workoutCell == nil) {
        workoutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        SBWorkout *workout = [self.workouts objectAtIndex:indexPath.row];
        workoutCell.textLabel.text = workout.name;
    }
    
    return workoutCell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
