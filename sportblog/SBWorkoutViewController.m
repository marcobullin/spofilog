//
//  SBExercisesViewController.m
//  sportblog
//
//  Created by Marco Bullin on 09/09/14.
//  Copyright (c) 2014 Bullin. All rights reserved.
//

#import "SBWorkoutViewController.h"
#import "SBWorkoutTableViewCell.h"
#import "SBAddExerciseTableViewCell.h"
#import "SBExerciseTableViewCell.h"
#import "SBEditWorkoutTableViewCell.h"
#import "SBWorkout.h"

@interface SBWorkoutViewController ()

@end

@implementation SBWorkoutViewController

int count = 3;
bool isEditWorkoutDetails = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"Workout", nil);
    
    self.tableView.dataSource = self;
    
    SBWorkout *workout = [[SBWorkout alloc] init];
    workout.name = @"Workout";
    workout.date = [NSDate date];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:workout];
    [realm commitWriteTransaction];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"exerciseCell";
    
    if (indexPath.row == 0) {
        cellIdentifier = @"workoutCell";
        SBWorkoutTableViewCell *workoutCell = (SBWorkoutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (workoutCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBWorkoutTableViewCell" owner:self options:nil];
            workoutCell = [nib objectAtIndex:0];
        }
        
        workoutCell.workoutLabel.text = @"Workout";
        workoutCell.dateLabel.text = @"22.03.2014";
        
        return workoutCell;
    }

    if (indexPath.row == 1 && isEditWorkoutDetails) {
        cellIdentifier = @"editWorkoutCell";
        
        SBEditWorkoutTableViewCell *editWorkoutCell = (SBEditWorkoutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (editWorkoutCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBEditWorkoutTableViewCell" owner:self options:nil];
            editWorkoutCell = [nib objectAtIndex:0];
        }
        
        editWorkoutCell.workoutTextField.placeholder = @"Workout";

        return editWorkoutCell;
    }
    
    if ((indexPath.row == 1 && !isEditWorkoutDetails) || (indexPath.row == 2 && isEditWorkoutDetails)) {
        cellIdentifier = @"addExerciseCell";
        
        SBAddExerciseTableViewCell *addExerciseCell = (SBAddExerciseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (addExerciseCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBAddExerciseTableViewCell" owner:self options:nil];
            addExerciseCell = [nib objectAtIndex:0];
        }
        
        addExerciseCell.addExerciseLabel.text = @"Add exercise";
        
        return addExerciseCell;
    }
    
    SBExerciseTableViewCell *exerciseCell = (SBExerciseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (exerciseCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBExerciseTableViewCell" owner:self options:nil];
        exerciseCell = [nib objectAtIndex:0];
    }
    
    exerciseCell.exerciseLabel.text = @"Liegestütze";
    
    return exerciseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    // user touched on workout to edit name or date
    if (indexPath.row == 0) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:row+1 inSection:section];
        
        NSArray *indexPaths = [NSArray arrayWithObject :newIndexPath];
        SBWorkoutTableViewCell *workoutCell = (SBWorkoutTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (isEditWorkoutDetails) {
            isEditWorkoutDetails = NO;
            count -= 1;
            
            [workoutCell.workoutLabel setTextColor:[UIColor blackColor]];
            [workoutCell.dateLabel setTextColor:[UIColor blackColor]];
            
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        } else {
            isEditWorkoutDetails = YES;
            count += 1;
            
            [workoutCell.workoutLabel setTextColor:[UIColor redColor]];
            [workoutCell.dateLabel setTextColor:[UIColor redColor]];
            
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 && isEditWorkoutDetails) {
        UITableViewCell *editWorkoutCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return editWorkoutCell.frame.size.height;
    }
    
    return 44.0;
}

@end
