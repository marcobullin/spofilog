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

@property (nonatomic, strong) NSMutableArray *exercises;

@end

@implementation SBFinishedExercisesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Exercises", nil);
        self.tabBarItem.title = NSLocalizedString(@"Statistics", nil);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.exercises = [[NSMutableArray alloc] init];
    
    RLMArray *exercises = [SBExerciseSet allObjects];
    
    for (SBExerciseSet *exercise in exercises) {
        if (![self.exercises containsObject:exercise.name]) {
            [self.exercises addObject:exercise.name];
        }
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
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
    SBStatisticViewController *stats = [[SBStatisticViewController alloc] initWithNibName:@"SBStatisticViewController" bundle:nil];
    
    stats.exerciseName = [self.exercises objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:stats animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
