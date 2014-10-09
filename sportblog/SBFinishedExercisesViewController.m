//
//  SBFinishedExercisesViewController.m
//  sportblog
//
//  Created by Marco Bullin on 17/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBFinishedExercisesViewController.h"
#import "SBExerciseSet.h"
#import "SBStatisticViewController.h"
#import "SBStandardCell.h"

@interface SBFinishedExercisesViewController ()

@property (nonatomic, strong) NSMutableArray *exercises;

@end

@implementation SBFinishedExercisesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Exercises", nil);
        self.tabBarItem.title = NSLocalizedString(@"Statistics", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"stats"];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"Statistic Exercises Screen";
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
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
    if (!self.exercises) {
        self.exercises = [[NSMutableArray alloc] init];
    }
    
    [self.exercises removeAllObjects];
    
    RLMArray *exercises = [SBExerciseSet allObjects];
    
    for (SBExerciseSet *exercise in exercises) {
        if (![self.exercises containsObject:exercise.name]) {
            [self.exercises addObject:exercise.name];
        }
    }
    
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.exercises count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"exerciseCell";
    
    SBStandardCell *exerciseCell = (SBStandardCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (exerciseCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBStandardCell" owner:self options:nil];
        exerciseCell = [nib objectAtIndex:0];
    }
    
    exerciseCell.label.text = [self.exercises objectAtIndex:indexPath.row];
    
    return exerciseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SBStatisticViewController *stats = [[SBStatisticViewController alloc] initWithNibName:@"SBStatisticViewController" bundle:nil];
    
    stats.exerciseName = [self.exercises objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:stats animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
