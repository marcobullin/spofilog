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
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor colorWithRed:140.0f/255.0f green:150.0f/255.0f blue:160.0f/255.0f alpha:1];
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSString *key = @"exercisesImported";
    
    if([preferences objectForKey:key] == nil) {
        SBExercise *exercise = [[SBExercise alloc] init];
        exercise.name = NSLocalizedString(@"Kreuzheuben", nil);
        
        SBExercise *exercise2 = [[SBExercise alloc] init];
        exercise2.name = NSLocalizedString(@"Bankdrücken", nil);
        
        SBExercise *exercise3 = [[SBExercise alloc] init];
        exercise3.name = NSLocalizedString(@"Butterfly", nil);
        
        SBExercise *exercise4 = [[SBExercise alloc] init];
        exercise4.name = NSLocalizedString(@"Bizeps", nil);
        
        SBExercise *exercise5 = [[SBExercise alloc] init];
        exercise5.name = NSLocalizedString(@"Trizeps", nil);
        
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
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.exercises count]+1;
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

        createExerciseCell.backgroundColor = [UIColor clearColor];
        createExerciseCell.exerciseField.backgroundColor = [UIColor clearColor];
        createExerciseCell.exerciseField.placeholder = NSLocalizedString(@"New exercise", nil);
        createExerciseCell.exerciseField.delegate = self;
        createExerciseCell.exerciseField.textColor = [UIColor whiteColor];
        createExerciseCell.exerciseField.layer.borderColor = [[UIColor whiteColor] CGColor];
        createExerciseCell.exerciseField.layer.borderWidth = 1.0;
        
        return createExerciseCell;
    }
    
    cellIdentifier = @"exerciseCell";
    
    SBExerciseTableViewCell *exerciseCell = (SBExerciseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (exerciseCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBExerciseTableViewCell" owner:self options:nil];
        exerciseCell = [nib objectAtIndex:0];
    }
    
    SBExercise *exercise = [self.exercises objectAtIndex:indexPath.row-1];
    exerciseCell.backgroundColor = [UIColor clearColor];
    exerciseCell.exerciseLabel.text = exercise.name;
    exerciseCell.exerciseLabel.textColor = [UIColor whiteColor];
    
    return exerciseCell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    SBCreateExerciseTableViewCell *cell = (SBCreateExerciseTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *exerciseName = [cell.exerciseField.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]];
    
    if ([exerciseName isEqualToString:@""]) {
        [textField resignFirstResponder];
        return YES;
    }
    
    SBExercise *exercise = [[SBExercise alloc] init];
    exercise.name = exerciseName;
    
    [RLMRealm.defaultRealm beginWriteTransaction];
    [RLMRealm.defaultRealm addObject:exercise];
    [RLMRealm.defaultRealm commitWriteTransaction];
    
    self.exercises = [SBExercise allObjects];
    [self.tableView reloadData];
    
    [textField resignFirstResponder];
    
    return YES;
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}


@end
