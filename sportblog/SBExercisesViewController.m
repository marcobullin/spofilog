//
//  SBExercisesViewController.m
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBExercisesViewController.h"
#import "SBExercise.h"
#import "SBExerciseTableViewCell.h"

@interface SBExercisesViewController ()
@property (nonatomic, strong) RLMArray *exercises;
@end

@implementation SBExercisesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Exercises", nil);
    self.tableView.delegate = self;
    
    /*
    SBExercise *exercise = [[SBExercise alloc] init];
    exercise.name = @"Kreuzheuben";
    
    SBExercise *exercise2 = [[SBExercise alloc] init];
    exercise2.name = @"Bankdrücken";
    
    SBExercise *exercise3 = [[SBExercise alloc] init];
    exercise3.name = @"Butterfly";
    
    SBExercise *exercise4 = [[SBExercise alloc] init];
    exercise4.name = @"Bizeps";
    
    SBExercise *exercise5 = [[SBExercise alloc] init];
    exercise5.name = @"Trizeps";
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:exercise];
        [realm addObject:exercise2];
        [realm addObject:exercise3];
        [realm addObject:exercise4];
        [realm addObject:exercise5];
    [realm commitWriteTransaction];
     */
    
    self.exercises = [SBExercise allObjects];
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
    
    SBExercise *exercise = [self.exercises objectAtIndex:indexPath.row];
    exerciseCell.exerciseLabel.text = exercise.name;
    
    return exerciseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SBExercise *exercise = [self.exercises objectAtIndex:indexPath.row];
    
    [self.delegate addExercisesViewController:self didSelectExercise:exercise];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


@end
