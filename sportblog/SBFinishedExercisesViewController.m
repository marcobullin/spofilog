//
//  SBFinishedExercisesViewController.m
//  sportblog
//
//  Created by Marco Bullin on 17/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBFinishedExercisesViewController.h"
#import "SBExerciseSet.h"
#import "SBExerciseTableViewCell.h"
#import "SBStatisticViewController.h"

@interface SBFinishedExercisesViewController ()
@property (nonatomic, strong) RKTabView *tabView;
@property (nonatomic, strong) NSMutableArray *exercises;
@end

@implementation SBFinishedExercisesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    
    self.exercises = [[NSMutableArray alloc] init];
    
    RLMArray *exercises = [SBExerciseSet allObjects];
    
    for (SBExerciseSet *exercise in exercises) {
        if (![self.exercises containsObject:exercise.name]) {
            [self.exercises addObject:exercise.name];
        }
    }
    
    RKTabItem *tabItem1 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    RKTabItem *tabItem2 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    tabItem2.tabState = TabStateEnabled;
    RKTabItem *tabItem3 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    RKTabItem *tabItem4 = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"camera_enabled.png"] imageDisabled:[UIImage imageNamed:@"camera_disabled.png"]];
    
    self.tabView = [[RKTabView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    self.tabView.tabItems = @[tabItem1, tabItem2, tabItem3, tabItem4];
    
    self.tabView.horizontalInsets = HorizontalEdgeInsetsMake(25, 25);
    self.tabView.darkensBackgroundForEnabledTabs = YES;
    self.tabView.enabledTabBackgrondColor = [UIColor colorWithRed:0.8 green:0.8 blue:1 alpha:1];
    self.tabView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    self.tabView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //self.view.backgroundColor = [UIColor colorWithRed:140.0f/255.0f green:150.0f/255.0f blue:160.0f/255.0f alpha:1];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"hantel.png"]];
    [self.tableView setBackgroundView:imageView];
    
    [self.view addSubview:self.tabView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.exercises count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"exerciseCell";
    
    SBExerciseTableViewCell *exerciseCell = (SBExerciseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (exerciseCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBExerciseTableViewCell" owner:self options:nil];
        exerciseCell = [nib objectAtIndex:0];
    }
    
    exerciseCell.exerciseLabel.text = [self.exercises objectAtIndex:indexPath.row];
    
    return exerciseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SBStatisticViewController *stats = [self.storyboard instantiateViewControllerWithIdentifier:@"SBStatisticViewController"];
    
    stats.exerciseName = [self.exercises objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:stats animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tabView:(RKTabView *)tabView tabBecameEnabledAtIndex:(int)index tab:(RKTabItem *)tabItem
{
    if (index == 0) {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)tabView:(RKTabView *)tabView tabBecameDisabledAtIndex:(int)index tab:(RKTabItem *)tabItem {
    
}


@end
