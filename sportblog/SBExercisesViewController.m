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
#import "SBCreateExerciseTableViewCell.h"

@interface SBExercisesViewController ()
@property (nonatomic, strong) RLMArray *exercises;
@end

@implementation SBExercisesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Exercises", nil);
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *key = @"exercisesImported";
    
    if([preferences objectForKey:key] == nil) {
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
        
        [preferences setInteger:1 forKey:key];
    }
    
    self.exercises = [SBExercise allObjects];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int index = indexPath.row - 1;
        
        SBExercise *exercise = [self.exercises objectAtIndex:index];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
        
        [realm beginWriteTransaction];
        [realm deleteObject:exercise];
        [realm commitWriteTransaction];
        
        [self.tableView reloadData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.exercises count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier;
    
    if (indexPath.row == 0) {
        cellIdentifier = @"createExerciseCell";
        
        SBCreateExerciseTableViewCell *createExerciseCell = (SBCreateExerciseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (createExerciseCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBCreateExerciseTableViewCell" owner:self options:nil];
            createExerciseCell = [nib objectAtIndex:0];
        }
        
        createExerciseCell.exerciseField.placeholder = @"New exercise";
        [createExerciseCell.addButton setTitle:@"Create" forState:UIControlStateNormal];
        [createExerciseCell.addButton addTarget:self action:@selector(onCreatedExercise:) forControlEvents:UIControlEventTouchUpInside];
        
        return createExerciseCell;
    }
    
    cellIdentifier = @"exerciseCell";
    
    SBExerciseTableViewCell *exerciseCell = (SBExerciseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (exerciseCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBExerciseTableViewCell" owner:self options:nil];
        exerciseCell = [nib objectAtIndex:0];
    }
    
    SBExercise *exercise = [self.exercises objectAtIndex:indexPath.row-1];
    exerciseCell.exerciseLabel.text = exercise.name;
    
    return exerciseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return;
    }
    
    SBExercise *exercise = [self.exercises objectAtIndex:indexPath.row - 1];
    
    [self.delegate addExercisesViewController:self didSelectExercise:exercise];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)onCreatedExercise:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    SBCreateExerciseTableViewCell *cell = (SBCreateExerciseTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *exerciseName = cell.exerciseField.text;
    
    SBExercise *exercise = [[SBExercise alloc] init];
    exercise.name = exerciseName;
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:exercise];
    [realm commitWriteTransaction];
    
    self.exercises = [SBExercise allObjects];
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}


@end
