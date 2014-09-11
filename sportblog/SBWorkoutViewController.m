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

@interface SBWorkoutViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) bool isEditWorkoutDetails;
@end

@implementation SBWorkoutViewController

int count = 3;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createDateFormatter];
    
    self.navigationItem.title = NSLocalizedString(@"Workout", nil);
    
    self.tableView.dataSource = self;
    
    if (self.workout == nil) {
        self.workout = [[SBWorkout alloc] init];
        self.workout.date = [NSDate date];
    }
}

- (void)createDateFormatter {
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    count = 3;
    
    if (self.isEditWorkoutDetails) {
        count += 1;
    }
    
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
        
        workoutCell.workoutLabel.text = self.workout.name ?: NSLocalizedString(@"Workout", nil);
        workoutCell.dateLabel.text = [self.dateFormatter stringFromDate:self.workout.date];
        
        return workoutCell;
    }

    if (indexPath.row == 1 && self.isEditWorkoutDetails) {
        cellIdentifier = @"editWorkoutCell";
        
        SBEditWorkoutTableViewCell *editWorkoutCell = (SBEditWorkoutTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (editWorkoutCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SBEditWorkoutTableViewCell" owner:self options:nil];
            editWorkoutCell = [nib objectAtIndex:0];
        }
        
        editWorkoutCell.workoutTextField.text = self.workout.name;
        editWorkoutCell.workoutTextField.placeholder = @"Workout";
        
        editWorkoutCell.datePicker.date = self.workout.date;

        return editWorkoutCell;
    }
    
    if ((indexPath.row == 1 && !self.isEditWorkoutDetails) || (indexPath.row == 2 && self.isEditWorkoutDetails)) {
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
        
        if (self.isEditWorkoutDetails) {
            self.isEditWorkoutDetails = NO;
            
            [workoutCell.workoutLabel setTextColor:[UIColor blackColor]];
            [workoutCell.dateLabel setTextColor:[UIColor blackColor]];
            
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        } else {
            self.isEditWorkoutDetails = YES;
            
            [workoutCell.workoutLabel setTextColor:[UIColor redColor]];
            [workoutCell.dateLabel setTextColor:[UIColor redColor]];
            
            [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 && self.isEditWorkoutDetails) {
        UITableViewCell *editWorkoutCell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        return editWorkoutCell.frame.size.height;
    }
    
    return 44.0;
}

- (IBAction)onChangeWorkoutName:(id)sender {
    UITextField *textField = (UITextField *) sender;
    NSString *workoutName = textField.text;
    if ([workoutName isEqualToString:@""]) {
        workoutName = @"Workout";
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    SBWorkoutTableViewCell *workoutCell = (SBWorkoutTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    workoutCell.workoutLabel.text = workoutName;
    
    [self.workout.realm beginWriteTransaction];
    self.workout.name = workoutName;
    [self.workout.realm commitWriteTransaction];
}

- (IBAction)onDateChanged:(UIDatePicker *)sender {
    [self.workout.realm beginWriteTransaction];
    self.workout.date = sender.date;
    [self.workout.realm commitWriteTransaction];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    SBWorkoutTableViewCell *workoutCell = (SBWorkoutTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    workoutCell.dateLabel.text = [self.dateFormatter stringFromDate:sender.date];
}

- (IBAction)onWorkoutCompleted:(id)sender {
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    if (!self.workout.name) {
        self.workout.name = NSLocalizedString(@"Workout", nil);
    }
    
    [realm beginWriteTransaction];
    [realm addObject:self.workout];
    [realm commitWriteTransaction];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
