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
#import "UIColor+SBColor.h"

@interface SBExercisesViewController ()
@property (nonatomic, strong) RLMArray *exercises;
@end

@implementation SBExercisesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.title = NSLocalizedString(@"Exercises", nil);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor tableViewColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
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
    
    [self.view addSubview:self.tableView];
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

        createExerciseCell.exerciseField.placeholder = NSLocalizedString(@"New exercise", nil);
        createExerciseCell.exerciseField.delegate = self;
        createExerciseCell.exerciseField.textColor = [UIColor textColor];
        createExerciseCell.exerciseField.tintColor = [UIColor textColor];
        createExerciseCell.exerciseField.backgroundColor = [UIColor whiteColor];
        createExerciseCell.backgroundColor = [UIColor actionCellColor];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, createExerciseCell.exerciseField.frame.size.height)];
        leftView.backgroundColor = [UIColor clearColor];
        createExerciseCell.exerciseField.leftView = leftView;
        createExerciseCell.exerciseField.leftViewMode = UITextFieldViewModeAlways;
        
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
    exerciseCell.exerciseLabel.textColor = [UIColor textColor];
    exerciseCell.layoutMargins = UIEdgeInsetsZero;
    exerciseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    exerciseCell.backgroundColor = [UIColor clearColor];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}


@end
