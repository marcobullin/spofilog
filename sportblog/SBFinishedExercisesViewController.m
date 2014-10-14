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
#import "SBDescriptionCell.h"
#import "UIColor+SBColor.h"

@interface SBFinishedExercisesViewController ()

@property (nonatomic, strong) NSMutableArray *exercises;

@end

static NSString * const ExerciseCellIdentifier = @"ExerciseCell";
static NSString * const DescriptionCellIdentifier = @"DescriptionCell";

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
    return [self.exercises count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        SBDescriptionCell *descCell = (SBDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:DescriptionCellIdentifier];
        
        if (descCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBDescriptionCell" owner:self options:nil];
            descCell = [nib objectAtIndex:0];
        }
        
        descCell.descriptionLabel.numberOfLines = 0;
        descCell.selectionStyle = UITableViewCellSelectionStyleNone;

        if ([self.exercises count] == 0) {
            descCell.descriptionLabel.text = NSLocalizedString(@"No Finished Exercises", nil);
            descCell.descriptionLabel.textColor = [UIColor lightGrayColor];

            self.tableView.tableFooterView = [UIView new];
        } else {
            descCell.descriptionLabel.text = NSLocalizedString(@"Finished Exercises Description", nil);
            descCell.descriptionLabel.textColor = [UIColor grayColor];
        }
        
        return descCell;
    }
    
    
    SBStandardCell *exerciseCell = (SBStandardCell *)[tableView dequeueReusableCellWithIdentifier:ExerciseCellIdentifier];
    
    if (exerciseCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBStandardCell" owner:self options:nil];
        exerciseCell = [nib objectAtIndex:0];
    }
    int index = (int)indexPath.row - 1;
    
    exerciseCell.label.text = [self.exercises objectAtIndex:index];
    exerciseCell.label.textColor = [UIColor importantCellColor];
    
    return exerciseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    
    SBStatisticViewController *stats = [[SBStatisticViewController alloc] initWithNibName:@"SBStatisticViewController" bundle:nil];
    
    int index = (int)indexPath.row - 1;
    
    stats.exerciseName = [self.exercises objectAtIndex:index];
    
    [self.navigationController pushViewController:stats animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && [self.exercises count] == 0) {
        return 120;
    }
    
    if (indexPath.row == 0 && [self.exercises count] > 0) {
        return 80;
    }
    
    return 60;
}

@end
